include "config/jq/util";
[
    down | .[] | select(has("channelRenderer")) | .channelRenderer | {
        id:
            .channelId,
        urlVideos:
            urlVideos,
        urlPlaylists:
            urlPlaylists,
        title:
            title,
        subscribers: 
            subscriberCount,
        videoCount: 
            videoCount,
        description:
            channelDescription,
        thumbnailUrl:
            thumbnailUrl,
        badges: 
            channelBadges,
    }
]
