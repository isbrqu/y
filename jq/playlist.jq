def delete_param(f): f |
    sub("[?].+";"");

def get_owner_badges: ([
    select(has("ownerBadges")) | .ownerBadges[].metadataBadgeRenderer.tooltip
]) | join(", ");

def get_description: ([
    select(has("descriptionSnippet")) | .descriptionSnippet.runs[].text
]) | join(", ");

def get_owner_channel: (
    $url2 + .longBylineText.runs[0].navigationEndpoint.browseEndpoint.browseId
);

def get_published_time: (
    .publishedTimeText.simpleText // ""
);

def get_length: (
    .lengthText.simpleText // ""
);

[
    .[] | select(has("playlistRenderer")) | .playlistRenderer |
    {
        "title":
            .title.simpleText,
        "url":
            ($url1 + .playlistId),
        "publishedTime":
            get_published_time,
        "count":
            .videoCount,
        "thumbnail":
            (delete_param(.thumbnails[0].thumbnails[0].url)),
        "ownerName":
            .shortBylineText.runs[0].text,
        "ownerChannel":
            get_owner_channel,
        "ownerBadges":
            get_owner_badges,
    }
]
