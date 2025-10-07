import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/services/logout_service.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/profile_widget/empolyee_info_section.dart';
import 'package:cicl_app/src/widgets/profile_widget/family_info_section.dart';
import 'package:cicl_app/src/widgets/profile_widget/office_info_section.dart';
import 'package:cicl_app/src/widgets/profile_widget/profile_avatar.dart';
import 'package:cicl_app/src/providers/profile_provider/card_detail_provider.dart';
import 'package:cicl_app/src/models/profile_model/card_detail_model.dart';
import 'package:cicl_app/src/widgets/profile_widget/profile_tab_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int selectedTab = 0;
  late LogoutService _logoutService;

  @override
  void initState() {
    super.initState();
    // Initialize logout service with StorageService
    _logoutService = LogoutService(StorageService());

    Future.microtask(() {
      ref.read(cardDetailsProvider.notifier).fetchCardDetails();
    });
  }

  // Logout confirmation dialog
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Are you sure you want to logout?')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                _logoutService.logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cardDetailsProvider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        title: CustomText(title: "Profile", fontSize: 18.sp),
        actions: [
          IconButton(
            onPressed: _showLogoutConfirmationDialog,
            icon: Icon(Icons.logout_outlined, color: Colors.black, size: 24.sp),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.data == null
          ? Center(child: Text("No Data yet"))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(3.h),
              child: Column(
                children: [
                  const ProfileAvatar(),
                  SizedBox(height: 3.h),

                  // Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileTabButton(
                        title: "Office",
                        index: 0,
                        selectedTab: selectedTab,
                        onTap: _onTabSelected,
                      ),
                      SizedBox(width: 2.w),
                      ProfileTabButton(
                        title: "Employee",
                        index: 1,
                        selectedTab: selectedTab,
                        onTap: _onTabSelected,
                      ),
                      SizedBox(width: 2.w),
                      ProfileTabButton(
                        title: "Family",
                        index: 2,
                        selectedTab: selectedTab,
                        onTap: _onTabSelected,
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Tab content
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildTabContent(state.data!),
                  ),
                ],
              ),
            ),
    );
  }

  void _onTabSelected(int index) {
    setState(() => selectedTab = index);
  }

  Widget _buildTabContent(CardDetailsData data) {
    switch (selectedTab) {
      case 0:
        return OfficeInfoSection(data: data);
      case 1:
        return EmployeeInfoSection(data: data);
      case 2:
        return FamilyInfoSection(data: data);
      default:
        return OfficeInfoSection(data: data);
    }
  }
}





  // Widget _buildFamilyInfo(CardDetailsData data) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: AppColors.whiteColor,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //         width: 1.5,
  //         color: AppColors.buttonColor1.withAlpha(77),
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         // 🧾 Header Row
  //         Container(
  //           padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.h),
  //           decoration: BoxDecoration(
  //             color: AppColors.buttonColor1.withAlpha(30),
  //             borderRadius: const BorderRadius.vertical(
  //               top: Radius.circular(12),
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 flex: 2,
  //                 child: CustomText(
  //                   title: "Family Member",
  //                   fontSize: 16.sp,
  //                   weight: FontWeight.bold,
  //                   color: AppColors.buttonColor1,
  //                 ),
  //               ),
  //               Container(width: 1, height: 3.h, color: AppColors.buttonColor1),
  //               Expanded(
  //                 flex: 1,
  //                 child: CustomText(
  //                   title: "Age",
  //                   fontSize: 16.sp,
  //                   weight: FontWeight.bold,
  //                   color: AppColors.buttonColor1,
  //                   alignText: TextAlign.center,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),

  //         // 👇 Table Rows
  //         ListView.separated(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: data.familyMembers.length,
  //           separatorBuilder: (_, __) => Divider(
  //             color: AppColors.buttonColor1.withAlpha(60),
  //             height: 2,
  //             thickness: 1,
  //           ),
  //           itemBuilder: (context, index) {
  //             final member = data.familyMembers[index];
  //             final age = _calculateAge(member.dateOfBirth);

  //             return Container(
  //               padding: EdgeInsets.symmetric(horizontal: 2.h),
  //               decoration: BoxDecoration(
  //                 color: index.isEven
  //                     ? AppColors.buttonColor1.withAlpha(10)
  //                     : Colors.transparent,
  //               ),
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                     flex: 2,
  //                     child: Padding(
  //                       padding: EdgeInsetsGeometry.all(1.h),
  //                       child: CustomText(
  //                         title: member.name,
  //                         fontSize: 16.sp,
  //                         weight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ),
  //                   Container(
  //                     width: 1,
  //                     height: 2.h,
  //                     color: AppColors.buttonColor1,
  //                   ),
  //                   Expanded(
  //                     flex: 1,
  //                     child: Padding(
  //                       padding: EdgeInsetsGeometry.all(1.h),
  //                       child: CustomText(
  //                         title: "$age",
  //                         fontSize: 16.sp,
  //                         weight: FontWeight.w500,
  //                         alignText: TextAlign.center,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }