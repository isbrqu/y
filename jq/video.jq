def delete_param(f): f |
    sub("[?].+";"");

def get_owner_badges: ([
    select(has("ownerBadges")) | .ownerBadges[].metadataBadgeRenderer.tooltip
]) | join(", ");

def get_description: ([
    select(has("descriptionSnippet")) | .descriptionSnippet.runs[].text
]) | join(", ");

def get_owner_channel: (
    $url2 + .ownerText.runs[0].navigationEndpoint.browseEndpoint.browseId
);

def get_published_time: (
    .publishedTimeText.simpleText // ""
);

def get_length: (
    .lengthText.simpleText // ""
);

[
    .[] | select(has("videoRenderer")) | .videoRenderer |
    {
        "title":
            .title.runs[0].text,
        "url":
            ($url1 + .videoId),
        "publishedTime":
            get_published_time,
        "length":
            get_length,
        "view":
            (.viewCountText | ((.simpleText | sub(" .+";""))? // .runs[0].text)),
        "description":
            get_description,
        "thumbnail":
            (delete_param(.thumbnail.thumbnails[0].url)),
        "badges":
            ((([ .badges[].metadataBadgeRenderer.label ]) | join(", "))? // ""),
        "ownerName":
            .ownerText.runs[0].text,
        "ownerChannel":
            get_owner_channel,
        "ownerBadges":
            get_owner_badges,
    }
]
