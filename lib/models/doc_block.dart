class Span {
  final String text;
  final bool bold, italic, code;
  final String? href;
  const Span(this.text, {this.bold = false, this.italic = false, this.code = false, this.href});
}

sealed class DocBlock {
  const DocBlock();
}

class HeadingBlock extends DocBlock {
  final int level;
  final String text;
  const HeadingBlock(this.level, this.text);
}

class ParagraphBlock extends DocBlock {
  final List<Span> spans;
  const ParagraphBlock(this.spans);
}

class BulletsBlock extends DocBlock {
  final List<List<Span>> items;
  const BulletsBlock(this.items);
}

class TableBlock extends DocBlock {
  final String? caption;
  final List<String> head;
  final List<List<List<Span>>> rows;
  const TableBlock({this.caption, required this.head, required this.rows});
}

class RuleBlock extends DocBlock {
  const RuleBlock();
}

class CodeBlock extends DocBlock {
  final String language, code;
  const CodeBlock(this.language, this.code);
}

class ImageBlock extends DocBlock {
  final String alt, src;
  const ImageBlock(this.alt, this.src);
}

class CardItem {
  final String title;
  final List<Span> body;
  final String? linkLabel, linkHref, imageAlt;
  final int flex;
  const CardItem({
    required this.title,
    this.body = const [],
    this.linkLabel,
    this.linkHref,
    this.imageAlt,
    this.flex = 1,
  });
}

class CardsBlock extends DocBlock {
  final List<CardItem> cards;
  final bool weighted;
  const CardsBlock(this.cards, {this.weighted = false});
}

class AccordionBlock extends DocBlock {
  final String title;
  final bool video;
  final List<DocBlock> children;
  const AccordionBlock({required this.title, this.video = false, required this.children});
}
