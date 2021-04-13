include "jq/util";
[
    .[] | select(has("channelRenderer")) | .channelRenderer | {
        id:
            .channelId,
        urlVideos:
            ($url1 + .channelId + "/videos"),
        urlPlaylist:
            ($url1 + .channelId + "/playlists"),
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
            channelBadges
    }
]
