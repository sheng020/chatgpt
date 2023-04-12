import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:syntax_highlighter/syntax_highlighter.dart' hide SyntaxHighlighter;


class Highlighter extends SyntaxHighlighter {
  @override
  TextSpan format(String source) {
    var style = SyntaxHighlighterStyle.darkThemeStyle();
    return TextSpan(
        style: TextStyle(
          fontSize: 14,
        ),
        children: [DartSyntaxHighlighter(style).format(source)]);
  }
}
