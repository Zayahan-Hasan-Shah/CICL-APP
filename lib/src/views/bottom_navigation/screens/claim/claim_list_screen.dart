// import 'package:cicl_app/src/core/constants/app_colors.dart';
// import 'package:cicl_app/src/providers/claim_provider/claim_provider.dart';
// import 'package:cicl_app/src/widgets/claim_widget/claim_entries_info.dart';
// import 'package:cicl_app/src/widgets/claim_widget/claim_list_widget.dart';
// // import 'package:cicl_app/src/widgets/claim_widget/claim_pagination.dart';
// import 'package:cicl_app/src/widgets/claim_widget/claim_search_bar.dart';
// import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
// import 'package:cicl_app/src/widgets/common_widgets/loading_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sizer/sizer.dart';

// class ClaimListScreen extends ConsumerStatefulWidget {
//   const ClaimListScreen({super.key});

//   @override
//   ConsumerState<ClaimListScreen> createState() => _ClaimListScreenState();
// }

// class _ClaimListScreenState extends ConsumerState<ClaimListScreen> {
//   int pageNo = 0;
//   int pagePerClaim = 10;
//   // DateTime? _startDate;
//   // DateTime? _endDate;
//   final _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref
//           .read(claimControllerProvider.notifier)
//           .fetchClaims(page: 0, pageSize: 10);
//     });
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200) {
//         // 👇 Load next page when close to bottom
//         _loadMoreClaims();
//       }
//     });
//     _searchController.addListener(() {
//       setState(() {}); // rebuild UI when search text changes
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadMoreClaims() async {
//     final state = ref.read(claimControllerProvider);

//     // Prevent duplicate calls
//     if (state.loading || state.claims.length >= state.total) return;

//     setState(() {
//       pageNo++;
//     });

//     await ref
//         .read(claimControllerProvider.notifier)
//         .fetchClaims(page: pageNo, pageSize: pagePerClaim);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(claimControllerProvider);

//     final filteredClaims = state.claims.where((claim) {
//       final query = _searchController.text.toLowerCase();

//       // Text search
//       final matchesText =
//           claim.srvcode.toString().toLowerCase().contains(query) ||
//               claim.clmseqnos.toLowerCase().contains(query) ||
//               claim.cuserid.toLowerCase().contains(query) ||
//               claim.billamount.toString().toLowerCase().contains(query) ||
//               claim.reportdate.toLowerCase().contains(query) ||
//               claim.deductamount.toString().toLowerCase().contains(query) ||
//               claim.approvamt.toString().toLowerCase().contains(query);

//       // 📅 Date filter
//       // bool matchesDate = true;
//       // if (_startDate != null && _endDate != null) {
//       //   try {
//       //     final claimDate = DateTime.parse(claim.reportdate);
//       //     matchesDate = claimDate
//       //             .isAfter(_startDate!.subtract(const Duration(days: 1))) &&
//       //         claimDate.isBefore(_endDate!.add(const Duration(days: 1)));
//       //   } catch (_) {
//       //     matchesDate = true;
//       //   }
//       // }

//       // return matchesText && matchesDate;
//       return matchesText;
//     }).toList();

//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(height: 2.h),
//             CustomText(
//               title: 'My Claims',
//               alignText: TextAlign.center,
//               fontSize: 20.sp,
//             ),
//             // Search + Calendar
//             ClaimSearchBar(
//               controller: _searchController,
//               onDateRangeSelected: (start, end) {
//                 // setState(() {
//                 //   _startDate = start;
//                 //   _endDate = end;
//                 // });
//               },
//             ),
//             SizedBox(height: 0.1.h),
//             ClaimEntriesInfo(
//               start: filteredClaims.isEmpty ? 0 : 1,
//               end: filteredClaims.length,
//               total: state.total,
//             ),
//             SizedBox(height: 1.h),
//             // Claim list
//             Expanded(
//               child: state.loading
//                   ? const Center(child: LoadingIndicator())
//                   : state.error != null
//                       ? Center(
//                           child: CustomText(
//                           title: "You don't have any claims yet",
//                         ))
//                       : Padding(
//                           padding: EdgeInsetsGeometry.all(0.5.h),
//                           child: state.claims.isEmpty
//                               ? Center(
//                                   child: CustomText(
//                                       title: "You don't have any claims yet"),
//                                 )
//                               : GridView.builder(
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     crossAxisSpacing: 4,
//                                     mainAxisSpacing: 4,
//                                     // childAspectRatio: 1.0,
//                                   ),
//                                   // itemCount: filteredClaims.length,
//                                   itemCount: filteredClaims.length + 1,
//                                   itemBuilder: (context, index) {
//                                     if (index == filteredClaims.length) {
//                                       // Loader at bottom while fetching more
//                                       return state.loading
//                                           ? const Center(
//                                               child: LoadingIndicator(),
//                                             )
//                                           : const SizedBox();
//                                     }
//                                     final claim = filteredClaims[index];
//                                     return Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 2.h,
//                                         vertical: 1.h,
//                                       ),
//                                       child: ClaimListWidget(
//                                         onTap: () {},
//                                         srvCode: claim.srvcode,
//                                         clmsEqnos: claim.clmseqnos,
//                                         cuserId: claim.cuserid,
//                                         billAmount: claim.billamount,
//                                         reportDate: claim.reportdate,
//                                         deductAmount: claim.deductamount,
//                                         approveAmount: claim.approvamt,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                         ),
//             ),
//             // // ⬅️➡️ Pagination
//             // ClaimPagination(
//             //   pageNo: pageNo,
//             //   total: state.total,
//             //   pageSize: pagePerClaim,
//             //   onPageChanged: (newPage) {
//             //     setState(() => pageNo = newPage);
//             //     ref.read(claimControllerProvider.notifier).fetchClaims(
//             //           page: newPage,
//             //           pageSize: pagePerClaim,
//             //         );
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/providers/claim_provider/claim_provider.dart';
import 'package:cicl_app/src/widgets/claim_widget/claim_entries_info.dart';
import 'package:cicl_app/src/widgets/claim_widget/claim_list_widget.dart';
// import 'package:cicl_app/src/widgets/claim_widget/claim_pagination.dart';
import 'package:cicl_app/src/widgets/claim_widget/claim_search_bar.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:cicl_app/src/widgets/common_widgets/logout_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class ClaimListScreen extends ConsumerStatefulWidget {
  const ClaimListScreen({super.key});

  @override
  ConsumerState<ClaimListScreen> createState() => _ClaimListScreenState();
}

class _ClaimListScreenState extends ConsumerState<ClaimListScreen> {
  int pageNo = 0;
  final int pagePerClaim = 10;
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Load initial claims
    // Future.microtask(() {
    //   ref.read(claimControllerProvider.notifier).fetchClaims(
    //         page: pageNo,
    //         pageSize: pagePerClaim,
    //       );
    // });

    // Add scroll listener for infinite scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreClaims();
      }
    });

    _searchController.addListener(() {
      setState(() {}); // rebuild UI when search text changes
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreClaims() async {
    final state = ref.read(claimControllerProvider);

    // Prevent duplicate calls
    if (state.loading || state.claims.length >= state.total) return;

    setState(() {
      pageNo++;
    });

    await ref
        .read(claimControllerProvider.notifier)
        .fetchClaims(page: pageNo, pageSize: pagePerClaim);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(claimControllerProvider);

    final filteredClaims = state.claims.where((claim) {
      final query = _searchController.text.toLowerCase();

      return claim.srvcode.toString().toLowerCase().contains(query) ||
          claim.clmseqnos.toLowerCase().contains(query) ||
          claim.cuserid.toLowerCase().contains(query) ||
          claim.billamount.toString().toLowerCase().contains(query) ||
          claim.reportdate.toLowerCase().contains(query) ||
          claim.deductamount.toString().toLowerCase().contains(query) ||
          claim.approvamt.toString().toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        title: CustomText(
          title: 'My Claims',
          alignText: TextAlign.center,
          fontSize: 20.sp,
        ),
        actions: [
          IconButton(
            onPressed: () => showLogoutConfirmationDialog(context),
            icon: Icon(Icons.logout_outlined, color: Colors.black, size: 24.sp),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search + Calendar
            ClaimSearchBar(
              controller: _searchController,
              onDateRangeSelected: (start, end) {
                // you can add date filters here later
              },
            ),
            SizedBox(height: 0.1.h),
            ClaimEntriesInfo(
              start: filteredClaims.isEmpty ? 0 : (pageNo * pagePerClaim) + 1,
              // end: filteredClaims.length,
              total: state.total,
            ),
            SizedBox(height: 1.h),
            // Claim list
            Expanded(
              child: state.loading && state.claims.isEmpty
                  ? const Center(child: LoadingIndicator())
                  : state.error != null
                  ? Center(
                      child: CustomText(title: "You don't have any claims yet"),
                    )
                  : Padding(
                      padding: EdgeInsets.all(0.5.h),
                      child: state.claims.isEmpty
                          ? Center(
                              child: CustomText(
                                title: "You don't have any claims yet",
                              ),
                            )
                          : GridView.builder(
                              controller: _scrollController,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4,
                                  ),
                              itemCount: filteredClaims.length + 1,
                              itemBuilder: (context, index) {
                                if (index == filteredClaims.length) {
                                  // Loader at bottom while fetching more
                                  return state.loading
                                      ? const Center(child: LoadingIndicator())
                                      : const SizedBox();
                                }

                                final claim = filteredClaims[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.h,
                                    vertical: 1.h,
                                  ),
                                  child: ClaimListWidget(
                                    onTap: () {
                                      context.push(
                                        '/claimdetailscreen',
                                        extra: claim
                                            .clmseqnos, // pass the claim number / id
                                      );
                                    },
                                    srvCode: claim.srvcode,
                                    clmsEqnos: claim.clmseqnos,
                                    cuserId: claim.cuserid,
                                    billAmount: claim.billamount,
                                    reportDate: claim.reportdate,
                                    deductAmount: claim.deductamount,
                                    approveAmount: claim.approvamt,
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
