{ user, ... }:
{
  services.xscreensaver = {
    enable = if user.usei3 then true else false;
    settings = {
      timeout = "30";
    };
  };

}
