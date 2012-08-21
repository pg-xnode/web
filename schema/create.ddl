CREATE TABLE application (
	root_dynamic varchar not null,
	root_static varchar not null
);

CREATE TABLE fragment (
	name varchar not null PRIMARY KEY,
	data xml.node not null
);

CREATE TABLE template (
	name varchar not null PRIMARY KEY,
	data xml.xnt not null
);

CREATE TABLE menu (
	item_name varchar not null PRIMARY KEY,
	pos integer not null UNIQUE,
	request_uri varchar not null UNIQUE
);
