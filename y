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

usage() {
    echo 'ch [lv|lp|sh|rm|ed]'
}

get_yt_html() {
    local sp="${sps[$1]}"
    local query="$2" 
    local -r URL_BASE="www.youtube.com"
    local -r URL_RESULTS="https://$URL_BASE/results"
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
        html="$(cat tmp/html)"
    fi
    echo "$html"
}

get_yt_json() {
    local html="$1"
    local json
    local regex="(?<=var ytInitialData = ){.*}(?=;)"
    json="$(echo "$html" | grep --perl-regexp --only-matching "$regex")"
    echo "$json"
}

get_channels() {
    local json="$1"
    local channels
    channels="$(echo "$json" | jq "$DOWN")"
    echo "$channels"
}

error() {
    local msg="$1"
    echo "error: $msg" >&2
    exit 1
}

channel() {
    local action="$1"
    shift
    case "$action" in
        lv) channel_list_videos "$@";;
        lp) channel_list_playlists "$@";;
        sh) channel_search "$@";;
        rm) channel_remove "$@";;
        ed) channel_edit "$@";;
        help) channel_usage;;
        *)
            channel_usage
            error "action not found"
        ;;
    esac
}

channel_usage() {
    echo usage
}

channel_list_videos() {
    echo bruh
}

channel_list_playlists() {
    echo bruh
}

channel_search() {
    local query="$1"
    local type="channel"
    local html
    local json
    html="$(get_yt_html "$type" "$query")"
    json="$(get_yt_json "$html")"
    json="$(get_channels "$json")"
    echo "$json"
}

channel_remove() {
    echo bruh
}

channel_edit() {
    echo bruh
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

