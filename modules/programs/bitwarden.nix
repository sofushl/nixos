# Copyright (C) 2026 Sofus Højberg Lind
# SPDX-License-Identifier: AGPL-3.0-or-later

{
  flake.homeModules.bitwarden =
    { userconf, pkgs, ... }:
    # REQUIRES PRESERVATION OF "$HOME/.config/Bitwarden CLI"

    let
      server = "https://${userconf.vaultDom}";
      common = ''
        [ "$(bw config server)" = "${server}" ] || bw config server "${server}" >/dev/null

        case "$(bw status | jq -r .status)" in
          unauthenticated) BW_SESSION="$(bw login --raw)" ;;
          locked) BW_SESSION="$(bw unlock --raw)" ;;
        esac
        export BW_SESSION
        bw sync >/dev/null

        # pull_one <item> <file>: write the item's notes to <file> (mode 600)
        pull_one() {
          local item="$1" file="$2" tmp notes
          # fetch first: a failed lookup must not replace the file with an empty one
          notes="$(bw get notes "$item")" || return 1
          mkdir -p "$(dirname "$file")"
          tmp="$(mktemp "$file.XXXXXX")"
          printf '%s\n' "$notes" > "$tmp"
          mv "$tmp" "$file"
          echo "Wrote $file from Bitwarden item $item"
        }

        # push_one <item> <file>: create or update the secure note <item>
        push_one() {
          local item="$1" file="$2" matches count
          [ -r "$file" ] || { echo "Missing $file" >&2; return 1; }
          # --rawfile, not --arg: keeps the secret out of argv (visible in /proc)
          # list failure aborts (set -e): only an empty result may lead to create
          matches="$(bw list items --search "$item" | jq --arg name "$item" '[.[] | select(.name == $name)]')"
          count="$(jq length <<<"$matches")"
          case "$count" in
            0)
              # type 2 = secure note
              jq -n --rawfile n "$file" --arg name "$item" \
                '{type: 2, name: $name, notes: ($n | rtrimstr("\n")), secureNote: {type: 0}}' \
                | bw encode \
                | bw create item >/dev/null
              echo "Created Bitwarden item $item"
              ;;
            1)
              jq --rawfile n "$file" '.[0] | .notes = ($n | rtrimstr("\n"))' <<<"$matches" \
                | bw encode \
                | bw edit item "$(jq -r '.[0].id' <<<"$matches")" >/dev/null
              echo "Updated Bitwarden item $item"
              ;;
            *)
              echo "Found $count Bitwarden items named $item; remove duplicates first" >&2
              return 1
              ;;
          esac
        }
      '';

      mkSync =
        name: entries:
        let
          calls = fn: pkgs.lib.concatMapStringsSep "\n" (e: "${fn} \"${e.item}\" \"${e.file}\"") entries;
          mk =
            direction:
            pkgs.writeShellApplication {
              name = "${name}-${direction}";
              runtimeInputs = [
                pkgs.bitwarden-cli
                pkgs.jq
              ];
              text = ''
                umask 077
                ${common}
                ${calls "${direction}_one"}
              '';
            };
        in
        [
          (mk "pull")
          (mk "push")
        ];
    in
    {
      home.packages = [
        pkgs.bitwarden-cli
      ]
      ++ mkSync "signingkey" [
        {
          item = "signingkey-file";
          file = "$HOME/.ssh/signingkey";
        }
      ]
      ++ mkSync "ntnuai-apikey" [
        {
          item = "ntnuai-apikey";
          file = "$HOME/.config/opencode/.ntnuai";
        }
      ]
      ++ mkSync "omniroute-apikey" [
        {
          item = "omniroute-apikey";
          file = "$HOME/.config/opencode/.omniroute";
        }
      ];
    };
}
