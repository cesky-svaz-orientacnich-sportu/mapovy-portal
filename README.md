# Mapový portál ČSOS

## Built with
- [Ruby on Rails](https://rubyonrails.org/)
- [PostgreSQL](https://www.postgresql.org/) with [PostGIS](https://postgis.net/)
- [Mapserver](https://mapserver.org/)

## Requirements
- [Ruby](https://www.ruby-lang.org/en/) (version specified in `.ruby-version`)
- [Bundler](https://bundler.io/)
- [PostgreSQL](https://www.postgresql.org/) with
	- [PostGIS](https://postgis.net/) extension
	- [pgRouting](https://pgrouting.org/) extension
- [NodeJS](https://nodejs.org/en/)
- [Yarn](https://classic.yarnpkg.com/en/)

## Install
1. Configure the dotenv variables according to `.env.template`.
2. Install app:
```
bundle install
bin/rails db:create
bin/rails db:schema:load
```
3. Generate JS localization files:
```
bin/rake locale_js
```
4. Run dev server:
```
bin/rails server -b 0.0.0.0
```

### Projekt mapserver na Google + API klíče
archiv.map.csos@gmail.com

## Changelog
In separate file [CHANGELOG.md](CHANGELOG.md). Please [keep a CHANGELOG](http://keepachangelog.com/).

This project adheres to [Semantic Versioning](http://semver.org/).
