#!/usr/bin/env bash

declare -r CONFIG="config"
declare USERAGENT
USERAGENT="$(cat $CONFIG/useragent)"

declare -Ar sps=(
    [video]="EgIQAQ"
    [channel]="EgIQAg"
    [playlist]="EgIQAw"
)

declare -ar path_json=(
    "contents"
    "twoColumnSearchResultsRenderer"
    "primaryContents"
    "sectionListRenderer"
    "contents[0]"
    "itemSectionRenderer"
    "contents"
)
declare DOWN
DOWN=".$(IFS=.; echo "${path_json[*]}")"

declare -r URL_BASE_YOUTUBE="www.youtube.com"
declare -r URL_VIDEO="https://$URL_BASE_YOUTUBE/watch?v="
declare -r URL_PLAYLIST="https://$URL_BASE_YOUTUBE/playlist?list="
declare -r URL_CHANNEL="https://$URL_BASE_YOUTUBE/channel/"
declare -r URL_RESULTS="https://$URL_BASE_YOUTUBE/results"

usage() {
    echo 'youtuber [video|channel|playlist] <query>'
    echo 'youtuber [channelid|playlistid] <channelid|playlistid>'
}

error() {
    local msg="$1"
    echo "error: $msg" >&2
    exit 1
}

get_yt_html() {
    local sp="${sps[$1]}"
    local query="$2" 
    local -r LANG="en-US,en;q=0.9"
    local useragent
    local html
    useragent="$(cat useragent)"
    if [[ -z "$DEBUG" ]];then
        html="$(curl "$URL_RESULTS"\
        --silent\
        --get --data-urlencode "search_query=$query"\
        --get --data-urlencode "sp=$sp"\
        --header "authority: $URL_BASE"\
        --header "accept-language: $LANG"\
        --header "user-agent: $USERAGENT"\
        --location\
        --compressed)"
    else
        html="$(cat tmp/html_channel)"
    fi
    echo "$html"
}

get_yt_json() {
    local html="$1"
    local file="$2"
    local url1="$3"
    local url2="$4"
    local regex="(?<=var ytInitialData = ){.*}(?=;)"
    local json
    json="$(echo "$html" | grep --perl-regexp --only-matching "$regex")"
    json="$(echo "$json" | jq "$DOWN")"
    json="$(echo "$json"\
        | jq --from-file "$file" --arg url1 "$url1" --arg url2 "$url2")"
    echo "$json"
}

channel() {
    local query="$*"
    local type="channel"
    local file="jq/$type.jq" 
    local url1="$URL_CHANNEL"
    local html
    local json
    html="$(get_yt_html "$type" "$query")"
    json="$(get_yt_json "$html" "$file" "$url1")"
    echo "$json"
}

video() {
    local query="$*"
    local type="video"
    local file="jq/$type.jq" 
    local url1="$URL_VIDEO"
    local url2="$URL_CHANNEL"
    local html
    local json
    html="$(get_yt_html "$type" "$query")"
    json="$(get_yt_json "$html" "$file" "$url1" "$url2")"
    echo "$json"
}

playlist() {
    local query="$*"
    local type="playlist"
    local file="jq/$type.jq" 
    local url1="$URL_PLAYLIST"
    local url2="$URL_CHANNEL"
    local html
    local json
    html="$(get_yt_html "$type" "$query")"
    json="$(get_yt_json "$html" "$file" "$url1" "$url2")"
    echo "$json"
}

main() {
    local action="$1"
    local json="null"
    local -i attempt=16
    shift
    while [[ ("$json" == "null" || "$json" == "[]") && "$attempt" -gt 0 ]];do
        case "$action" in
            ch|channel)
                json="$(channel "$@")"
            ;;
            vd|video)
                json="$(video "$@")"
            ;;
            pl|playlist)
                json="$(playlist "$@")"
            ;;
            help)
                usage
                exit
            ;;
            *)
                usage
                error "action not found"
            ;;
        esac
        if [[ "$json" != "null" && "$json" != "[]" ]];then
            echo "$json"
        fi
        (( attempt-- ))
    done
}

main "$@"

