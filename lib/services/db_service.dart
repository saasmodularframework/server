import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../data/products_seed.dart';
import '../models/product.dart';

class Db {
  static const gifCount = 14;
  static Future<Database>? _opening;
  static final Map<int, Uint8List> _bytes = {};

  static Future<Database> get db => _opening ??= _openAndSeed().catchError((Object e) {
        _opening = null;
        throw e;
      });

  static Future<Database> _openAndSeed() async {
    final path = p.join(await getDatabasesPath(), 'saas.db');
    final d = await openDatabase(path, version: 1, onCreate: _create).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('SQLite did not start. On web run: dart run sqflite_common_ffi_web:setup'),
    );
    await _seedIfEmpty(d);
    return d;
  }

  static Future<void> _create(Database d, int version) async {
    await d.execute('CREATE TABLE pages('
        'slug TEXT PRIMARY KEY, position INTEGER NOT NULL, title TEXT NOT NULL, mark TEXT NOT NULL DEFAULT \'\', '
        'version TEXT NOT NULL, start_year INTEGER, summary TEXT NOT NULL, body TEXT NOT NULL, updated INTEGER NOT NULL)');
    await d.execute('CREATE TABLE page_tags(slug TEXT NOT NULL, tag TEXT NOT NULL, PRIMARY KEY(slug, tag))');
    await d.execute('CREATE TABLE media('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, kind TEXT NOT NULL CHECK (kind IN (\'jpg\',\'gif\',\'mp4\')), '
        'name TEXT NOT NULL UNIQUE, mime TEXT NOT NULL, bytes BLOB NOT NULL, created INTEGER NOT NULL)');
    await d.execute('CREATE TABLE page_media('
        'slug TEXT NOT NULL, media_id INTEGER NOT NULL, position INTEGER NOT NULL, PRIMARY KEY(slug, media_id))');
  }

  static Future<Uint8List> _asset(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  static String _two(int i) => i.toString().padLeft(2, '0');

  static Future<void> _seedIfEmpty(Database d) async {
    final count = Sqflite.firstIntValue(await d.rawQuery('SELECT COUNT(*) FROM pages')) ?? 0;
    if (count > 0) return;

    final gifs = <String, Uint8List>{};
    final jpgs = <String, Uint8List>{};
    for (var i = 1; i <= gifCount; i++) {
      gifs['${_two(i)}.gif'] = await _asset('assets/gifs/${_two(i)}.gif');
      jpgs['${_two(i)}.jpg'] = await _asset('assets/images/${_two(i)}.jpg');
    }
    final videos = <String, Uint8List>{
      'reel.mp4': await _asset('assets/videos/reel.mp4'),
      'it-office.mp4': await _asset('assets/videos/it-office.mp4'),
    };
    final now = DateTime.now().millisecondsSinceEpoch;

    await d.transaction((txn) async {
      Future<int> put(String kind, String mime, String name, Uint8List bytes) =>
          txn.insert('media', {'kind': kind, 'name': name, 'mime': mime, 'bytes': bytes, 'created': now});

      final gifIds = <int>[for (final e in gifs.entries) await put('gif', 'image/gif', e.key, e.value)];
      final jpgIds = <int>[for (final e in jpgs.entries) await put('jpg', 'image/jpeg', e.key, e.value)];
      final videoIds = <int>[for (final e in videos.entries) await put('mp4', 'video/mp4', e.key, e.value)];

      final b = txn.batch();
      for (var i = 0; i < seedProducts.length; i++) {
        final s = seedProducts[i];
        b.insert('pages', {
          'slug': s.slug,
          'position': i,
          'title': s.name,
          'mark': s.mark,
          'version': s.version,
          'start_year': s.startYear,
          'summary': s.purpose[0].toUpperCase() + s.purpose.substring(1),
          'body': seedBody(s),
          'updated': now,
        });
        for (final t in s.tagList) {
          b.insert('page_tags', {'slug': s.slug, 'tag': t});
        }

        for (var k = 0; k < gifIds.length; k++) {
          b.insert('page_media', {'slug': s.slug, 'media_id': gifIds[(k + i) % gifIds.length], 'position': k});
        }
        b.insert('page_media', {'slug': s.slug, 'media_id': jpgIds[i % jpgIds.length], 'position': 0});
        b.insert('page_media', {'slug': s.slug, 'media_id': videoIds[i % videoIds.length], 'position': 0});
      }
      await b.commit(noResult: true);
    });
  }

  static Future<List<Product>> pages() async {
    final d = await db;
    final rows = await d.rawQuery(
        'SELECT p.slug, p.position, p.title, p.mark, p.version, p.start_year, p.summary, p.body, '
        '(SELECT pm.media_id FROM page_media pm JOIN media m ON m.id = pm.media_id '
        ' WHERE pm.slug = p.slug AND m.kind = \'jpg\' ORDER BY pm.position LIMIT 1) AS hero '
        'FROM pages p ORDER BY p.position');
    final tagRows = await d.rawQuery('SELECT slug, tag FROM page_tags ORDER BY slug, rowid');
    final tags = <String, List<String>>{};
    for (final r in tagRows) {
      tags.putIfAbsent(r['slug'] as String, () => []).add(r['tag'] as String);
    }
    return [
      for (final r in rows)
        Product(
          slug: r['slug'] as String,
          position: r['position'] as int,
          title: r['title'] as String,
          mark: r['mark'] as String,
          version: r['version'] as String,
          startYear: r['start_year'] as int?,
          summary: r['summary'] as String,
          body: r['body'] as String,
          heroId: r['hero'] as int?,
          tags: tags[r['slug']] ?? const [],
        ),
    ];
  }

  static Future<void> updatePageText(String slug, String summary, String body) async {
    final d = await db;
    await d.update(
      'pages',
      {'summary': summary, 'body': body, 'updated': DateTime.now().millisecondsSinceEpoch},
      where: 'slug = ?',
      whereArgs: [slug],
    );
  }

  static MediaRef _ref(Map<String, Object?> r) =>
      MediaRef(r['id'] as int, r['kind'] as String, r['name'] as String, (r['size'] as int?) ?? 0);

  static Future<List<MediaRef>> mediaFor(String slug, String kind) async {
    final d = await db;
    final rows = await d.rawQuery(
        'SELECT m.id, m.kind, m.name, length(m.bytes) AS size FROM page_media pm '
        'JOIN media m ON m.id = pm.media_id WHERE pm.slug = ? AND m.kind = ? ORDER BY pm.position',
        [slug, kind]);
    return rows.map(_ref).toList();
  }

  static Future<List<MediaRef>> allMedia({String? kind}) async {
    final d = await db;
    final rows = await d.rawQuery(
        'SELECT id, kind, name, length(bytes) AS size FROM media '
        '${kind == null ? '' : 'WHERE kind = ?'} ORDER BY kind, name',
        [if (kind != null) kind]);
    return rows.map(_ref).toList();
  }

  static Uint8List? cached(int id) => _bytes[id];

  static Future<Uint8List> bytes(int id) async {
    final hit = _bytes[id];
    if (hit != null) return hit;
    final d = await db;
    final rows = await d.query('media', columns: ['bytes'], where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) throw StateError('media $id not found');
    final raw = rows.first['bytes'];
    final out = raw is Uint8List ? raw : Uint8List.fromList((raw as List).cast<int>());
    return _bytes[id] = out;
  }

  static Future<int> addMedia(String kind, String name, Uint8List data, {String? slug}) async {
    final d = await db;
    final mime = switch (kind) { 'jpg' => 'image/jpeg', 'gif' => 'image/gif', _ => 'video/mp4' };
    final id = await d.insert('media', {
      'kind': kind,
      'name': name,
      'mime': mime,
      'bytes': data,
      'created': DateTime.now().millisecondsSinceEpoch,
    });
    if (slug != null) {
      final next = Sqflite.firstIntValue(await d.rawQuery(
              'SELECT COALESCE(MAX(pm.position), -1) + 1 FROM page_media pm JOIN media m ON m.id = pm.media_id '
              'WHERE pm.slug = ? AND m.kind = ?',
              [slug, kind])) ??
          0;
      await d.insert('page_media', {'slug': slug, 'media_id': id, 'position': next});
    }
    return id;
  }

  static Future<DbStats> stats() async {
    final d = await db;
    final pages = Sqflite.firstIntValue(await d.rawQuery('SELECT COUNT(*) FROM pages')) ?? 0;
    final text = Sqflite.firstIntValue(
            await d.rawQuery('SELECT COALESCE(SUM(length(summary) + length(body)), 0) FROM pages')) ??
        0;
    final rows = await d.rawQuery('SELECT kind, COUNT(*) AS c, COALESCE(SUM(length(bytes)), 0) AS s FROM media GROUP BY kind');
    int c(String k) => rows.where((r) => r['kind'] == k).fold(0, (a, r) => a + (r['c'] as int));
    final bytes = rows.fold<int>(0, (a, r) => a + (r['s'] as int));
    return DbStats(pages, c('jpg'), c('gif'), c('mp4'), bytes, text);
  }
}

