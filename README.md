# SaaS Products (Flutter)

An "About SaaS Products" site built on the structure of the server application
(`lib/{data,models,pages,services,theme,widgets}`, SQLite through `sqflite`, `sqflite_common_ffi_web` for the web build).
It is the Flutter counterpart of `about_saas_products_en.html`: the same fourteen products, version and copyright
lines and platform tags (REACT, FLUTTER, ANDROID, SWIFTUI, DOTNET, IOS, SERVER, SERVERLESS), plus twenty-six more sample modules.

## Project Structure

```
saas-products/
├── assets/
│   ├── gifs/              # 01.gif ... 14.gif, stored once in SQLite and shared by all pages
│   ├── images/            # 01.jpg ... 14.jpg, hero pictures and main page JPG carousel
│   └── videos/            # reel.mp4, it-office.mp4
├── lib/
│   ├── data/
│   │   ├── docs/
│   │   │   ├── browser_files_doc.dart             # Typed content blocks for /browser-files
│   │   │   ├── coding_fragments_doc.dart          # Accordions with SQL, TypeScript, Java, JS, SAS, C#, Swift samples
│   │   │   ├── coding_variations_doc.dart         # Feature cards for /coding-variations
│   │   │   ├── components_inventory_doc.dart      # SBOM / VEX reference with tables
│   │   │   ├── components_specification_doc.dart  # Weighted card rows for /components-specification
│   │   │   ├── gdpr_compliance_doc.dart           # Data processing agreement clauses
│   │   │   ├── microservices_peculiarities_doc.dart # Per-language cards with documentation links
│   │   │   ├── terms_of_use_doc.dart              # Developer agreement text
│   │   │   └── third_party_ads_doc.dart           # Third-party advertising statement
│   │   ├── instances.dart      # Services / Case Studies sections, 40 instance pages each
│   │   └── products_seed.dart  # 40 seed products, tags and generated body text
│   ├── models/
│   │   ├── doc_block.dart      # Span and DocBlock model: heading, paragraph, bullets, table, code, cards, accordion
│   │   └── product.dart        # Product, MediaRef and DbStats models
│   ├── pages/
│   │   ├── about_saas_products.dart        # Product rows with sample module list
│   │   ├── browser_files_page.dart         # /browser-files
│   │   ├── coding_fragments_page.dart      # /coding-fragments
│   │   ├── coding_variations_page.dart     # /coding-variations
│   │   ├── components_inventory_page.dart  # /components-inventory
│   │   ├── components_specification_page.dart # /components-specification
│   │   ├── doc_pages.dart                  # Registry mapping document routes to pages
│   │   ├── gdpr_compliance_page.dart       # /gdpr-compliance
│   │   ├── home_page.dart                  # Main page with the JPG carousel and 40 product cards
│   │   ├── instance_page.dart              # One service or case study instance
│   │   ├── library_page.dart               # Archive: database contents, palette and window style settings
│   │   ├── microservices_peculiarities_page.dart # /microservices-peculiarities
│   │   ├── not_found_page.dart             # 404 page
│   │   ├── sample_page.dart                # /p/<slug> with Overview, Video and editable Database tabs
│   │   ├── section_page.dart               # Services and Case Studies lists
│   │   ├── terms_of_use_page.dart          # /terms-of-use
│   │   └── third_party_ads_page.dart       # /third-party-ads
│   ├── services/
│   │   ├── db_service.dart         # SQLite: pages, tags, media BLOBs, first-start seeding from assets
│   │   ├── video_source.dart       # Conditional export for MP4 playback
│   │   ├── video_source_io.dart    # Mobile / desktop: bytes written to a temp file
│   │   ├── video_source_stub.dart  # Fallback implementation
│   │   └── video_source_web.dart   # Web: Blob URL wrapper
│   ├── theme/
│   │   ├── app_theme.dart      # Palette, light / dark colors, retro_desktop_ui theme builder, text helpers
│   │   └── app_widgets.dart    # AppFrame, AppDivider, AppHeading, AppTag, AppTap, square light / dark switcher
│   ├── utils/
│   │   └── roman.dart          # Roman numeral helper for card counters
│   ├── widgets/
│   │   ├── async_body.dart         # Loading and error wrapper for futures
│   │   ├── breadcrumb.dart         # Breadcrumb trail
│   │   ├── db_image.dart           # Image read from SQLite with in-memory cache
│   │   ├── db_video.dart           # MP4 player fed from SQLite
│   │   ├── doc_view.dart           # Renderer for doc blocks: text, links, tables, code with copy, cards, accordions
│   │   ├── footer.dart             # Site and document links, copyright
│   │   ├── gif_stack_carousel.dart # Left-aligned stacked GIF card carousel, changes every 4 s
│   │   ├── jpg_carousel.dart       # Main page JPG carousel
│   │   └── page_shell.dart         # Shared page frame: app bar, breadcrumb, switcher, footer
│   ├── app_state.dart          # Palette, light / dark and window style notifiers
│   ├── main.dart               # App entry point, SQLite factory setup, route generation
│   └── routes.dart             # Route constants, navigation helper, sitemap generator
├── web/
│   ├── index.html              # Web host template
│   ├── sitemap.xml             # All routes, generated
│   ├── sqlite3.wasm            # SQLite for the web build
│   └── sqflite_sw.js           # SQLite web worker
├── schema.sql                  # pages, page_tags, media and page_media table definitions
├── pubspec.yaml                # Project dependencies and asset declarations
└── README.md
```


## Overall

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
| **Nine document pages**, each with the left-aligned stacked GIF carousel: `/browser-files`, `/coding-fragments`, `/coding-variations`, `/components-inventory`, `/components-specification`, `/gdpr-compliance`, `/microservices-peculiarities`, `/terms-of-use`, `/third-party-ads` | `lib/pages/*_page.dart`, `lib/data/docs/*_doc.dart`, `lib/widgets/doc_view.dart`, registry in `lib/pages/doc_pages.dart` |

## SQLite storage (`schema.sql`)

* **text**: `pages` (title, version, summary, long `body`), `page_tags`. Editable on each page, *Database* tab.
* **jpg / gif / mp4**: `media(kind, name, mime, bytes BLOB)`, placed on pages through `page_media(slug, media_id, position)`.
  14 JPG, 14 GIF and 2 MP4 are stored once and shared by all software engineering and computer science; page *i* starts its GIF stack with GIF *i*.
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

## Notes

* Pages use `WidgetsApp` (supported by retro_desktop_ui) so no Material dependency is needed; pages change in place, as the look prescribes.
* The breadcrumb is drawn with `RetroDesktopButton.text` links instead of `flutter_breadcrumb`, whose `InkWell` needs a Material ancestor.
* The 6 MB `saas-subsections.gif` of the old project is not included; `it-office.mp4` is kept and stored in the database.



