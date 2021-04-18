def down:
    .contents
    .twoColumnSearchResultsRenderer
    .primaryContents
    .sectionListRenderer
    .contents[0]
    .itemSectionRenderer
    .contents;

def urlBaseVideo:
    "https://www.youtube.com/watch?v=";

def urlBasePlaylist:
    "https://www.youtube.com/playlist?list=";

def urlBaseChannel:
    "https://www.youtube.com/channel/";

def videoUrl:
    (urlBaseVideo + .videoId);

def playlistUrl:
    (urlBasePlaylist + .playlistId);

def videosUrl:
    (urlBaseChannel + .channelId + "/videos");

def playlistsUrl:
    (urlBaseChannel + .channelId + "/playlists");

def title: (
    .title |
    if has("simpleText") then
        .simpleText
    else
        [ .runs[].text ] | join("")
    end
);

def description: [
    select(has("descriptionSnippet")) | .descriptionSnippet.runs[].text
] | join(", ");

def views:
    .viewCountText | (.simpleText | sub(" .+";""))? // .runs[0].text;

def badges: (
        [ .badges[].metadataBadgeRenderer.label ]
        | join(", ")
        | ascii_downcase
)? // "";

def publishedTime:
    .publishedTimeText.simpleText // "" | ascii_downcase;

def duration: (
    if (.lengthText.simpleText != null) then
        .lengthText
        .simpleText
    elif has("thumbnailOverlays") then
        .thumbnailOverlays[0]
        .thumbnailOverlayTimeStatusRenderer
        .text
        .simpleText // ""
    else
        ""
    end
);

def thumbnailUrl: (
    if has("videoId") then
        .thumbnail.thumbnails[0].url
    elif has("playlistId") then
        .thumbnails[0].thumbnails[0].url
    else
        "https:" + .thumbnail.thumbnails[0].url
    end
) | sub("[?].+";"");

def channelId: (
    .longBylineText.runs[0].navigationEndpoint.browseEndpoint.browseId
);

def channelUrl: (
    urlBaseChannel + channelId
);

def channelName: (
    .shortBylineText.runs[0].text
);

def channelBadges: ([
    select(has("ownerBadges")) | .ownerBadges[].metadataBadgeRenderer.tooltip
]) | join(", ") | ascii_downcase;

def subscriberCount: (
    (.subscriberCountText.simpleText | sub(" .+"; ""))? // ""
);

def channelDescription: ([
    select(has("descriptionSnippet")) | .descriptionSnippet.runs[].text
]) | join(", ");

def videoCount: (
    (.videoCountText.runs[0].text | sub(" video(s)?"; ""))? // ""
);

