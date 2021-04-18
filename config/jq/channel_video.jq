include "config/jq/util";

def downtab:
    .contents
    .twoColumnBrowseResultsRenderer
    .tabs[1]
    .tabRenderer
    .content
    .sectionListRenderer
    .contents[0]
    .itemSectionRenderer
    .contents[0]
    .gridRenderer
    .items[];

[
    downtab | select(has("gridVideoRenderer")) | .gridVideoRenderer | {
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
        thumbnailUrl:
            thumbnailUrl,
    }
]
