{
  pkgs,
  ...
}:

let
  lowpassToggle =
    pkgs:
    # bash
    ''
      # Configuration
      LOWPASS_PRESET="lowpass"
      REVERB_PRESET="reverb"
      BALANCED_PRESET="balanced"
      STATE_FILE="$HOME/.config/jamesdsp/toggle_state"

      mkdir -p "$(dirname "$STATE_FILE")"

      if [ -f "$STATE_FILE" ]; then
          CURRENT_STATE=$(cat "$STATE_FILE")
      else
          CURRENT_STATE="balanced"
      fi

      if [ "$CURRENT_STATE" = "$REVERB_PRESET" ] || [ "$CURRENT_STATE" = "$BALANCED_PRESET" ]; then
          ${pkgs.jamesdsp}/bin/jamesdsp --load-preset "$LOWPASS_PRESET"
          echo "$LOWPASS_PRESET" > "$STATE_FILE"
      else
          ${pkgs.jamesdsp}/bin/jamesdsp --load-preset "$BALANCED_PRESET"
          echo "$BALANCED_PRESET" > "$STATE_FILE"
      fi
    '';
  reverbToggle =
    pkgs:
    # bash
    ''
      # Configuration
      LOWPASS_PRESET="lowpass"
      REVERB_PRESET="reverb"
      BALANCED_PRESET="balanced"
      STATE_FILE="$HOME/.config/jamesdsp/toggle_state"

      mkdir -p "$(dirname "$STATE_FILE")"

      if [ -f "$STATE_FILE" ]; then
          CURRENT_STATE=$(cat "$STATE_FILE")
      else
          CURRENT_STATE="balanced"
      fi

      if [ "$CURRENT_STATE" = "$LOWPASS_PRESET" ] || [ "$CURRENT_STATE" = "$BALANCED_PRESET" ]; then
          ${pkgs.jamesdsp}/bin/jamesdsp --load-preset "$REVERB_PRESET"
          echo "$REVERB_PRESET" > "$STATE_FILE"
      else
          echo "Switching to lowpass filter..."
          ${pkgs.jamesdsp}/bin/jamesdsp --load-preset "$BALANCED_PRESET"
          echo "$BALANCED_PRESET" > "$STATE_FILE"
      fi
    '';
in

{

  home.packages = [
    (pkgs.writeScriptBin "lowpass_toggle" (lowpassToggle pkgs))
    (pkgs.writeScriptBin "reverb_toggle" (reverbToggle pkgs))

  ];

}
