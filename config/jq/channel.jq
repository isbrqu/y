include "config/jq/util";
[
    down | .[] | select(has("channelRenderer")) | .channelRenderer | {
        id:
            .channelId,
        urlVideos:
            videosUrl,
        urlPlaylists:
            playlistsUrl,
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
