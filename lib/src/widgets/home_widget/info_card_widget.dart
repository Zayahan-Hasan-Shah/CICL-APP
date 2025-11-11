import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class InfoCardWidget extends ConsumerWidget {
  final String icon;
  final String title;
  final void Function(WidgetRef ref, BuildContext context) onTap;
  final Color iconBgColor;

  const InfoCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => onTap(ref, context),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(icon),
            SizedBox(height: 1.5.h),
            _buildTitle(title),
            SizedBox(height: 0.2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String icon) {
    return CircleAvatar(
      backgroundColor: AppColors.backgroundColor,
      radius: 3.h,
      child: SvgPicture.asset(
        icon,
        height: 3.h,
      ),
    );
  }

  Widget _buildTitle(String title) {
    return CustomText(
      title: title,
      fontSize: 16.sp,
      weight: FontWeight.w600,
      alignText: TextAlign.center,
    );
  }

}



// GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 14.h,
//         width: 1,
//         margin: EdgeInsets.symmetric(vertical: 2.w),
//         padding: EdgeInsets.all(0.345.w),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: AppColors.borderGradientColor,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 8,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white, // background inside border
//             borderRadius: BorderRadius.circular(14),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(1.5.w),
//                 height: 10.h,
//                 width: 10.h,
//                 decoration: BoxDecoration(
//                   color: iconBgColor.withAlpha(70),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: iconBgColor),
//                 ),
//                 child: Icon(icon, color: iconBgColor, size: 5.h),
//               ),
//               SizedBox(width: 3.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CustomText(
//                       title: title,
//                       fontSize: 20.sp,
//                       weight: FontWeight.bold,
//                     ),
//                     CustomText(
//                       title: description,
//                       fontSize: 16.sp,
//                       maxLines: 2,
//                       color: AppColors.lightGreyColor,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );