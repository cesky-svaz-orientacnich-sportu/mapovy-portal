# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.precompile += %w[ _map.css _public.css _info_table.css _map.js _minimap.js _public.js mapserver/locale/cs.js mapserver/locale/en.js ]
Rails.application.config.assets.precompile += [ Dir["#{Rails.root}/app/assets/images/**/*"].reject {|fn| File.directory?(fn) } ]
