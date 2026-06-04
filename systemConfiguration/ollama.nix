{ pkgs, ... }:
{

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1031";
    };
    rocmOverrideGfx = "10.3.0";
  };

}
