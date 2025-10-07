import 'package:cicl_app/src/widgets/common_widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FamilySearchBar extends StatelessWidget {
  final TextEditingController controller;
  const FamilySearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: CustomTextField(
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
          size: 30,
        ),
        controller: controller,
        hintText: 'Search...',
      ),
    );
  }
}
