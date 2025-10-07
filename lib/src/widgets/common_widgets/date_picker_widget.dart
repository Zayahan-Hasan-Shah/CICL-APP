import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_assets.dart';
import 'custom_textfield.dart';

class DatePickerTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isValidate;

  const DatePickerTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.isValidate = false,
  }) : super(key: key);

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      validator: isValidate ? validator : null,
      readOnly: true,
      suffixIcon: IconButton(
        onPressed: () => _pickDate(context),
        icon: SvgPicture.asset(AppAssets.calendarIcon, height: 30, width: 20),
      ),
      onTap: () => _pickDate(context), // user can tap textfield too
    );
  }
}
