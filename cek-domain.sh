#!/bin/bash
#Shidqi
read -p "Nama file: " input_file

if [[ ! -f "$input_file" ]]; then
    echo "File $input_file tidak ditemukan!"
    exit 1
fi

> hasil.txt

sed -i 's~https://~~g; s~http://~~g' "$input_file"

show_animation() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

check_domain() {
    domain=$1
    if ping -c 1 "$domain" &> /dev/null; then
        echo "$domain" >> hasil.txt
    fi
}

export -f check_domain

xargs -a "$input_file" -I{} -P 10 bash -c 'check_domain "{}"' & show_animation

echo "Done bro!. result -> hasil.txt."
