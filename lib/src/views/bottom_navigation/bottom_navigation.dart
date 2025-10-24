import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/models/bottom_navigation_model/bottom_nav_item.dart';
import 'package:cicl_app/src/providers/bottom_navigation_provider/bottom_navigation_provider.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/claim/claim_list_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/family/family_list_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/home/home_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/profile/profile_screen.dart';
import 'package:cicl_app/src/widgets/bottom_navigation_widget/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigation extends ConsumerStatefulWidget {
   final int initialIndex;
  const BottomNavigation({super.key, this.initialIndex = 0});

  @override
  ConsumerState<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const FamilyListScreen(),
    const ClaimListScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavigationProvider);
    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(bottomNavigationProvider.notifier).setIndex(index),
        items: [
          BottomNavItem(
            activeIcon: AppAssets.homeActiveIcon,
            inactiveIcon: AppAssets.homeInacticeIcon,
            label: 'Home',
          ),
          BottomNavItem(
            activeIcon: AppAssets.familyActiveIcon,
            inactiveIcon: AppAssets.familyInactiveIcon,
            label: 'Family',
          ),
          BottomNavItem(
            activeIcon: AppAssets.claimActiveIcon,
            inactiveIcon: AppAssets.claimInactiveIcon,
            label: 'Claim',
          ),
          BottomNavItem(
            activeIcon: AppAssets.profileActiveIcon,
            inactiveIcon: AppAssets.profielInActiveIcon,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
