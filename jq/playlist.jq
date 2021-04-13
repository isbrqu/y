include "jq/util";
[
    .[] | select(has("playlistRenderer")) | .playlistRenderer | {
        id:
            .playlistId,
        url:
            ($url1 + .playlistId),
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
