{ config, ... }:
{
  icecast = {
    autoStart = true;
    enable = true;
    mediaDir = "/home/vhs/Audio/icecast";
    port = 8000;
    playlists = [
      "umk"
      "p2010"
      "p2020"
    ];

  };
}
