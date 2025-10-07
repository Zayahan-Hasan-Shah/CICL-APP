import 'package:intl/intl.dart';

class AppValidation {
  static String? checkText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be Empty';
    }
    return null;
  }

  String formatAmount(num amount) {
    final formatter = NumberFormat('#,##0.##', 'en_PK');
    return formatter.format(amount);
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  static String? validatePastDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date can\'t be empty';
    }

    try {
      final inputDate = DateFormat('yyyy-MM-dd').parseStrict(value);
      final today = DateTime.now();

      if (inputDate.isAfter(today)) {
        return 'Date cannot be in the future';
      }
    } catch (e) {
      return 'Enter a valid date (yyyy-MM-dd)';
    }

    return null;
  }

  static String? cnicValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CNIC/B-Form is required';
    } else if (!RegExp(r'^\d{5}-\d{7}-\d{1}$').hasMatch(value.trim())) {
      return 'Enter CNIC in XXXXX-XXXXXXX-X format';
    }
    return null;
  }

  static String? fileValidator(files) {
    if (files == null || files.isEmpty) {
      return "Please upload at least one file";
    }
    if (files.length > 3) {
      return "You can upload a maximum of 3 files";
    }
    for (final file in files) {
      if ((file.size / 1024 / 1024) > 5) {
        // 5MB limit
        return "File ${file.name} is too large (max 5MB)";
      }
    }
    return null;
  }
}
