#!/usr/bin/env bash

# set -o errexit
# set -o pipefail
# set -o nounset
# set -o xtrace

usage() {
    echo 'ch [lv|lp|sh|rm|ed]'
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
        lv) channel_list_videos;;
        lp) channel_list_playlists;;
        sh) channel_search;;
        rm) channel_remove;;
        ed) channel_edit;;
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
    echo bruh
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

