create table if not exists playlists (
    id int(11) unsigned primary key auto_increment, 
    idd varchar(255), 
    name varchar(255),
    thumbnail varchar(255),
    channel_id int(11) unsigned not null,
    foreign key (channel_id) references channels (id),
    unique(idd)
) ENGINE = InnoDB;

