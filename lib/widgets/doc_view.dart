import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:retro_desktop_ui/retro_desktop_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/doc_block.dart';
import '../models/product.dart';
import '../routes.dart';
import '../services/db_service.dart';
import '../theme/app_theme.dart';
import '../theme/app_widgets.dart';
import '../utils/roman.dart';
import 'async_body.dart';
import 'db_video.dart';

const List<String> _monoFallback = ['Courier New', 'Courier', 'Menlo', 'Consolas', 'monospace'];

Future<void> openLink(BuildContext context, String href) async {
  if (href.startsWith('/')) {
    navigate(context, href);
    return;
  }
  try {
    final uri = Uri.tryParse(href);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return;
  }
}

class DocView extends StatelessWidget {
  final List<DocBlock> blocks;
  const DocView({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [for (final b in blocks) DocBlockView(b)],
      );
}

class DocBlockView extends StatelessWidget {
  final DocBlock block;
  const DocBlockView(this.block, {super.key});

  @override
  Widget build(BuildContext context) => switch (block) {
        HeadingBlock b => _Heading(b),
        ParagraphBlock b => Padding(padding: const EdgeInsets.only(bottom: 12), child: RichSpans(b.spans)),
        BulletsBlock b => _Bullets(b),
        TableBlock b => _DocTable(b),
        RuleBlock _ => const AppDivider(),
        CodeBlock b => _Code(b),
        ImageBlock b => _Figure(b),
        CardsBlock b => _Cards(b),
        AccordionBlock b => _Accordion(b),
      };
}

class RichSpans extends StatefulWidget {
  final List<Span> spans;
  final double size;
  final TextAlign? align;
  const RichSpans(this.spans, {super.key, this.size = 13, this.align});

  @override
  State<RichSpans> createState() => _RichSpansState();
}

class _RichSpansState extends State<RichSpans> {
  final List<TapGestureRecognizer> _recognizers = [];

  void _clear() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _clear();
    final base = appStyle(size: widget.size, height: 1.6, spacing: 0.3);
    final children = <InlineSpan>[];
    for (final s in widget.spans) {
      final href = s.href;
      TapGestureRecognizer? tap;
      if (href != null) {
        tap = TapGestureRecognizer()..onTap = () => openLink(context, href);
        _recognizers.add(tap);
      }
      var style = base;
      if (s.bold) style = style.copyWith(fontWeight: FontWeight.w700, color: AppColors.light);
      if (s.italic) style = style.copyWith(fontStyle: FontStyle.italic);
      if (s.code) {
        style = style.copyWith(
          fontFamily: 'monospace',
          fontFamilyFallback: _monoFallback,
          color: AppColors.light,
          backgroundColor: AppColors.navy,
        );
      }
      if (href != null) {
        style = style.copyWith(
          color: AppColors.bronze,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.bronze,
        );
      }
      children.add(TextSpan(
        text: s.text,
        style: style,
        recognizer: tap,
        mouseCursor: href != null ? SystemMouseCursors.click : MouseCursor.defer,
      ));
    }
    return Text.rich(TextSpan(style: base, children: children), textAlign: widget.align);
  }
}

class _Heading extends StatelessWidget {
  final HeadingBlock block;
  const _Heading(this.block);

  @override
  Widget build(BuildContext context) {
    final t = block.text;
    final (double size, double top, bool upper, Color color) = switch (block.level) {
      2 => (17.0, 22.0, true, AppColors.light),
      3 => (15.0, 14.0, false, AppColors.cream),
      4 => (14.0, 12.0, false, AppColors.light),
      _ => (13.0, 16.0, true, AppColors.light),
    };
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: 8),
      child: txt(upper ? t.toUpperCase() : t,
          size: size, weight: FontWeight.w700, spacing: block.level == 2 ? 2 : 1, color: color, height: 1.4),
    );
  }
}

class _Bullets extends StatelessWidget {
  final BulletsBlock block;
  const _Bullets(this.block);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 18, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in block.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 10),
                      child: txt('\u25CF', size: 6, color: AppColors.bronze),
                    ),
                    Expanded(child: RichSpans(item)),
                  ],
                ),
              ),
          ],
        ),
      );
}

class _DocTable extends StatelessWidget {
  final TableBlock block;
  const _DocTable(this.block);

  @override
  Widget build(BuildContext context) {
    var cols = block.head.length;
    for (final r in block.rows) {
      if (r.length > cols) cols = r.length;
    }
    if (cols == 0) return const SizedBox.shrink();
    final border = AppColors.light.withValues(alpha: 0.55);
    Widget pad(Widget w) => Padding(padding: const EdgeInsets.all(8), child: w);

    final rows = <TableRow>[
      if (block.head.isNotEmpty)
        TableRow(
          decoration: BoxDecoration(color: AppColors.burgundy),
          children: [
            for (var i = 0; i < cols; i++)
              pad(i < block.head.length
                  ? txt(block.head[i].toUpperCase(),
                      size: 11.5, weight: FontWeight.w700, spacing: 1.5, color: AppColors.paper)
                  : const SizedBox.shrink()),
          ],
        ),
      for (final r in block.rows)
        TableRow(
          children: [
            for (var i = 0; i < cols; i++) pad(i < r.length ? RichSpans(r[i], size: 12) : const SizedBox.shrink()),
          ],
        ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (block.caption != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: txt(block.caption!, size: 12, weight: FontWeight.w700, spacing: 1.5, color: AppColors.light),
            ),
          LayoutBuilder(
            builder: (context, c) {
              final minWidth = cols * 170.0;
              final width = c.maxWidth < minWidth ? minWidth : c.maxWidth;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: width,
                  child: Table(
                    border: TableBorder.all(color: border, width: 1),
                    defaultColumnWidth: const FlexColumnWidth(),
                    children: rows,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Code extends StatefulWidget {
  final CodeBlock block;
  const _Code(this.block);

  @override
  State<_Code> createState() => _CodeState();
}

class _CodeState extends State<_Code> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.block.code));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: AppFrame(
          background: AppColors.ink,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: txt(widget.block.language.isEmpty ? 'CODE' : widget.block.language.toUpperCase(),
                        size: 11, spacing: 2, weight: FontWeight.w700, color: AppColors.light),
                  ),
                  RetroDesktopButton(_copied ? 'Copied' : 'Copy', onPressed: _copy),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.block.code,
                  softWrap: false,
                  style: appStyle(size: 12, height: 1.5).copyWith(
                    fontFamily: 'monospace',
                    fontFamilyFallback: _monoFallback,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _Figure extends StatelessWidget {
  final ImageBlock block;
  const _Figure(this.block);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AppTap(
          onTap: () => openLink(context, block.src),
          child: AppFrame(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                txt('FIGURE  \u00B7  ${block.alt.toUpperCase()}', size: 12, spacing: 2, weight: FontWeight.w700, color: AppColors.light),
                const SizedBox(height: 4),
                txt(block.src, size: 11, color: AppColors.bronze),
              ],
            ),
          ),
        ),
      );
}

class _Cards extends StatelessWidget {
  final CardsBlock block;
  const _Cards(this.block);

  static const double _gap = 14;

  Widget _card(CardItem c, int? index) => _CardView(c, index == null ? null : roman(index + 1));

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: _gap),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            if (block.weighted) {
              if (w < 720) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final c in block.cards) Padding(padding: const EdgeInsets.only(bottom: _gap), child: _card(c, null)),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < block.cards.length; i++) ...[
                    if (i > 0) const SizedBox(width: _gap),
                    Expanded(flex: block.cards[i].flex, child: _card(block.cards[i], null)),
                  ],
                ],
              );
            }
            final cols = w >= 960 ? 3 : (w >= 620 ? 2 : 1);
            final itemWidth = (w - _gap * (cols - 1)) / cols;
            return Wrap(
              spacing: _gap,
              runSpacing: _gap,
              children: [
                for (var i = 0; i < block.cards.length; i++)
                  SizedBox(width: itemWidth, child: _card(block.cards[i], i)),
              ],
            );
          },
        ),
      );
}

class _CardView extends StatelessWidget {
  final CardItem card;
  final String? badge;
  const _CardView(this.card, this.badge);

  @override
  Widget build(BuildContext context) {
    final label = card.linkLabel;
    final href = card.linkHref;
    return AppRoundedTile(
      leading: badge == null
          ? null
          : Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.burgundy,
                border: Border.all(color: AppColors.light, width: 2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: txt(badge!, size: 11, weight: FontWeight.w700, color: AppColors.paper),
            ),
      title: txt(card.title.toUpperCase(),
          size: 14, weight: FontWeight.w700, spacing: 1.5, color: AppColors.light, height: 1.3),
      children: [
        if (card.body.isNotEmpty) RichSpans(card.body, size: 12.5),
        if (label != null && href != null) ...[
          const SizedBox(height: 8),
          RetroDesktopButton.text(label, onPressed: () => openLink(context, href)),
        ],
      ],
    );
  }
}

class _Accordion extends StatefulWidget {
  final AccordionBlock block;
  const _Accordion(this.block);

  @override
  State<_Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<_Accordion> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final b = widget.block;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: _open,
            label: b.title,
            child: AppTap(
              onTap: () => setState(() => _open = !_open),
              child: AppFrame(
                background: _open ? AppColors.burgundy : AppColors.navy,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: txt(b.title,
                          size: 15,
                          weight: FontWeight.w700,
                          spacing: 2,
                          color: _open ? AppColors.paper : AppColors.light),
                    ),
                    txt(_open ? '\u25B2' : '\u25BC',
                        size: 12, color: _open ? AppColors.paper : AppColors.light),
                  ],
                ),
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (b.video) const _AccordionVideo(),
                  for (final c in b.children) DocBlockView(c),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AccordionVideo extends StatefulWidget {
  const _AccordionVideo();

  @override
  State<_AccordionVideo> createState() => _AccordionVideoState();
}

class _AccordionVideoState extends State<_AccordionVideo> {
  late final Future<List<MediaRef>> _future = Db.allMedia(kind: 'mp4');

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: AsyncBody<List<MediaRef>>(
          future: _future,
          builder: (context, videos) {
            if (videos.isEmpty) return txt('No MP4 stored in the database yet.');
            final pick = videos.where((v) => v.name == 'it-office.mp4').firstOrNull ?? videos.first;
            return DbVideo(media: pick);
          },
        ),
      );
}
