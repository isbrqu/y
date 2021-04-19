include "config/jq/util";

def downtab:
    .contents
    .twoColumnBrowseResultsRenderer
    .tabs[0]
    .tabRenderer
    .content
    .sectionListRenderer
    .contents[0]
    .itemSectionRenderer
    .contents[0]
    .playlistVideoListRenderer
    .contents[];

[
    downtab | select(has("playlistVideoRenderer")) | .playlistVideoRenderer | {
        id:
            .videoId,
        url:
            videoUrl,
        title:
            title,
        duration:
            duration,
        thumbnailUrl:
            thumbnailUrl,
    }
]
