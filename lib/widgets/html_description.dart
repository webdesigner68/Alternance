import 'package:flutter/material.dart';
import '../core/utils/html_sanitizer.dart';

class HtmlDescription extends StatelessWidget {
  const HtmlDescription({
    required this.htmlContent,
    super.key,
  });

  final String htmlContent;

  @override
  Widget build(BuildContext context) {
    final sanitized = HtmlSanitizer.sanitize(htmlContent);
    
    // For simplicity, we'll render the HTML as plain text with basic formatting
    // In production, you might want to use flutter_html package
    // But to avoid extra dependencies and keep it simple:
    return Text(
      _stripHtmlTags(sanitized),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  String _stripHtmlTags(String html) {
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return html.replaceAll(exp, '').replaceAll('&nbsp;', ' ').trim();
  }
}
