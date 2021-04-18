include "config/jq/util";
[
    down | .[] | select(has("videoRenderer")) | .videoRenderer | {
        id:
            .videoId,
        url:
            videoUrl,
        title:
            title,
        publishedTime:
            publishedTime,
        duration:
            duration,
        views:
            views,
        description:
            description,
        thumbnailUrl:
            thumbnailUrl,
        badges:
            badges,
        channel: {
            id:
                channelId,
            name:
                channelName,
            url:
                channelUrl,
            badges:
                channelBadges,
        }
    }
]
