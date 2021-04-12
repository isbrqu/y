#!/usr/bin/env bash

# set -o errexit
# set -o pipefail
# set -o nounset
# set -o xtrace
declare -r DEBUG="true"

declare -Ar sps=(
    [channel]="EgIQAg"
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
declare -r URL_LIST="https://$URL_BASE_YOUTUBE/playlist?list="
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
        --header "user-agent: $useragent"\
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
    local url="$3"
    local regex="(?<=var ytInitialData = ){.*}(?=;)"
    local json
    json="$(echo "$html" | grep --perl-regexp --only-matching "$regex")"
    json="$(echo "$json" | jq "$DOWN")"
    json="$(echo "$json" | jq --from-file "$file" --arg url "$url")"
    echo "$json"
}

channel() {
    local query="$*"
    local type="channel"
    local file="jq/channel.jq" 
    local url="$URL_CHANNEL"
    local html
    local json
    html="$(get_yt_html "$type" "$query")"
    json="$(get_yt_json "$html" "$file" "$url")"
    echo "$json"
}

video() {
    echo "video"
}

playlist() {
    echo "playlist"
}

main() {
    local action="$1"
    shift
    case "$action" in
        ch|channel)
            channel "$@"
        ;;
        vd|video)
            video "$@"
        ;;
        pl|playlist)
            playlist "$@"
        ;;
        help)
            usage
        ;;
        *)
            usage
            error "action not found"
        ;;
    esac
}

main "$@"

