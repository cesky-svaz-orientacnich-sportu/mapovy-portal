class MetaController < ApplicationController
  def site_webmanifest
    manifest = {
      name: I18n.t("mapserver.title", default: "Mapový portál – Český orienťák"),
      short_name: I18n.t("mapserver.title_short", default: "Mapy"),
      lang: I18n.locale.to_s,
      icons: [
        {
          src: "/android-chrome-192x192.png",
          sizes: "192x192",
          type: "image/png",
          purpose: "maskable"
        },
        {
          src: "/android-chrome-512x512.png",
          sizes: "512x512",
          type: "image/png",
          purpose: "maskable"
        }
      ],
      start_url: "/?utm_source=homescreen",
      theme_color: "#edece3",
      background_color: "#edece3",
      display: "standalone",
    }
    render json: manifest
  end
end
