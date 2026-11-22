CREATE TABLE pages (
  slug       TEXT PRIMARY KEY,
  position   INTEGER NOT NULL,
  title      TEXT NOT NULL,
  mark       TEXT NOT NULL DEFAULT '',
  version    TEXT NOT NULL,
  start_year INTEGER,
  summary    TEXT NOT NULL,
  body       TEXT NOT NULL,
  updated    INTEGER NOT NULL
);

CREATE TABLE page_tags (
  slug TEXT NOT NULL,
  tag  TEXT NOT NULL,
  PRIMARY KEY (slug, tag)
);

CREATE TABLE media (
  id      INTEGER PRIMARY KEY AUTOINCREMENT,
  kind    TEXT NOT NULL CHECK (kind IN ('jpg', 'gif', 'mp4')),
  name    TEXT NOT NULL UNIQUE,
  mime    TEXT NOT NULL,
  bytes   BLOB NOT NULL,
  created INTEGER NOT NULL
);

CREATE TABLE page_media (
  slug     TEXT NOT NULL,
  media_id INTEGER NOT NULL,
  position INTEGER NOT NULL,
  PRIMARY KEY (slug, media_id)
);

