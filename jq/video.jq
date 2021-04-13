include "jq/util";
[
    .[] | select(has("videoRenderer")) | .videoRenderer |
    {
        id:
            .videoId,
        url:
           ($url1 + .videoId),
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
        channelId:
            channelId,
        channelName:
            channelName,
        channelUrl:
            channelUrl,
        channelBadges:
            channelBadges,
    }
]
