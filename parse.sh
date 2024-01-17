#!/bin/bash

# set input file
input_file=$1
echo "Parsing ${input_file} file"

# set parse arguments
filter_status=500

# parsing function (second idea, better way)
function parse_with_awk() {
    echo "= Show only lines with status code ${filter_status} using awk"
    IFS=$'\n' read -r -d '' -a filtered_lines <<< "$(awk -v filter="$filter_status" -F ';' '$3 == filter { print $1 }' "$input_file" && printf '\0')"
    top_10=$(printf "%s\n" "${filtered_lines[@]}" | sort | uniq -c | sort -nr | head -n 10)
    # Print the result
    echo "$top_10"
}

parse_with_awk