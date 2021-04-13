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
    .lengthText.simpleText // ""
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
    $url2 + .longBylineText.runs[0].navigationEndpoint.browseEndpoint.browseId
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

