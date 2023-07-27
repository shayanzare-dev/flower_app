import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newString = newValue.text;
    if (newString.isNotEmpty && !newString.contains('.')) {
      // Add comma separator after every 3 digits
      newString = newString.replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
    }
    return newValue.copyWith(text: newString);
  }
}
