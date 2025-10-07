import 'package:flutter/services.dart';

class CnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // only digits
    var newText = '';

    for (int i = 0; i < text.length; i++) {
      newText += text[i];
      if (i == 4 || i == 11) {
        if (i != text.length - 1) {
          newText += '-';
        }
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}