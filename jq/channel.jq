[
    .[] | select(has("channelRenderer")) | .channelRenderer | {
        "title":
            .title.simpleText,
        "url":
            ($url1 + .channelId + "/videos"),
        "subscriberCount": 
            ((.subscriberCountText.simpleText | sub(" .+"; ""))? // ""),
        "videoCount": 
            (((.videoCountText.runs[0].text | sub(" video(s)?"; "")))? // ""),
        "description": (([
            select(has("descriptionSnippet")) | .descriptionSnippet.runs[].text
        ]) | join(", ")),
        "thumbnail":
            ("https:" + (.thumbnail.thumbnails[0].url | sub("[?].+"; ""))),
        "ownerBadges": (([
            select(has("ownerBadges"))
            | .ownerBadges[].metadataBadgeRenderer.tooltip
        ]) | join(", "))
    }
]
