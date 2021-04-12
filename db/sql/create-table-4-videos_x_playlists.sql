create table if not exists videos_x_playlists (
    id int(11) unsigned primary key auto_increment, 
    video_id int(11) unsigned not null,
    playlist_id int(11) unsigned not null,
    foreign key (video_id) references videos (id),
    foreign key (playlist_id) references playlists (id)
) ENGINE = InnoDB;

