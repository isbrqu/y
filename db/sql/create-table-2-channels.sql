create table if not exists channels (
    id int(11) unsigned primary key auto_increment, 
    idd varchar(255), 
    name varchar(255),
    type_of_channel_id int(11) unsigned not null,
    foreign key (type_of_channel_id) references types_of_channels (id),
    unique(idd)
) ENGINE = InnoDB;

