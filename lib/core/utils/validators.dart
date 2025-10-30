class Validators {
  static String? validateName(String? value, {required String fieldName}) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    if (value.length < 1 || value.length > 50) {
      return '$fieldName doit contenir entre 1 et 50 caractères';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email est requis';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Téléphone est requis';
    }

    // Remove spaces, dashes, dots, parentheses
    final cleaned = value.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');

    // European phone number validation (basic)
    // Accepts +33, 0033, or leading 0 for France
    // Also accepts other EU formats
    final phoneRegex = RegExp(
      r'^(\+|00)?[1-9]\d{8,14}$',
    );

    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }
}
