class Product {
  final String slug, title, mark, version, summary, body;
  final int position;
  final int? startYear;
  final int? heroId;
  final List<String> tags;

  const Product({
    required this.slug,
    required this.position,
    required this.title,
    required this.mark,
    required this.version,
    required this.startYear,
    required this.summary,
    required this.body,
    required this.heroId,
    required this.tags,
  });

  String get display => '$title$mark';

  String get versionLabel => 'v$version-pre';

  String get copyright {
    final now = DateTime.now().year;
    final from = startYear;
    return from == null || from >= now ? '© $now' : '© $from-$now';
  }
}

class MediaRef {
  final int id, size;
  final String kind, name;
  const MediaRef(this.id, this.kind, this.name, this.size);

  String get sizeLabel => size >= 1048576
      ? '${(size / 1048576).toStringAsFixed(2)} MB'
      : '${(size / 1024).toStringAsFixed(1)} KB';
}

class DbStats {
  final int pages, jpg, gif, mp4, mediaBytes, textBytes;
  const DbStats(this.pages, this.jpg, this.gif, this.mp4, this.mediaBytes, this.textBytes);
}

