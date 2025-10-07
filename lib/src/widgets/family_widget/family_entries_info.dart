import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class FamilyEntriesInfo extends StatelessWidget {
  const FamilyEntriesInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              const Icon(Icons.add_circle, color: AppColors.buttonColor1),
              TextButton(
                onPressed: () {
                  context.push('/addfamilyscreen');
                },
                child: Text(
                  'Add Family Members',
                  style: TextStyle(
                    color: AppColors.buttonColor1,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
