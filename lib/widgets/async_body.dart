import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';
import 'core_spiral.dart';

class AsyncBody<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  const AsyncBody({super.key, required this.future, required this.builder});

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: AppFrame(
                background: AppColors.burgundy,
                child: txt('Archive could not be opened:\n${snap.error}', height: 1.5),
              ),
            );
          }
          if (!snap.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: const Center(child: PageLoader()),
            );
          }
          return builder(context, snap.data as T);
        },
      );
}

