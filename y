#!/usr/bin/env bash

declare -r CONFIG="config"

declare -r LANG="en-US,en;q=0.9"
declare USERAGENT
USERAGENT="$(cat "$CONFIG/useragent")"
(( $? == 0 )) || exit 1

declare -Ar sps=(
    [video]="EgIQAQ"
    [channel]="EgIQAg"
    [playlist]="EgIQAw"
)

declare -r URL_BASE="www.youtube.com"
declare -r URL_VIDEO="https://$URL_BASE/watch?v="
declare -r URL_PLAYLIST="https://$URL_BASE/playlist"
declare -r URL_CHANNEL="https://$URL_BASE/channel"
declare -r URL_RESULTS="https://$URL_BASE/results"

usage() {
    echo "usage:"
    echo -e "\ty [video|channel|playlist] <query>"
    echo -e "\ty [channel-video|channel-playlist] <channelid>"
    echo -e "\ty playlist-video <playlistid>"
}

error() {
    local msg="$1"
    echo "error: $msg" >&2
    exit 1
}

get_yt_html() {
    local url="$1" 
    local data="$2"
    local html
    html="$(curl "$url"\
        --silent\
        --get --data "$data"\
        --header "authority: $URL_BASE"\
        --header "accept-language: $LANG"\
        --header "user-agent: $USERAGENT"\
        --location\
        --compressed)"
    echo "$html"
}

get_yt_json() {
    local html="$1"
    local file="$2"
    local regex="(?<=var ytInitialData = ){.*}(?=;)"
    local json
    json="$(echo "$html" | grep --perl-regexp --only-matching "$regex")"
    json="$(echo "$json" | jq --from-file "$file")"
    echo "$json"
}

channel() {
    local query="$*"
    local type="channel"
    local file="$CONFIG/jq/$type.jq" 
    local filter="${sps[$type]}"
    local data="search_query=${query// /+}&sp=$filter"
    local url="$URL_RESULTS"
    local html
    local json
    html="$(get_yt_html "$url" "$data")"
    json="$(get_yt_json "$html" "$file")"
    echo "$json"
}

video() {
    local query="$*"
    local type="video"
    local file="$CONFIG/jq/$type.jq" 
    local filter="${sps[$type]}"
    local data="search_query=${query// /+}&sp=$filter"
    local url="$URL_RESULTS"
    local html
    local json
    html="$(get_yt_html "$url" "$data")"
    json="$(get_yt_json "$html" "$file")"
    echo "$json"
}

playlist() {
    local query="$*"
    local type="playlist"
    local file="$CONFIG/jq/$type.jq" 
    local filter="${sps[$type]}"
    local data="search_query=${query// /+}&sp=$filter"
    local url="$URL_RESULTS"
    local html
    local json
    html="$(get_yt_html "$url" "$data")"
    json="$(get_yt_json "$html" "$file")"
    echo "$json"
}

channel_video() {
    local id="$1"
    local type="channel_video"
    local file="$CONFIG/jq/$type.jq" 
    local url="$URL_CHANNEL/$id/videos"
    local html
    local json
    html="$(get_yt_html "$url")"
    json="$(get_yt_json "$html" "$file")"
    echo "$json"
}

channel_playlist() {
    local id="$1"
    local type="channel_playlist"
    local file="$CONFIG/jq/$type.jq" 
    local url="$URL_CHANNEL/$id/playlists"
    local data="view=1"
    local html
    local json
    html="$(get_yt_html "$url" "$data")"
    json="$(get_yt_json "$html" "$file")"
    echo "$json"
}

playlist_video() {
    local id="$1"
    local type="playlist_video"
    local file="$CONFIG/jq/$type.jq" 
    local url="$URL_PLAYLIST"
    local data="list=$id"
    local html
    local json
    html="$(get_yt_html "$url" "$data")"
    json="$(get_yt_json "$html" "$file")"
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
            chvd|channel-video)
                json="$(channel_video "$@")"
            ;;
            chpl|channel-playlist)
                json="$(channel_playlist "$@")"
            ;;
            plvd|playlist-video)
                json="$(playlist_video "$@")"
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

