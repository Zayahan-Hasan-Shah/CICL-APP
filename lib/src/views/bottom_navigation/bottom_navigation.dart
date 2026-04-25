import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/models/bottom_navigation_model/bottom_nav_item.dart';
import 'package:cicl_app/src/providers/auth_provider/login_provider.dart';
import 'package:cicl_app/src/providers/bottom_navigation_provider/bottom_navigation_provider.dart';
import 'package:cicl_app/src/providers/family_provider/family_provider.dart';
import 'package:cicl_app/src/providers/claim_provider/claim_provider.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/claim/claim_list_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/family/family_list_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/home/home_screen.dart';
import 'package:cicl_app/src/views/bottom_navigation/screens/profile/profile_screen.dart';
import 'package:cicl_app/src/widgets/bottom_navigation_widget/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

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

  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();

    // Ensure user session–dependent APIs are initialized whenever
    // the dashboard/bottom navigation is loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).initializeUserSession(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Whenever the bottom navigation index changes, lazily (re)fetch
    // data for the corresponding tab so that navigating via Home
    // cards (which only change the index) always loads data.
    ref.listen<int>(bottomNavigationProvider, (previous, next) {
      if (next == 1) {
        // Family tab
        ref.read(familyMemberControllerProvider.notifier).fetchFamilyMembers();
      } else if (next == 2) {
        // Claim tab
        ref
            .read(claimControllerProvider.notifier)
            .fetchClaims(page: 0, pageSize: 10);
      }
    });

    final currentIndex = ref.watch(bottomNavigationProvider);
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          ref.read(bottomNavigationProvider.notifier).setIndex(0);
          return false;
        }

        final now = DateTime.now();
        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 10)) {
          _lastBackPressed = now;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Click again to exit')));
          return false;
        }

        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _screens[currentIndex],
            Positioned(
              left: 4.w,
              right: 4.w,
              bottom: 0,
              child: CustomBottomNavBar(
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
            ),
          ],
        ),
        // bottomNavigationBar: SafeArea(
        //   child: CustomBottomNavBar(
        //     currentIndex: currentIndex,
        //     onTap: (index) =>
        //         ref.read(bottomNavigationProvider.notifier).setIndex(index),
        //     items: [
        //       BottomNavItem(
        //         activeIcon: AppAssets.homeActiveIcon,
        //         inactiveIcon: AppAssets.homeInacticeIcon,
        //         label: 'Home',
        //       ),
        //       BottomNavItem(
        //         activeIcon: AppAssets.familyActiveIcon,
        //         inactiveIcon: AppAssets.familyInactiveIcon,
        //         label: 'Family',
        //       ),
        //       BottomNavItem(
        //         activeIcon: AppAssets.claimActiveIcon,
        //         inactiveIcon: AppAssets.claimInactiveIcon,
        //         label: 'Claim',
        //       ),
        //       BottomNavItem(
        //         activeIcon: AppAssets.profileActiveIcon,
        //         inactiveIcon: AppAssets.profielInActiveIcon,
        //         label: 'Profile',
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
