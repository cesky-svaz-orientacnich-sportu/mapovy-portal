# Mapový portál ČSOS

- backend v Ruby on Rails
- mapová data v Postgres s Postgis extension
- zobrazení dat na mapě přes WMS vrstvu servírovanou Mapserverem

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
3. Run dev server:
```
rails s -b 0.0.0.0
```

## Credentials a spol.
Klíče jsou v nastavení apache a jsou nastavené jako proměnné prostředí.

### Projekt mapserver na Google + API klíče

archiv.map.csos@gmail.com
