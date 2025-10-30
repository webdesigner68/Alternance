import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

class HtmlSanitizer {
  static const _allowedTags = {
    'b',
    'i',
    'em',
    'strong',
    'p',
    'br',
    'ul',
    'li',
  };

  static String sanitize(String htmlContent) {
    if (htmlContent.isEmpty) return '';

    final document = html_parser.parse(htmlContent);
    final body = document.body;
    if (body == null) return '';

    _sanitizeNode(body);
    return body.innerHtml;
  }

  static void _sanitizeNode(dom.Node node) {
    if (node is dom.Element) {
      final tagName = node.localName?.toLowerCase();

      if (tagName != null && !_allowedTags.contains(tagName)) {
        // Remove disallowed tags but keep content
        final children = node.nodes.toList();
        for (final child in children) {
          node.parent?.insertBefore(child, node);
        }
        node.remove();
        return;
      }

      // Remove all attributes
      node.attributes.clear();
    }

    // Recursively sanitize children
    final children = node.nodes.toList();
    for (final child in children) {
      _sanitizeNode(child);
    }
  }
}
