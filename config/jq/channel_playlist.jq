include "config/jq/util";

def downtab:
    .contents
    .twoColumnBrowseResultsRenderer
    .tabs[2]
    .tabRenderer
    .content
    .sectionListRenderer
    .contents[0]
    .itemSectionRenderer
    .contents[0]
    .gridRenderer
    .items[];

[
    downtab | select(has("gridPlaylistRenderer")) | .gridPlaylistRenderer | {
        id:
            .playlistId,
        url:
            playlistUrl,
        title:
            title,
        views:
            videoCount,
    }
]
