-- Loaded into each always-on radio deck (see bbrf.nix), driven by
-- radio-cli.fish over IPC:
--
--   script-message fade TARGET SECS [curve] [stop]
--                                            ramp volume to TARGET over SECS,
--                                            then optionally stop playback.
--                                            curve: "lin" (default) or "eq"
--                                            (equal-power: sin rising / cos
--                                            falling, so two crossfading decks
--                                            superimpose at constant
--                                            loudness instead of dipping)
--   script-message load URL                  silence the deck and load URL;
--                                            user-data/radio/load goes
--                                            pending -> ready once audio is
--                                            flowing, or -> failed
--
-- A failed load leaves the deck idle. A playing stream that ends or errors
-- quits mpv so systemd restarts the deck.

local ramp = nil
local loading = false
local armed = false

local function cancelRamp()
    if ramp then
        ramp:kill()
        ramp = nil
    end
end

local function fade(target, secs, curve, after)
    cancelRamp()
    target = tonumber(target) or 0
    secs = tonumber(secs) or 0
    local from = mp.get_property_number("volume", 0)
    local start = mp.get_time()

    -- equal-power curves: rising side sin, falling side cos. Two decks
    -- crossfading with these keep perceived loudness constant (uncorrelated
    -- signals add in power, and sin^2 + cos^2 = 1), so the tracks blend
    -- instead of dipping and sounding sequential halfway through
    local shape = function(t) return t end
    if curve == "eq" then
        if target >= from then
            shape = function(t) return math.sin(t * math.pi / 2) end
        else
            shape = function(t) return math.cos(t * math.pi / 2) end
        end
    end

    local function step()
        local t = 1
        if secs > 0 then
            t = math.min((mp.get_time() - start) / secs, 1)
        end
        mp.set_property_number("volume", from + (target - from) * shape(t))
        if t >= 1 then
            cancelRamp()
            if after == "stop" then
                mp.command("stop")
            end
        end
    end

    ramp = mp.add_periodic_timer(0.02, step)
    step()
end

mp.register_script_message("fade", fade)

mp.register_script_message("load", function(url)
    loading = true
    armed = false
    mp.set_property("user-data/radio/load", "pending")
    fade(0, 0)
    mp.commandv("loadfile", url)
end)

-- playlist URLs (.pls/.m3u) redirect to a second start-file, so readiness is
-- keyed on playback progress rather than on the first file loading
mp.register_event("start-file", function()
    armed = true
end)

mp.observe_property("playback-time", "number", function(_, t)
    if armed and t and t > 0.5 then
        armed = false
        loading = false
        mp.set_property("user-data/radio/load", "ready")
    end
end)

mp.register_event("end-file", function(e)
    armed = false
    if e.reason ~= "eof" and e.reason ~= "error" then
        return
    end
    if loading then
        loading = false
        mp.set_property("user-data/radio/load", "failed")
    else
        mp.command("quit")
    end
end)
