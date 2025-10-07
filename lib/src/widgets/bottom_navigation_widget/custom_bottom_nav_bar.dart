import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/models/bottom_navigation_model/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class CustomBottomNavBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(0.2.h),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.buttonColor1,
        unselectedItemColor: AppColors.greyColor,
        showUnselectedLabels: true,
        onTap: onTap,
        items: items.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final item = entry.value;
            final isActive = index == currentIndex;

            return BottomNavigationBarItem(
              icon: SvgPicture.asset(
                isActive ? item.activeIcon : item.inactiveIcon,
                height: 4.h,
              ),
              label: item.label,
            );
          },
        ).toList(),
      ),
    );
  }
}
