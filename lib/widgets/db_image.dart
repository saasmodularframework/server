import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../services/db_service.dart';
import '../theme/app_theme.dart';

class DbImage extends StatelessWidget {
  final int? mediaId;
  final BoxFit fit;
  final double? width, height;
  final int? cacheWidth;

  const DbImage(this.mediaId, {super.key, this.fit = BoxFit.cover, this.width, this.height, this.cacheWidth});

  @override
  Widget build(BuildContext context) {
    final id = mediaId;
    final placeholder = SizedBox(width: width, height: height, child: ColoredBox(color: AppColors.ink));
    if (id == null) return placeholder;
    return FutureBuilder<Uint8List>(
      future: Db.bytes(id),
      initialData: Db.cached(id),
      builder: (context, snap) {
        final data = snap.data;
        if (data == null) return placeholder;
        return Image.memory(
          data,
          width: width,
          height: height,
          fit: fit,
          cacheWidth: cacheWidth,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => placeholder,
        );
      },
    );
  }
}

