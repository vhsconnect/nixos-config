
# radio - control the bbrf always-on radio.
#
# The radio is two mpv decks (radio-a.sock, radio-b.sock) running
# radio-deck.lua. $SOCKET is a symlink to the live deck; switching station
# loads the idle deck, waits for it to play, then crossfades onto it.
#
#   radio on             fade in
#   radio off            fade out
#   radio toggle         flip between the two
#       (on/off/toggle also accept --waybar: emit the waybar payload
#        after the state change instead of a human-readable line)
#   radio status         show audible state and current station
#   radio metadata       show current station and track title
#   radio metadata --waybar  emit waybar custom-module JSON
#   radio stations       list station names from bbrf favorites
#   radio station NAME   crossfade to station NAME (looked up in bbrf favorites)
#   radio next           crossfade to the next station in bbrf favorites
#                        that plays, skipping dead ones
#   radio pick           browse stations with rofi and switch to the choice
#
# SOCKET, PORT, DEFAULT_STATION, CURL, JQ, SOCAT, SORT, PY, FLOCK, LN, MV and
# SLEEP are prepended by bbrf.nix.

set SELF (status filename)
set RUNDIR (path dirname $SOCKET)
set DECKS $RUNDIR/radio-a.sock $RUNDIR/radio-b.sock
set STATE $RUNDIR/radio.station
set LOCK $RUNDIR/radio.lock
set FADE_SECS 1.5
set CROSSFADE_SECS 3
set READY_TIMEOUT_SECS 15

function requireSocket
    if not test -S $SOCKET
        echo "radio: not running (no socket at $SOCKET)" >&2
        exit 1
    end
end

# ipcTo SOCKET JSON...
function ipcTo
    printf '%s\n' $argv[2..-1] | $SOCAT - $argv[1] 2>/dev/null
end

function ipc
    ipcTo $SOCKET $argv
end

function jsonEscape
    printf '%s' $argv | $JQ -Rs .
end

# queryOn SOCKET PROPERTY -> prints the property value, empty on failure
function queryOn
    set -l resp (ipcTo $argv[1] (printf '{"command":["get_property","%s"]}' $argv[2]))
    if test (count $resp) -eq 0; or not string match -q '*"error":"success"*' -- $resp[1]
        return 1
    end
    printf '%s\n' $resp[1] | $JQ -r '.data | if . == null then "" else tostring end'
end

function query
    queryOn $SOCKET $argv[1]
end

function currentStation
    set -l name
    test -r $STATE; and read name < $STATE
    if test -n "$name"
        echo $name
    else
        echo $DEFAULT_STATION
    end
end

function isAudible
    set -l audible (query user-data/radio/audible)
    test "$audible" = true
end

# fadeDeck SOCKET true|false SECS [lin|eq]: mark the deck (in)audible and ramp
# it there; "eq" shapes the ramp equal-power for crossfading
function fadeDeck
    set -l target 0
    test "$argv[2]" = true; and set target 100
    set -l curve lin
    test (count $argv) -ge 4; and set curve $argv[4]
    ipcTo $argv[1] (printf '{"command":["set_property","user-data/radio/audible",%s]}' $argv[2]) > /dev/null
    ipcTo $argv[1] (printf '{"command":["script-message","fade","%s","%s","%s"]}' $target $argv[3] $curve) > /dev/null
end

function idleDeck
    set -l live (path basename (path resolve $SOCKET))
    for deck in $DECKS
        if test (path basename $deck) != $live
            echo $deck
            return
        end
    end
    return 1
end

# waitReady SOCKET: until the deck's freshly loaded stream plays (or fails)
function waitReady
    set -l polls (math "$READY_TIMEOUT_SECS * 5")
    while test $polls -gt 0
        set -l load (queryOn $argv[1] user-data/radio/load)
        or return 1
        switch $load
            case ready
                return 0
            case failed
                return 1
        end
        $SLEEP 0.2
        set polls (math $polls - 1)
    end
    return 1
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

    set -l label muted
    isAudible; and set label audible

    set -l station (currentStation)

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

    set -l state muted
    isAudible; and set state audible

    set -l station (currentStation)

    set -l title (getTitle)

    # song title in the bar itself, station name as fallback
    set -l text $station
    if test -n "$title"
        set text $title
    end

    if test (string length $text) -gt 40
        set text (string sub -l 39 $text)"…"
    end

    set -l tooltip "bbrf radio: $state"
    if test -n "$title"
        set tooltip "$tooltip\n$station\n$title"
    end

    $JQ -cn --arg t "$text" --arg c $state --arg T "$tooltip" '{text:$t, class:$c, tooltip:$T}'
end

# after a fade: human-readable line, or the waybar payload with --waybar
function reportState
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

    set -l idle (idleDeck)
    if not test -S "$idle"
        echo "radio: idle deck not running" >&2
        exit 1
    end

    ipcTo $idle '{"command":["set_property","user-data/radio/load","pending"]}' > /dev/null
    ipcTo $idle (printf '{"command":["script-message","load",%s]}' (jsonEscape $url)) > /dev/null
    if not waitReady $idle
        ipcTo $idle '{"command":["stop"]}' > /dev/null
        echo "radio: $name did not start playing, staying on "(currentStation) >&2
        return 1
    end

    set -l audible false
    isAudible; and set audible true
    # equal-power on both sides: the ramps superimpose at constant loudness
    # instead of dipping (and sounding sequential) halfway through
    fadeDeck $idle $audible $CROSSFADE_SECS eq
    ipc (printf '{"command":["script-message","fade","0","%s","eq","stop"]}' $CROSSFADE_SECS) > /dev/null

    $LN -sfn (path basename $idle) $SOCKET.new
    $MV -Tf $SOCKET.new $SOCKET
    echo $name > $STATE
    echo "radio: now playing $name"
end

# bbrf favorites in order, rotated to start after the current station
function stationsAfter
    set -l names (stations)
    set -l n (count $names)
    set -l i (contains -i -- (currentStation) $names)
    or set i 0
    set -l k 1
    while test $k -le $n
        set -l j (math "($i + $k - 1) % $n + 1")
        test $j -ne $i; and echo $names[$j]
        set k (math $k + 1)
    end
end

# station switches are serialised: re-run under flock
if contains -- "$argv[1]" station next; and not set -q RADIO_LOCKED
    set -gx RADIO_LOCKED 1
    exec $FLOCK -w 30 $LOCK $SELF $argv
end

if test (count $argv) -eq 0
    showStatus
    exit 0
end

switch $argv[1]
    case on
        requireSocket
        fadeDeck $SOCKET true $FADE_SECS
        reportState audible $argv
    case off
        requireSocket
        fadeDeck $SOCKET false $FADE_SECS
        reportState muted $argv
    case toggle
        requireSocket
        if isAudible
            fadeDeck $SOCKET false $FADE_SECS
            reportState muted $argv
        else
            fadeDeck $SOCKET true $FADE_SECS
            reportState audible $argv
        end
    case station
        if test (count $argv) -lt 2
            echo "usage: radio station NAME" >&2
            exit 1
        end
        switchStation $argv[2]
        or exit 1
    case next
        requireSocket
        for name in (stationsAfter)
            switchStation $name; and exit 0
        end
        echo "radio: no other station would play" >&2
        exit 1
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
        exec $SELF station $choice[1]
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
        echo "usage: radio [on|off|toggle [--waybar]|status|metadata [--waybar]|stations|station NAME|next|pick]" >&2
        exit 1
end
