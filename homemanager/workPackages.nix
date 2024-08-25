{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    colima
    docker
    slack
    jetbrains.datagrip
    bruno
    (google-cloud-sdk.withExtraComponents ([ google-cloud-sdk.components.gke-gcloud-auth-plugin ]))
    google-cloud-sql-proxy
    sops
    kubectl
    kubernetes-helm
    k9s
    tailscale
  ];
}
