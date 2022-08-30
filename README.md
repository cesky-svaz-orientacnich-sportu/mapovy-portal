# Mapový portál ČSOS

## Built with
- [Ruby on Rails](https://rubyonrails.org/)
- [PostgreSQL](https://www.postgresql.org/) with [PostGIS](https://postgis.net/)
- [Mapserver](https://mapserver.org/)

## Requirements
- [Ruby](https://www.ruby-lang.org/en/)
- [PostgreSQL](https://www.postgresql.org/) with
	- [PostGIS](https://postgis.net/) extension
	- [pgRouting](https://pgrouting.org/) extension
- [NodeJS](https://nodejs.org/en/)
- [Yarn](https://classic.yarnpkg.com/en/)

## Install
1. Configure the dotenv variables according to `.env.template`.
2. Install app:
```
gem install bundler
bundle install
bin/rails db:create
bin/rails db:schema:load
```
3. Generate JS localization files:
```
rake locale_js
```
4. Run dev server:
```
rails s -b 0.0.0.0
```

## Credentials a spol.
Klíče jsou v nastavení apache a jsou nastavené jako proměnné prostředí.

### Projekt mapserver na Google + API klíče
archiv.map.csos@gmail.com

## Changelog
In separate file [CHANGELOG.md](CHANGELOG.md). Please [keep a CHANGELOG](http://keepachangelog.com/).

This project adheres to [Semantic Versioning](http://semver.org/).
