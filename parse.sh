#!/bin/bash

# check if argument is supplied
if [ -z "$1" ]
    then
        echo "No argument supplied. Use access.log file as first argument"
        exit 1
fi

# set input file
input_file=$1
echo "Parsing ${input_file} file"

# set parse arguments
filter_status=500

# Debug informnation about file, no need to save it in production
echo "Filter status value is set to ${filter_status}"
count_original=$(cat $input_file | wc -l)
count_filtered=$(cat $input_file | grep $filter_status | wc -l)
echo "Parser filtered ${count_filtered} lines / ${count_original} from ${input_file} file"


# parsing function (first idea, not the best)
function parse_with_grep () {
    # Comment: This method can get an error if HTTP PATH or RESP BYTES is equal to filter status value
    echo "= Show only lines with status code ${filter_status} using grep"
    # cat $input_file | grep $filter_status | awk -F ';' {'print $1'}
    IFS=$'\n' read -r -d '' -a filtered_lines <<< "$(grep "$filter_status" "$input_file" | awk -F ';' '{print $1}' && printf '\0')"
    top_10=$(printf "%s\n" "${filtered_lines[@]}" | sort | uniq -c | sort -nr | head -n 10)
    # Print the result
    echo "$top_10"
}

# parsing function (second idea, better way)
function parse_with_awk() {
    echo "= Show only lines with status code ${filter_status} using awk"
    IFS=$'\n' read -r -d '' -a filtered_lines <<< "$(awk -v filter="$filter_status" -F ';' '$3 == filter { print $1 }' "$input_file" && printf '\0')"
    top_10=$(printf "%s\n" "${filtered_lines[@]}" | sort | uniq -c | sort -nr | head -n 10)
    # Print the result
    echo "$top_10"
}

parse_with_grep
parse_with_awk