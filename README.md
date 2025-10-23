# Mapový portál – Český orienťák

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
- [Node.js](https://nodejs.org/en) or other JS runtime (optionally installed with [Volta](https://volta.sh/))

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

## Projekt mapserver na Google + API klíče
david.pustai@ceskyorientak.cz

## Changelog
In separate file [CHANGELOG.md](CHANGELOG.md). Please [keep a CHANGELOG](http://keepachangelog.com/).

This project adheres to [Semantic Versioning](http://semver.org/).

## Deploy
1. Update Ruby version on server:
```sh
sudo su - <user>
git -C ~/.rbenv/plugins/ruby-build pull
rbenv install <version>
```
2. `cap <environment> deploy`
3. If changed, update Ruby version in Apache VH config and restart Apache.
4. After deploy is stable for few days, remove old unused ruby version:
```sh
rbenv versions
rbenv uninstall <version>
```
