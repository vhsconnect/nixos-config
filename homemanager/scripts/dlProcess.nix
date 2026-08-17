{ pkgs, ... }:
{

  script = ''
    #! /usr/bin/env bb

    (require '[babashka.cli :as cli]
             '[clojure.string :as s]
             '[babashka.process :refer [sh shell]])

    (def cli-options
      {:file {:coerce :string}
       :log-file {:coerce :string}
       :error-file {:coerce :string}
       :output-dir {:coerce :string}})

    (let [opts (cli/parse-opts *command-line-args* {:spec cli-options})

          {:keys [file log-file error-file output-dir]} opts
          contents (:out (sh (str "cat " file)) true)
          arr (s/split contents #"\n")
          vpn-interfaces  (:out
                           (sh [
                           "${pkgs.bash}/bin/bash"
                           "-c" 
                           "${pkgs.wireguard-tools}/bin/wg show interfaces | wc -l"])
                           true)]
      (println vpn-interfaces)
      (when (not (= "0" vpn-interfaces))
        (doseq [x arr]
          (let [filename (str output-dir "/%(title)s.%(ext)s")
                p (shell
                   {:out :string :error :string :continue true}
                   (str
                    "${pkgs.nix}/bin/nix run github:nixos/nixpkgs#yt-dlp -- -o "
                    filename
                    " -x "
                    x))]
            (spit log-file (str (:out p) "\n") :append true)
            (spit error-file (str (:error p) "\n") :append true)))))

  '';

}
