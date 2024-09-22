{ pkgs, ... }:
{
  home.packages = with pkgs; [
    docker
    slack
    jetbrains.datagrip
    insomnia
    (google-cloud-sdk.withExtraComponents ([ google-cloud-sdk.components.gke-gcloud-auth-plugin ]))
    google-cloud-sql-proxy
    sops
    kubectl
    kubernetes-helm
    k9s
    tailscale
    sops

    #utils
    lsof
  ];
}
