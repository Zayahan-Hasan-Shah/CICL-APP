import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/providers/family_provider/family_provider.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:cicl_app/src/widgets/common_widgets/logout_confirmation.dart';
import 'package:cicl_app/src/widgets/family_widget/family_entries_info.dart';
import 'package:cicl_app/src/widgets/family_widget/family_list_widget.dart';
import 'package:cicl_app/src/widgets/family_widget/family_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class FamilyListScreen extends ConsumerStatefulWidget {
  const FamilyListScreen({super.key});

  @override
  ConsumerState<FamilyListScreen> createState() => _FamilyListScreenState();
}

class _FamilyListScreenState extends ConsumerState<FamilyListScreen> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    //   ref.read(familyMemberControllerProvider.notifier).fetchFamilyMembers();
    // });
    _searchController.addListener(() {
      setState(() {}); // rebuild UI when search text changes
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(familyMemberControllerProvider);
    final filteredFamily = state.family.where((fam) {
      final query = _searchController.text.toLowerCase();
      final matchText =
          fam.name.toString().toLowerCase().contains(query) ||
          fam.gender.toString().toLowerCase().contains(query) ||
          fam.relation.toString().toLowerCase().contains(query);

      return matchText;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        title: CustomText(
          title: 'My Family',
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
      backgroundColor: Colors.white,
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 1.h),
              FamilySearchBar(controller: _searchController),
              const FamilyEntriesInfo(),
              SizedBox(height: 1.h),
              Expanded(
                child: state.loading
                    ? const Center(child: LoadingIndicator())
                    : state.error != null
                    ? Center(
                        child: CustomText(
                          title: "You didn't add any family member yet",
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(2.h),
                        child: state.family.isEmpty
                            ? Center(
                                child: CustomText(
                                  title: "You didn't add any family member yet",
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 16,
                                      // childAspectRatio: 1.0,
                                    ),
                                itemCount: filteredFamily.length,
                                itemBuilder: (context, index) {
                                  final famMeb = filteredFamily[index];
                                  return FamilyListWidget(
                                    onTap: () {
                                      context.push(
                                        '/familydetailscreen',
                                        extra: famMeb,
                                      );
                                    },
                                    name: famMeb.name,
                                    // relation: famMeb.relation,
                                    // gender: famMeb.gender == 'F'
                                    //     ? 'Female'
                                    //     : 'Male',
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
