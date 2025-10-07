import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/providers/claim_provider/claim_detail_provider.dart';
import 'package:cicl_app/src/states/claim_state/claim_detail_state.dart';
import 'package:cicl_app/src/widgets/claim_widget/claim_detail_widget_section1.dart';
import 'package:cicl_app/src/widgets/claim_widget/claim_detail_widget_section2.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class ClaimDetailScreen extends ConsumerStatefulWidget {
  final String claimNo;
  final String clmseqnos;

  const ClaimDetailScreen({
    super.key,
    required this.claimNo,
    required this.clmseqnos,
  });

  @override
  ConsumerState<ClaimDetailScreen> createState() => _ClaimDetailScreenState();
}

class _ClaimDetailScreenState extends ConsumerState<ClaimDetailScreen> {
  @override
  void initState() {
    super.initState();

    // Call API when screen loads
    Future.microtask(() {
      ref.read(claimProvider.notifier).fetchClaimDetail(widget.clmseqnos);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(claimProvider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_outlined),
        ),
        title: CustomText(
          title: 'Claim#${widget.claimNo}',
          weight: FontWeight.w700,
          color: Colors.black,
          alignText: TextAlign.center,
          fontSize: 18.sp,
        ),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(ClaimDetailState state) {
    if (state is ClaimDetailLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ClaimDetailError) {
      return Center(child: Text(state.message));
    } else if (state is ClaimDetailLoaded) {
      final claim = state.claimDetail.data?.first; // assuming 1 detail
      if (claim == null) {
        return const Center(child: Text("No details available"));
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClaimDetailWidgetSection1(
              name: claim.patientName,
              empno: claim.employeeNo,
            ),
            SizedBox(height: 3.h),
            ClaimDetailWidgetSection2(
              billNumber: claim.billNumber,
              billDate: claim.billDate,
              admitdt: claim.admitDate,
              dischargdt: claim.dischargeDate,
              serviceCode: claim.serviceCode,
              serviceName: claim.serviceName,
              approveAmount: claim.approvedAmount,
              deductAmount: claim.deductedAmount,
              dob: claim.patientDOB,
              relation: claim.patientRelation,
              empno: claim.employeeNo,
              patientName: claim.patientName,
              pateintCNIC: claim.patientCNIC,
            ),

          ],
        ),
      );
    }
    return const SizedBox();
  }
}
