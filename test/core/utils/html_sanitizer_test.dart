import 'package:flutter_test/flutter_test.dart';
import 'package:la_bonne_alternance/core/utils/html_sanitizer.dart';

void main() {
  group('HtmlSanitizer', () {
    test('should allow safe tags', () {
      final input = '<p>Hello <b>world</b></p>';
      final output = HtmlSanitizer.sanitize(input);
      expect(output, contains('Hello'));
      expect(output, contains('world'));
    });

    test('should remove disallowed tags', () {
      final input = '<script>alert("xss")</script><p>Safe</p>';
      final output = HtmlSanitizer.sanitize(input);
      expect(output, isNot(contains('script')));
      expect(output, contains('Safe'));
    });

    test('should remove attributes', () {
      final input = '<p class="test" onclick="alert()">Text</p>';
      final output = HtmlSanitizer.sanitize(input);
      expect(output, isNot(contains('class')));
      expect(output, isNot(contains('onclick')));
    });

    test('should handle empty input', () {
      expect(HtmlSanitizer.sanitize(''), '');
    });

    test('should allow list tags', () {
      final input = '<ul><li>Item 1</li><li>Item 2</li></ul>';
      final output = HtmlSanitizer.sanitize(input);
      expect(output, contains('Item 1'));
      expect(output, contains('Item 2'));
    });
  });
}
