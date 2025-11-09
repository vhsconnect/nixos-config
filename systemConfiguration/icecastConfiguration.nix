{ config, ... }:
{
  icecast = {
    autoStart = true;
    enable = true;
    mediaDir = "/home/vhs/Audio/icecast";
    port = 8000;
    playlists = [
      "umk"
      "10-25"
    ];

  };
}
