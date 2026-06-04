{ pkgs, ... }:
{

  script = ''
    #! /usr/bin/env fish

    function exitEarly
      echo "Exiting early ..."
      exit 1
    end

    set file $argv[0]
    set errorFile $argv[1]
    set outputDir $argv[2]

    test (${pkgs.wireguard-tools}/bin/wg show interfaces | wc -l) -gt 0; or exitEarly

    set File (realpath $file)
    set ErrorFile (realpath $errorFile)

    set SubDir (date '+%m_%d')
    set OutputFolder (realpath $outputDir/$SubDir)

    mkdir -p $OutputFolder

    echo $File  >> $ErrorFile
    echo $ErrorFile >> $ErrorFile
    echo $OutputFolder >> $ErrorFile

    cat "$File" | xargs -I {} ${pkgs.fish}/bin/fish -c '${pkgs.nix}/bin/nix run github:nixos/nixpkgs#yt-dlp -- -x "$argv[1]" -P "$argv[2]" 2>>"$argv[3]"; or echo "$argv[1]" >> "$argv[3]"' '{}' $OutputFolder $ErrorFile

    echo "" >$File

  '';

}
