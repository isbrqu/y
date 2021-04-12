create table if not exists types_of_channels (
    id int(11) unsigned primary key auto_increment, 
    name varchar(255),
    unique(name)
) ENGINE = InnoDB;

