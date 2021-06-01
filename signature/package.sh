#!/bin/bash


has_param() {
    local term="$1"
    shift
    for arg; do
        if [[ $arg == "$term" ]]; then
            return 0
        fi
    done
    return 1
}

if [[ "$1" == '-h' || "$1" == '--help' || "$#" != 2 ]]; then
    echo "Script needs two parameters:"
    echo "1: input hex file in intel format (.elf)."
    echo  "2: name of the output file."
    exit 0
fi

if [[ -f "$1" ]]; then
    echo "$1 exists."
else
    echo "$1 does not exist"
    exit 0
fi

avr-objcopy -O binary "$1" output.bin

# First extract information from the binary file.
sectorsizebytes=512
filesizebytes=$(stat -c%s output.bin)
numsectors=$((filesizebytes/$sectorsizebytes+1))
echo "Size of $1 in bytes: $filesizebytes which is $numsectors sectors."

# Now generate the signature file and the zero padding for the first sector
printf "%b" '\x74\x08\xcc\x96' > sig.bin	# Verification signature
printf "0: %.2x" $numsectors | xxd -r -p >> sig.bin	# Number of sectors in file
dd < /dev/zero bs=507 count=1 >> sig.bin	# Zero padding to full sector size 512 sector size - 4 signature bytes - 1 filesize byte

# Prepend the signature to the binary file
cat sig.bin output.bin > "$2"
