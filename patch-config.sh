#!/bin/bash
set -e
err() {
    echo "Error occurred:"
    awk 'NR>L-4 && NR<L+4 { printf "%-5d%3s%s\n",NR,(NR==L?">>>":""),$0 }' L=$1 $0
	echo "Press Enter to continue"
	read
	exit 1
}
trap 'err $LINENO' ERR

cp "$1" "$3"

while read line; do
    line=$(sed 's/#.*$//' <<< "$line")

    if [[ ! -z "$line"  ]]; then
        read -d= conf <<< "$line"

        matchexp="^# $conf is not set|$conf=[ynm]$"

        if grep -Eq "$matchexp" "$3"; then
            sed -Ei "s/$matchexp/$line/g" "$3"
        else
            echo "$line" >> "$3"
        fi
    fi
done < "$2"

