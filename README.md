# SaaS Products (Flutter)

An "About SaaS Products" site built on the structure of the server application
(`lib/{data,models,pages,services,theme,widgets}`, SQLite through `sqflite`, `sqflite_common_ffi_web` for the web build).
It is the Flutter counterpart of `about_saas_products_en.html`: the same fourteen products, version and copyright
lines and platform tags (REACT, FLUTTER, ANDROID, SWIFTUI, DOTNET, IOS, SERVER, SERVERLESS), plus twenty-six more sample modules.

## What is in it

| Feature | Where |
|---|---|
| UI kit `retro_desktop_ui ^0.4.1` (UI interface, tabs, lists, selects, text fields) | `lib/main.dart`, `lib/pages/*` |
| Look: light double rules, stepped corners, fan divider, spaced capitals; **light / dark layout** with a square switcher (top right of every page) | `lib/theme/*`, `lib/app_state.dart` |
| **Main page**: JPG carousel with `flutter_carousel_widget ^4.0.1` | `lib/widgets/jpg_carousel.dart`, `lib/pages/home_page.dart` |
| **All other pages**: stacked card carousel (`stacked_card_carousel ^0.0.4`), aligned left | `lib/widgets/gif_stack_carousel.dart` |
| `/services` and `/case-studies`, each with **40 pages** `instance-01` ... `instance-40` (`/services/instance-01`, ...) | `lib/data/instances.dart`, `lib/pages/section_page.dart`, `lib/pages/instance_page.dart` |
| Breadcrumb (Home > About SaaS Products > PRODUCT) | `lib/widgets/breadcrumb.dart` |
| Footer with links and copyright | `lib/widgets/footer.dart` |
| **40 sample pages** (`/p/<slug>`), 14 from the HTML page + 26 extra | `lib/data/products_seed.dart`, `lib/pages/sample_page.dart` |
| Stacked card carousel of **14 GIFs** on every page except the main page, changing every 4 s (`stacked_card_carousel ^0.0.4`) | `lib/widgets/gif_stack_carousel.dart` |
| About SaaS Products page | `lib/pages/about_saas_products.dart` (`/about-saas-products`) |
| Archive: database contents + palette/window style settings | `lib/pages/library_page.dart` (`/library`) |

## SQLite storage (`schema.sql`)

* **text**: `pages` (title, version, summary, long `body`), `page_tags`. Editable on each page, *Database* tab.
* **jpg / gif / mp4**: `media(kind, name, mime, bytes BLOB)`, placed on pages through `page_media(slug, media_id, position)`.
  14 JPG, 14 GIF and 2 MP4 are stored once and shared by all forty pages; page *i* starts its GIF stack with GIF *i*.
* The first start creates the schema and fills it from `assets/` (`Db._seedIfEmpty`). Afterwards the UI reads only from the database.
  `Db.addMedia(kind, name, bytes, slug: ...)` stores further files.
* MP4 playback: bytes are written to a temp file (mobile/desktop) or wrapped in a Blob URL (web), see `lib/services/video_source_*.dart`.

## Run

```
flutter pub get
flutter run -d chrome          # or windows / macos / linux / an emulator
```

Web needs `web/sqlite3.wasm` and `web/sqflite_sw.js` (already in `web/`; refresh with `dart run sqflite_common_ffi_web:setup`).
Flutter 3.47+ / Dart 3.13+ is required by retro_desktop_ui.

## Regenerating assets

`tools/make_assets.py <out>` draws the fourteen animated GIFs, fourteen JPGs and the MP4 reel (Pillow + ffmpeg),
`tools/make_seed.py` rewrites `lib/data/products_seed.dart` and `web/sitemap.xml`.
Replace the files in `assets/gifs`, `assets/images`, `assets/videos` with your own, keeping the names, and delete the database to re-seed.

## Notes

* Pages use `WidgetsApp` (supported by retro_desktop_ui) so no Material dependency is needed; pages change in place, as the look prescribes.
* The breadcrumb is drawn with `RetroDesktopButton.text` links instead of `flutter_breadcrumb`, whose `InkWell` needs a Material ancestor.
* The 6 MB `saas-subsections.gif` of the old project is not included; `it-office.mp4` is kept and stored in the database.
