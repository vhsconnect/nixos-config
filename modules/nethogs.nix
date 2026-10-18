{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.nethogs-exporter;

  # Runs nethogs in two-window trace mode (-c 2: the first window is always
  # zero because nethogs needs two windows to compute rates) in a loop, writing
  # the last snapshot to /run/nethogs/data.json (world readable) for
  # unprivileged consumers (waybar custom/netmon). Re-resolves the
  # default-route device every cycle so wifi/eth switching is picked up
  # without service restarts.
  exporter = pkgs.writeTextFile {
    name = "nethogs-exporter.py";
    executable = true;
    text = ''
      #!${pkgs.python3}/bin/python3
      # exporter refreshed every N seconds: nethogs -t -d N -c 2 <dev>
      import json
      import os
      import pwd
      import re
      import subprocess
      import sys
      import time

      NETHOGS = "${pkgs.nethogs}/bin/nethogs"
      OUT = "/run/nethogs/data.json"
      MAX_PROCS = 10

      # trace line: <name>/<pid>/<uid>\t<sent>\t<recv>  (sent/recv in KB/s)
      LINE = re.compile(
          r"^(?P<name>.*)/(?P<pid>-?\d+)/(?P<uid>-?\d+)\t(?P<sent>[\d.]+)\t(?P<recv>[\d.]+)$"
      )

      REFRESH = int(sys.argv[1]) if len(sys.argv) > 1 else 4


      def default_dev():
          # device of the default ipv4 route; /proc/net/route columns:
          # iface dest gateway flags ... (flags bit 2 = RTF_GATEWAY)
          try:
              with open("/proc/net/route") as f:
                  next(f)
                  for line in f:
                      p = line.split()
                      if len(p) > 3 and p[1] == "00000000" and (int(p[3], 16) & 2):
                          return p[0]
          except (OSError, StopIteration, ValueError):
              pass
          for d in sorted(os.listdir("/sys/class/net")):
              if d != "lo":
                  return d
          return "lo"


      def user_of(uid):
          try:
              return pwd.getpwuid(uid).pw_name
          except KeyError:
              return str(uid)


      def write(data):
          tmp = OUT + ".tmp"
          with open(tmp, "w") as f:
              json.dump(data, f)
          os.replace(tmp, OUT)


      def sample():
          dev = default_dev()
          try:
              proc = subprocess.run(
                  [NETHOGS, "-t", "-v", "0", "-d", str(REFRESH), "-c", "2", dev],
                  capture_output=True,
                  text=True,
                  timeout=REFRESH * 3,
              )
          except (OSError, subprocess.TimeoutExpired) as e:
              print("nethogs failed: {}".format(e), file=sys.stderr)
              return
          # first refresh window is always zero; keep only the last block
          tail = proc.stdout.rsplit("Refreshing:", 1)
          out = tail[1] if len(tail) == 2 else proc.stdout
          procs = []
          up = 0.0
          down = 0.0
          for line in out.splitlines():
              m = LINE.match(line)
              if not m:
                  continue
              u = float(m.group("sent"))
              d = float(m.group("recv"))
              up += u
              down += d
              procs.append(
                  {
                      "name": m.group("name")[:48],
                      "pid": int(m.group("pid")),
                      "uid": int(m.group("uid")),
                      "user": user_of(int(m.group("uid"))),
                      "up": round(u, 2),
                      "down": round(d, 2),
                  }
              )
          procs.sort(key=lambda p: p["up"] + p["down"], reverse=True)
          write(
              {
                  "dev": dev,
                  "ts": int(time.time()),
                  "total_up": round(up, 2),
                  "total_down": round(down, 2),
                  "procs": procs[:MAX_PROCS],
              }
          )


      def main():
          while True:
              try:
                  sample()
              except Exception as e:
                  print("sample error: {}".format(e), file=sys.stderr)
              time.sleep(1)


      if __name__ == "__main__":
          main()
    '';
  };
in
{

  options.services.nethogs-exporter = with lib; {
    enable = mkEnableOption ''
      per-process network accounting via nethogs, exported to /run/nethogs/data.json
      (consumed by the waybar custom/netmon module)
    '';

    refreshSeconds = mkOption {
      type = types.int;
      default = 4;
      description = "nethogs accounting window in seconds (lower = fresher, more wakeups)";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.nethogs-exporter = {
      description = "nethogs trace exporter -> /run/nethogs/data.json";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = "${exporter} ${toString cfg.refreshSeconds}";
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
        # stay out of the way of real work
        Nice = 10;
        CPUWeight = 25;
        IOSchedulingClass = "idle";
        # hardening: only what nethogs needs (raw capture + /proc of all users)
        CapabilityBoundingSet = [
          "CAP_NET_RAW"
          "CAP_NET_ADMIN"
          "CAP_SYS_PTRACE"
        ];
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        # managed /run/nethogs dir: created on start, wiped on stop,
        # world-readable 0644 file inside, writable despite ProtectSystem
        RuntimeDirectory = "nethogs";
        RuntimeDirectoryMode = "0755";
      };
    };
  };
}
