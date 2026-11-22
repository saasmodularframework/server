import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppState {
  static final preset = ValueNotifier<int>(0);

  static final dark = ValueNotifier<bool>(true);

  static final chisel = ValueNotifier<bool>(true);

  static Listenable get theme => Listenable.merge([preset, dark, chisel]);

  static void rebuildOnChange() => theme.addListener(() {
        void visit(Element e) {
          e.markNeedsBuild();
          e.visitChildren(visit);
        }

        WidgetsBinding.instance.rootElement?.visitChildren(visit);
      });
}

