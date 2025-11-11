import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/common_widgets/logout_confirmation.dart';
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

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(cardDetailsProvider.notifier).fetchCardDetails();
    });
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
            onPressed: () => showLogoutConfirmationDialog(context),
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
                        title: "Client",
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
