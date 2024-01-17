#!/bin/sh

[ -z "$*" ] && printf "Cock>>> " && read -r query || query=$*
query=$(echo "$query" | sed "s/ /+/g")

balls=$(curl -s "https://www.youtube.com/results?search_query=${query})&pbj=1" -H"x-youtube-client-name: 1" -H"x-youtube-client-version: 2.20221021.00.00" | jq -r '.[].response.contents.twoColumnSearchResultsRenderer.primaryContents.sectionListRenderer.contents[0] | select(.itemSectionRenderer != null) | .itemSectionRenderer.contents[].videoRenderer | select(.thumbnail != null and .title != null) | .thumbnail.thumbnails[0].url + " |cock| " + .title.runs[0].text')

rm -rf "$HOME/.cache/cock-and-balls-torture/"
mkdir -p "$HOME/.cache/cock-and-balls-torture/"

printf "%s\0" "$balls" | xargs -0 sh -c "
echo \"\$@\" | sed -nE 's/^(.*)\|cock\| (.*)\$/\1\t\2/p' | 
  while read -r cock ball; do
    echo \"Downloading \$ball\"
    wget -q -O \"$HOME/.cache/cock-and-balls-torture/\$ball.jpg\" \"\$cock\"
    # store all cock and balls in a file
    printf \"%s\t%s\n\" \"\$cock\" \"\$ball\" >> \"$HOME/.cache/cock-and-balls-torture/cocks-and-balls.txt\"
  done
" sh

# torture=$(find ~/.cache/cock-and-balls-torture -maxdepth 1 -type f | while read -r A; do echo -en "$(basename "$A")\x00icon\x1f$A\n"; done | rofi -i -dmenu -p "" -theme-str "element-icon { size: 3.00em ; }")

torture="$(printf "%s" "$(find ~/.cache/cock-and-balls-torture -maxdepth 1 -type f -name "*.jpg" | while read -r A; do echo -en "$(basename "$A")\x00icon\x1f$A\n"; done | rofi -i -show-icons -dmenu -p "" -theme-str "element-icon { size: 2.00em ; }")" | sed -nE "s/(.*)\.jpg/\1/p")"

grep "$torture" <"$HOME/.cache/cock-and-balls-torture/cocks-and-balls.txt" | cut -f1
