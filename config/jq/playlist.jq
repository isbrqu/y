include "config/jq/util";
[
    down | .[] | select(has("playlistRenderer")) | .playlistRenderer | {
        id:
            .playlistId,
        url:
            urlVideo,
        title:
            title,
        views:
            .videoCount,
        thumbnailUrl:
            thumbnailUrl,
        channelId:
            channelId,
        channelUrl:
            channelUrl,
        channelName:
            channelName,
        channelBadges:
            channelBadges,
    }
]
