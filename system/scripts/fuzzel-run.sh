IFS=':' read -ra raw_paths <<< "$PATH"
valid_paths=()
for dir in "${raw_paths[@]}"; do
  [[ -d "$dir" ]] && valid_paths+=("$dir")
done

fd . "${valid_paths[@]}" \
  --max-depth 1 \
  --type x \
  --hidden \
  --follow \
  --format "{/}" \
  | sort -u \
  | fuzzel -d \
    --cache "$XDG_CACHE_HOME/fuzzel-run-history" \
    --prompt "Run ➜ " \
    --placeholder "System Binaries..." \
  | xargs -r -I{} setsid -f {}
