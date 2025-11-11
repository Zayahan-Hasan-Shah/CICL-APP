import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GreetingWidget extends StatelessWidget {
  final String? name;
  const GreetingWidget({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.h,
      margin: EdgeInsets.all(0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: '$name',
                fontSize: 18.sp,
                weight: FontWeight.w600,
              ),
              SizedBox(height: 0.5.h),
            ],
          ),
        ],
      ),
    );
  }
}
