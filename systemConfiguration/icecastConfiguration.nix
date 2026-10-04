{
  port ? 8000,
  ...
}:
{
  icecast = {
    autoStart = true;
    enable = true;
    mediaDir = "/home/vhs/Audio";
    playlistsDir = "/home/vhs/Audio/icecast";
    inherit port;
    playlists = [
      "playlist1"
      "playlist2"
    ];
  };
}
