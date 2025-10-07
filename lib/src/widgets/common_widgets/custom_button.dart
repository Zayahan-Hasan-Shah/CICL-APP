// import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final bool outlined;
//   final double? width;
//   final Gradient? gradient;
//   final double? borderRadius;
//   final Color? textColor;
//   final double? fontSize;
//    final Color? backgroundColor;

//   const CustomButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.outlined = false,
//     this.width,
//     this.gradient,
//     this.borderRadius,
//     this.textColor,
//     this.fontSize,
//     this.backgroundColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (gradient != null) {
//       return SizedBox(
//         width: width,
//         child: DecoratedBox(
//           decoration: BoxDecoration(
//             gradient: gradient,
//             borderRadius: BorderRadius.circular(borderRadius ?? 8),
//           ),
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.transparent,
//               shadowColor: Colors.transparent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(borderRadius ?? 8),
//               ),
//             ),
//             onPressed: onPressed,
//             child: Text(text, style:  TextStyle(color: Colors.white, fontSize: fontSize ?? 14.sp)),
//           ),
//         ),
//       );
//     }
//     return SizedBox(
//       width: width,
//       child: outlined
//           ? OutlinedButton(
//               onPressed: onPressed,
//               style: OutlinedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(borderRadius ?? 8),
//                 ),
//               ),
//               child: CustomText(
//                 title: text,
//                 color: textColor ?? Colors.black,
//               ),
//             )
//           : ElevatedButton(
//               onPressed: onPressed,
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(borderRadius ?? 8),
//                 ),
//               ),
//               child: Text(text),
//             ),
//     );
//   }
// }

import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool outlined;
  final double? width;
  final Gradient? gradient;
  final Color? backgroundColor; // <-- NEW
  final double? borderRadius;
  final Color? textColor;
  final double? fontSize;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.outlined = false,
    this.width,
    this.gradient,
    this.backgroundColor, // <-- NEW
    this.borderRadius,
    this.textColor,
    this.fontSize,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    // --- Case 1: Gradient background ---
    if (gradient != null) {
      return SizedBox(
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: fontSize ?? 14.sp,
              ),
            ),
          ),
        ),
      );
    }

    // --- Case 2: Outlined ---
    if (outlined) {
      return SizedBox(
        width: width,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor ?? Colors.black, width: 20.w),
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
          child: CustomText(
            title: text,
            color: textColor ?? Colors.black,
            fontSize: fontSize ?? 14.sp,
          ),
        ),
      );
    }

    // --- Case 3: Solid backgroundColor OR default ---
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 14.sp,
          ),
        ),
      ),
    );
  }
}
