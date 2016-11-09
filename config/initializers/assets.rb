# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( jquery.min.js )
Rails.application.config.assets.precompile += %w( bootstrap.min.js )
Rails.application.config.assets.precompile += %w( scripts.js )
Rails.application.config.assets.precompile += %w( jquery.isotope.js )
Rails.application.config.assets.precompile += %w(jquery.slicknav.js)

Rails.application.config.assets.precompile += %w( jquery.visible.js )
Rails.application.config.assets.precompile += %w( jquery.sticky.js )
Rails.application.config.assets.precompile += %w( slimbox2.js )
