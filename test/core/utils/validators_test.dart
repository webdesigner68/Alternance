import 'package:flutter_test/flutter_test.dart';
import 'package:la_bonne_alternance/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateName', () {
      test('should return null for valid name', () {
        expect(
          Validators.validateName('John', fieldName: 'First name'),
          null,
        );
        expect(
          Validators.validateName('A', fieldName: 'First name'),
          null,
        );
        expect(
          Validators.validateName('A' * 50, fieldName: 'First name'),
          null,
        );
      });

      test('should return error for empty name', () {
        expect(
          Validators.validateName('', fieldName: 'First name'),
          'First name est requis',
        );
        expect(
          Validators.validateName(null, fieldName: 'First name'),
          'First name est requis',
        );
      });

      test('should return error for name too long', () {
        expect(
          Validators.validateName('A' * 51, fieldName: 'First name'),
          'First name doit contenir entre 1 et 50 caractères',
        );
      });
    });

    group('validateEmail', () {
      test('should return null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), null);
        expect(Validators.validateEmail('user.name+tag@example.co.uk'), null);
      });

      test('should return error for invalid email', () {
        expect(Validators.validateEmail(''), 'Email est requis');
        expect(Validators.validateEmail(null), 'Email est requis');
        expect(Validators.validateEmail('invalid'), 'Email invalide');
        expect(Validators.validateEmail('test@'), 'Email invalide');
        expect(Validators.validateEmail('@example.com'), 'Email invalide');
      });
    });

    group('validatePhone', () {
      test('should return null for valid phone', () {
        expect(Validators.validatePhone('+33612345678'), null);
        expect(Validators.validatePhone('0612345678'), null);
        expect(Validators.validatePhone('06 12 34 56 78'), null);
        expect(Validators.validatePhone('+44 20 1234 5678'), null);
      });

      test('should return error for invalid phone', () {
        expect(Validators.validatePhone(''), 'Téléphone est requis');
        expect(Validators.validatePhone(null), 'Téléphone est requis');
        expect(Validators.validatePhone('123'), 'Numéro de téléphone invalide');
        expect(
          Validators.validatePhone('abcdefghij'),
          'Numéro de téléphone invalide',
        );
      });
    });
  });
}
