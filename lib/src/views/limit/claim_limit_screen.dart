import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/models/claim_model.dart/claim_limit_model.dart';
import 'package:cicl_app/src/providers/claim_provider/claim_limit_provider.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/limit_widget/hospitalization_limit_Section.dart';
import 'package:cicl_app/src/widgets/limit_widget/limit_section.dart';
import 'package:cicl_app/src/widgets/limit_widget/limit_tab_button.dart';
import 'package:cicl_app/src/widgets/limit_widget/opd_limit_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class ClaimLimitScreen extends ConsumerStatefulWidget {
  const ClaimLimitScreen({super.key});

  @override
  ConsumerState<ClaimLimitScreen> createState() => _ClaimLimitScreenState();
}

class _ClaimLimitScreenState extends ConsumerState<ClaimLimitScreen> {
  int seletectTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(claimLimitProvider.notifier).fetchClaimLimits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(claimLimitProvider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_outlined),
        ),
        title: CustomText(title: "Claim Limit", fontSize: 18.sp),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.data == null
          ? Center(child: Text("No limits to show"))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Existing tab buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        LimitTabButton(
                          title: "OPD",
                          index: 0,
                          selectedTab: seletectTab,
                          onTap: _onTabSelected,
                        ),
                        SizedBox(width: 2.w),
                        LimitTabButton(
                          title: "HOSPITALIZATION",
                          index: 1,
                          selectedTab: seletectTab,
                          onTap: _onTabSelected,
                        ),
                        SizedBox(width: 2.w),
                        LimitTabButton(
                          title: "LIMITS",
                          index: 2,
                          selectedTab: seletectTab,
                          onTap: _onTabSelected,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Existing tab content
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildTabContent(state.data!.data),
                  ),
                ],
              ),
            ),
    );
  }

  void _onTabSelected(int index) {
    setState(() => seletectTab = index);
  }

  Widget _buildTabContent(UserLimitData data) {
    switch (seletectTab) {
      case 0:
        return OpdLimitSection(data: data);
      case 1:
        return HospitalizationLimitSection(data: data);
      case 2:
        return LimitSection(data: data);
      default:
        return OpdLimitSection(data: data);
    }
  }
}
