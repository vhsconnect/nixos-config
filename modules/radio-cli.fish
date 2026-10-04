
# radio - control the bbrf always-on radio via mpv's IPC interface.
#
#   radio on             un-mute
#   radio off            mute
#   radio toggle         flip mute
#       (on/off/toggle also accept --waybar: emit the waybar payload
#        after the state change instead of a human-readable line)
#   radio status         show mute state and current station
#   radio metadata       show current station and track title
#   radio metadata --waybar  emit waybar custom-module JSON
#   radio stations       list station names from bbrf favorites
#   radio station NAME   switch to station NAME (looked up in bbrf favorites)
#   radio pick           browse stations with rofi and switch to the choice
#
# SOCKET, PORT, DEFAULT_STATION, CURL, JQ and SOCAT are prepended
# by modules/bbrf.nix.

function requireSocket
    if not test -S $SOCKET
        echo "radio: not running (no socket at $SOCKET)" >&2
        exit 1
    end
end

function ipc
    printf '%s\n' $argv | $SOCAT - $SOCKET 2>/dev/null
end

function jsonEscape
    printf '%s' $argv | $JQ -Rs .
end

# query PROPERTY -> prints the property value, empty on failure
function query
    set -l resp (ipc (printf '{"command":["get_property","%s"]}' $argv[1]))
    if test (count $resp) -eq 0; or not string match -q '*"error":"success"*' -- $resp[1]
        return 1
    end
    printf '%s\n' $resp[1] | $JQ -r '.data | if . == null then "" else tostring end'
end

# media-title, with stream-side double-encoding repaired: some streams send
# UTF-8 that was misread as latin-1 and re-encoded ("L<U+00E2><U+0080><U+0099>Esprit"
# instead of "L'Esprit"). Re-encode to latin-1 and decode back as UTF-8, but
# keep the original unless that round trip is lossless (no chars above latin-1
# dropped, and the re-encoded bytes are valid UTF-8).
function getTitle
    set -l title (query media-title)
    if test -z "$title"
        return
    end
    printf '%s\n' $title | $PY -c 'import sys; s = sys.stdin.buffer.readline().rstrip(b"\n").decode("utf-8", "replace"); b = s.encode("latin-1", "ignore"); print(b.decode("utf-8") if b.decode("latin-1") == s and b.decode("utf-8", "replace").encode() == b else s)'
end

function stations
    $CURL -s "http://localhost:$PORT/favorites" | $JQ -r '.[].name'
end

function resolveStation
    set -l url (
        $CURL -s "http://localhost:$PORT/favorites" |
        $JQ -r --arg name "$argv[1]" '.[] | select(.name == $name) | .url'
    )
    if test (count $url) -eq 0
        return 1
    end
    echo $url[1]
end

function showStatus
    requireSocket

    set -l label audible
    set -l mute (query mute)
    if test "$mute" = true
        set label muted
    end

    set -l station (query user-data/bbrf/name)
    if test -z "$station"
        set station $DEFAULT_STATION
    end

    echo "radio: $label - $station"

    set -l title (getTitle)
    if test -n "$title"
        echo "  $title"
    end
end

# waybar custom-module payload (return-type: json)
function emitWaybar
    if not test -S $SOCKET
        $JQ -cn '{text:"", class:"off", tooltip:"radio not running"}'
        return
    end

    set -l state audible
    set -l label audible
    set -l mute (query mute)
    if test "$mute" = true
        set state muted
        set label muted
    end

    set -l station (query user-data/bbrf/name)
    if test -z "$station"
        set station $DEFAULT_STATION
    end

    set -l title (getTitle)

    # song title in the bar itself, station name as fallback
    set -l text $station
    if test -n "$title"
        set text $title
    end

    if test (string length $text) -gt 40
        set text (string sub -l 39 $text)"…"
    end

    set -l tooltip "bbrf radio: $label"
    if test -n "$title"
        set tooltip "$tooltip\n$station\n$title"
    end

    $JQ -cn --arg t "$text" --arg c $state --arg T "$tooltip" '{text:$t, class:$c, tooltip:$T}'
end

# after a mute change: human-readable line, or the waybar payload with --waybar
function reportMute
    if contains -- --waybar $argv
        emitWaybar
    else
        echo "radio: $argv[1]"
    end
end

function switchStation
    requireSocket

    set -l name $argv[1]
    set -l url (resolveStation $name)
    or begin
        echo "radio: unknown station '$name' (see: radio stations)" >&2
        exit 1
    end

    set -l resp (ipc (printf '{"command":["loadfile",%s]}' (jsonEscape $url)))
    if not test (count $resp) -gt 0; or not string match -q '*"error":"success"*' -- $resp[1]
        echo "radio: mpv failed to load $url" >&2
        exit 1
    end

    # remember the station so `radio status` (and future tools) can show it
    ipc (printf '{"command":["set_property","user-data/bbrf/name",%s]}' (jsonEscape $name)) > /dev/null
    echo "radio: now playing $name"
end

if test (count $argv) -eq 0
    showStatus
    exit 0
end

switch $argv[1]
    case on
        requireSocket
        ipc '{"command":["set_property","mute",false]}' > /dev/null
        reportMute audible $argv
    case off
        requireSocket
        ipc '{"command":["set_property","mute",true]}' > /dev/null
        reportMute muted $argv
    case toggle
        requireSocket
        set -l mute (query mute)
        if test "$mute" = true
            ipc '{"command":["set_property","mute",false]}' > /dev/null
            reportMute audible $argv
        else
            ipc '{"command":["set_property","mute",true]}' > /dev/null
            reportMute muted $argv
        end
    case station
        if test (count $argv) -lt 2
            echo "usage: radio station NAME" >&2
            exit 1
        end
        switchStation $argv[2]
    case pick
        requireSocket
        if not type -q rofi
            echo "radio: rofi not found in PATH" >&2
            exit 1
        end
        set -l choice (stations | $SORT -u | rofi -dmenu -i -matching fuzzy -p "Radio")
        if test (count $choice) -eq 0
            exit 0
        end
        switchStation $choice[1]
    case metadata
        # --waybar: machine-readable payload for the waybar custom module,
        # otherwise same human-readable output as status
        if contains -- --waybar $argv
            emitWaybar
        else
            showStatus
        end
    case stations
        stations
    case status
        showStatus
    case '*'
        echo "usage: radio [on|off|toggle [--waybar]|status|metadata [--waybar]|stations|station NAME|pick]" >&2
        exit 1
end
