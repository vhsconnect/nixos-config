#!/usr/bin/env bash
#
# shrink — re-encode every video in the CURRENT directory into ./converted/
#
set -euo pipefail

usage() {
	cat <<'EOF'
downgrade-video — re-encode every video in the current directory into ./converted/

Usage: cd "/path/to/videos" && downgrade-video [options]

Options:
  (none)      interactive: fzf menus for codec, quality, resolution, fps, audio, CPU
  --defaults  no menus: h264, keep size & fps, balanced quality, copy audio, half cores
  --recommended  no menus: the tested recipe — same, plus capped ≤720p (old TVs)
  --all-cores use every core this run (overrides the CPU choice)
  --fresh     forget saved settings + progress for this folder (start over)
  --dry-run   print the ffmpeg commands instead of running them
  --yes, -y   skip the >100-files safety confirmation
  -h, --help  show this help

Details:
  - keeps ALL streams (audio + subtitles) and metadata
  - safe to Ctrl-C and re-run: finished files are tracked in converted/.done.txt
    and skipped automatically; a file interrupted mid-encode simply restarts
  - chosen settings are saved to converted/.settings and reused on the next
    run, so a resumed job keeps identical quality (--fresh to start over)
  - outputs are named "<folder>-<NN>.mkv" (nested folders: "A - B-<NN>.mkv")
EOF
}

# ── args ─────────────────────────────────────────────────────────────────
DRY_RUN=0 DEFAULTS=0 RECOMMENDED=0 ASSUME_YES=0 ALL_CORES=0 FRESH=0
for arg in "$@"; do
	case "$arg" in
	--defaults) DEFAULTS=1 ;;
	--recommended) RECOMMENDED=1 ;;
	--all-cores) ALL_CORES=1 ;;
	--fresh) FRESH=1 ;;
	--dry-run) DRY_RUN=1 ;;
	--yes | -y) ASSUME_YES=1 ;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		echo "unknown option: $arg (see --help)" >&2
		exit 2
		;;
	esac
done

OUT_DIR="converted"
CONTAINER="mkv" # mkv can carry any subtitle format
MUXER=matroska

have_fzf=0
if command -v fzf >/dev/null 2>&1; then have_fzf=1; fi

cores=$(nproc)
half_cores=$((cores / 2))
quarter_cores=$((cores / 4))

# ── option picking ───────────────────────────────────────────────────────
pick() { # pick "PROMPT" "default option" "more options"... → prints choice
	local prompt="$1" sel=""
	shift
	if ((have_fzf)); then
		if ! sel=$(printf '%s\n' "$@" |
			fzf --prompt="$prompt " --height=~16 --layout=reverse --cycle); then
			echo "Cancelled (ESC or Ctrl-C) — aborting, nothing was changed." >&2
			exit 130
		fi
	fi
	if [[ -z "$sel" ]]; then sel="$1"; fi # no fzf → first (default)
	printf '%s' "$sel"
}

# state: reuse saved settings when resuming an interrupted job
RESUME=0
if ((FRESH)); then
	rm -f -- "$OUT_DIR/.settings" "$OUT_DIR/.done.txt"
	echo "--fresh: forgot saved settings and progress for this folder."
fi
if [[ -f "$OUT_DIR/.settings" ]] && [[ -f "$OUT_DIR/.done.txt" ]]; then
	RESUME=1
	# shellcheck disable=SC1090
	source "$OUT_DIR/.settings"
	echo "Resuming previous job — reusing settings from $OUT_DIR/.settings"
	echo "(run with --fresh to start over with different settings)"
fi

if ((RESUME)); then
	: # settings came from the state file
elif ((DEFAULTS)) || ((RECOMMENDED)) || ((!have_fzf)); then
	if ((!have_fzf)) && ((!DEFAULTS)) && ((!RECOMMENDED)); then
		echo "Note: fzf not found — using recommended settings (install fzf for menus)."
	fi
	# recommended recipe (validated on a 720p-TV library):
	#   h264 CRF 24, preset medium, cap at 720p, keep source fps,
	#   copy audio untouched, half the cores — ~60% smaller, plays on anything
	VIDEO_CODEC=libx264
	CRF=24
	PRESET=medium
	SCALE_HEIGHT=0
	FPS=0
	AUDIO_COPY=1
	AUDIO_BITRATE=""
	THREADS=$half_cores
	if ((RECOMMENDED)); then
		SCALE_HEIGHT=720
	fi
else
	sel=$(pick "Video codec:" \
		"h264 — plays on anything (old TVs, consoles, sticks)" \
		"h265 — ~30% smaller, needs a modern player")
	case "$sel" in h264*) VIDEO_CODEC=libx264 ;; *) VIDEO_CODEC=libx265 ;; esac

	if [[ "$VIDEO_CODEC" == "libx265" ]]; then
		# x265 CRF scale differs: roughly x264_crf + 4 ≈ same quality
		sel=$(pick "Quality (h265 scale):" \
			"CRF 28 - balanced, big savings (recommended)" \
			"CRF 25 - high quality, mild savings" \
			"CRF 22 - near lossless, large files" \
			"CRF 30 - small, aggressive" \
			"CRF 32 - tiny, potato tier")
	else
		sel=$(pick "Quality (h264 scale):" \
			"CRF 24 - balanced, big savings (recommended)" \
			"CRF 21 - high quality, mild savings" \
			"CRF 18 - near lossless, large files" \
			"CRF 26 - small, aggressive" \
			"CRF 28 - tiny, potato tier")
	fi
	CRF=${sel#CRF }
	CRF=${CRF%% *}

	sel=$(pick "Resolution:" \
		"keep original" \
		"1080 — cap height at 1080" \
		"720 — cap height at 720 (old TVs)" \
		"576 — cap height at 576" \
		"480 — cap height at 480")
	case "${sel%% *}" in
	keep) SCALE_HEIGHT=0 ;;
	*) SCALE_HEIGHT=${sel%% *} ;;
	esac

	sel=$(pick "Frame rate:" \
		"keep original — dropping fps saves ~nothing" \
		"24" "23.976" "20" "16" "12")
	case "${sel%% *}" in
	keep) FPS=0 ;;
	*) FPS=${sel%% *} ;;
	esac

	sel=$(pick "Encoder preset (see note below menu):" \
		"medium - balanced speed and size (recommended)" \
		"slow - smaller files, ~2x slower to encode" \
		"veryslow - smallest files, very slow to encode" \
		"fast - bigger files, encodes quicker" \
		"veryfast - biggest files, quickest encode")
	PRESET=${sel%% *}

	sel=$(pick "Audio:" \
		"copy — keep audio untouched (free, lossless)" \
		"aac 128k — re-encode" \
		"aac 96k — re-encode, smaller" \
		"aac 64k — re-encode, tiny")
	case "$sel" in
	copy*)
		AUDIO_COPY=1
		AUDIO_BITRATE=""
		;;
	*128k*)
		AUDIO_COPY=0
		AUDIO_BITRATE=128k
		;;
	*96k*)
		AUDIO_COPY=0
		AUDIO_BITRATE=96k
		;;
	*)
		AUDIO_COPY=0
		AUDIO_BITRATE=64k
		;;
	esac

	sel=$(pick "CPU usage ($cores cores):" \
		"half — $half_cores cores, cool and quick" \
		"all — $cores cores, fastest but hot" \
		"quarter — $quarter_cores cores, coolest" \
		"8" "4" "2")
	case "${sel%% *}" in
	half) THREADS=$half_cores ;;
	all) THREADS=0 ;;
	quarter) THREADS=$quarter_cores ;;
	*) THREADS=${sel%% *} ;;
	esac
fi

if ((ALL_CORES)); then
	echo "Override: using all $cores cores this run"
	THREADS=0
fi

# map quality word → CRF per codec — no longer needed: CRF comes straight from the menu
# codec / filter arguments
vargs=(-c:v "$VIDEO_CODEC" -crf "$CRF" -preset "$PRESET" -threads "$THREADS")
if [[ "$VIDEO_CODEC" == "libx264" ]]; then
	vargs+=(-pix_fmt yuv420p) # 8-bit: max compatibility with old players
fi
audio_args=()
if ((AUDIO_COPY)); then
	audio_args+=(-c:a copy)
else
	audio_args+=(-c:a aac -b:a "$AUDIO_BITRATE")
fi

# ── gather files ─────────────────────────────────────────────────────────
mapfile -t files < <(find . -path "./$OUT_DIR" -prune -o -type f \
	\( -iname '*.mkv' -o -iname '*.mp4' -o -iname '*.avi' -o -iname '*.mov' \
	-o -iname '*.m4v' -o -iname '*.webm' -o -iname '*.ts' \) -print | sort)
total=${#files[@]}

if ((total == 0)); then
	echo "No video files found in: $PWD"
	exit 1
fi

if ((total > 100)) && ((!ASSUME_YES)); then
	sel=$(pick "WARNING: $total files found — continue? " \
		"abort" "yes — convert all $total files")
	if [[ "$sel" != yes* ]]; then
		echo "Aborted (use --yes to skip this check)."
		exit 1
	fi
fi

res_disp=original
if ((SCALE_HEIGHT > 0)); then res_disp="≤${SCALE_HEIGHT}p"; fi
fps_disp=source
if ((FPS > 0)); then fps_disp="${FPS}fps"; fi
aud_disp=copy
if ((!AUDIO_COPY)); then aud_disp="aac ${AUDIO_BITRATE}"; fi
thr_disp=all
if ((THREADS > 0)); then thr_disp="$THREADS"; fi

echo "Found $total files in: $PWD"
echo "Settings: codec=$VIDEO_CODEC crf=$CRF preset=$PRESET res=$res_disp fps=$fps_disp audio=$aud_disp threads=$thr_disp"
echo "Output:   $OUT_DIR/  (Ctrl-C anytime; re-run resumes via $OUT_DIR/.done.txt)"

# ── resume cursor ────────────────────────────────────────────────────────
CURSOR_FILE="$OUT_DIR/.done.txt"
SETTINGS_FILE="$OUT_DIR/.settings"
mkdir -p "$OUT_DIR"
if ((!RESUME)) && ((!DRY_RUN)); then
	# remember this job's settings so a resume reuses them exactly
	cat >"$SETTINGS_FILE" <<EOF
VIDEO_CODEC=$VIDEO_CODEC
CRF=$CRF
PRESET=$PRESET
SCALE_HEIGHT=$SCALE_HEIGHT
FPS=$FPS
AUDIO_COPY=$AUDIO_COPY
AUDIO_BITRATE=$AUDIO_BITRATE
THREADS=$THREADS
EOF
	[[ -f "$CURSOR_FILE" ]] || : >"$CURSOR_FILE"
fi
declare -A done_set=()
if [[ -f "$CURSOR_FILE" ]]; then
	while IFS= read -r line; do
		[[ -n "$line" ]] && done_set["$line"]=1
	done <"$CURSOR_FILE"
fi

tmp_out=""
trap '[[ -n "$tmp_out" ]] && rm -f -- "$tmp_out"' EXIT
interrupted=0
trap 'interrupted=1' INT TERM

# final go/abort for interactive runs
if ((!DEFAULTS)) && ((have_fzf)); then
	sel=$(pick "Start converting $total files? " \
		"go — start now" "abort")
	if [[ "$sel" != go* ]]; then
		echo "Aborted."
		exit 0
	fi
fi
echo

# ── main loop ────────────────────────────────────────────────────────────
count=0
last_folder=""
skipped=0
completed=0
bytes_before=0
bytes_after=0
start=$SECONDS
PAD=2

for f in "${files[@]}"; do
	label=$(dirname "$f" | sed -e 's|^\./||' -e 's|/| - |g' | tr -d ' ')
	if [[ -z "$label" || "$label" == "." ]]; then
		label=$(basename "$PWD" | tr -d ' ') # videos sit directly in this dir
	fi
	count=$((count + 1))

	# per-folder counter: resets when the folder label changes (sorted order)
	if [[ "$label" != "$last_folder" ]]; then
		ep=0
		last_folder="$label"
	fi
	ep=$((ep + 1))
	padded=$(printf "%0${PAD}d" "$ep")

	out="$OUT_DIR/${label}-${padded}.${CONTAINER}"

	if [[ -n "${done_set[$out]:-}" ]]; then
		echo "[$count/$total] SKIP (in cursor): $out"
		skipped=$((skipped + 1))
		continue
	fi
	if [[ -s "$out" ]]; then
		printf '%s\n' "$out" >>"$CURSOR_FILE"
		done_set["$out"]=1
		echo "[$count/$total] SKIP (exists, added to cursor): $out"
		skipped=$((skipped + 1))
		continue
	fi

	sz_in=$(stat -c%s "$f")
	echo "[$count/$total] $(basename "$f")"
	echo "        → $out"

	# video filter chain: optional frame rate + optional downscale (never upscales)
	vf=""
	if ((FPS > 0)); then vf="fps=$FPS"; fi
	if ((SCALE_HEIGHT > 0)); then
		part="scale=-2:'min($SCALE_HEIGHT,ih)'"
		if [[ -n "$vf" ]]; then vf="$vf,$part"; else vf="$part"; fi
	fi

	# encode to a temp name so a killed run never leaves a fake-finished file
	tmp_out="$out.part"
	rm -f -- "$tmp_out"
	file_start=$SECONDS

	cmd=(ffmpeg -hide_banner -loglevel error -nostdin -y
		-i "$f"
		-map 0           # every video/audio/subtitle stream
		-map_metadata 0) # keep global metadata
	[[ -n "$vf" ]] && cmd+=(-vf "$vf")
	cmd+=("${vargs[@]}" "${audio_args[@]}"
		-c:s copy   # subtitles pass through untouched
		-f "$MUXER" # explicit: the ".part" hides the extension
		"$tmp_out")

	if ((DRY_RUN)); then
		printf '  %q ' "${cmd[@]}"
		echo
		echo
		tmp_out=""
		continue
	fi

	rc=0
	"${cmd[@]}" || rc=$?

	if ((interrupted)) || ((rc == 255)); then # Ctrl-C / TERM (ffmpeg exits 255 when signalled)
		echo
		echo "Interrupted. Progress saved — run downgrade-video again to resume."
		exit 130
	fi

	if [[ "$rc" -eq 0 ]]; then
		mv -- "$tmp_out" "$out" # atomic: file exists ⟺ fully done
		printf '%s\n' "$out" >>"$CURSOR_FILE"
		done_set["$out"]=1
		completed=$((completed + 1))
		sz_out=$(stat -c%s "$out")
		bytes_before=$((bytes_before + sz_in))
		bytes_after=$((bytes_after + sz_out))
		file_secs=$((SECONDS - file_start))
		session_secs=$((SECONDS - start))
		avg=$((session_secs / (completed > 0 ? completed : 1)))
		remaining=$((total - skipped - completed))
		eta=$((avg * remaining / 60))
		printf '        %s → %s  (%ss, ~%s min left, %d done / %d remaining)\n' \
			"$(numfmt --to=iec --suffix=B "$sz_in")" \
			"$(numfmt --to=iec --suffix=B "$sz_out")" \
			"$file_secs" "$eta" "$((completed + skipped))" "$remaining"
	else
		echo "        FAILED (rc=$rc), keeping cursor clean so it retries next run"
		rm -f -- "$tmp_out"
	fi
	tmp_out=""
	echo
done

# ── summary ──────────────────────────────────────────────────────────────
echo "─────────────────────────────────────────────"
if ((DRY_RUN)); then
	echo "Dry run complete — no files were written."
else
	mins=$((SECONDS / 60))
	echo "Done in ${mins}m: $(numfmt --to=iec --suffix=B "$bytes_before") → $(numfmt --to=iec --suffix=B "$bytes_after")"
	echo "Cursor: ${#done_set[@]} of $total finished ($CURSOR_FILE)"
	echo "Outputs in: $OUT_DIR/"
fi
