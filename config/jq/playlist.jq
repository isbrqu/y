include "config/jq/util";
[
    down | .[] | select(has("playlistRenderer")) | .playlistRenderer | {
        id:
            .playlistId,
        url:
            playlistUrl,
        title:
            title,
        views:
            .videoCount,
        thumbnailUrl:
            thumbnailUrl,
        channel: {
            id:
                channelId,
            url:
                channelUrl,
            name:
                channelName,
            badges:
                channelBadges,
        }
    }
]
