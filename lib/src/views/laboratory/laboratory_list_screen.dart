import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/app_colors.dart';
import '../../models/laboratory_model.dart';
import '../../providers/laboratory_provider/laboratory_provider.dart';
import '../../widgets/common_widgets/custom_dropdown_widget.dart';
import '../../widgets/common_widgets/custom_text.dart';
import '../../widgets/common_widgets/custom_textfield.dart';

class LaboratoryListScreen extends ConsumerStatefulWidget {
  const LaboratoryListScreen({super.key});

  @override
  ConsumerState<LaboratoryListScreen> createState() =>
      _LaboratoryListScreenState();
}

class _LaboratoryListScreenState extends ConsumerState<LaboratoryListScreen> {
  String? _selectedProvider;
  final TextEditingController _searchController = TextEditingController();
  List<Laboratory> _filteredLaboratories = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterLaboratories);
  }

  void _filterLaboratories() {
    final laboratoryState = ref.read(laboratoryProvider);
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredLaboratories = laboratoryState.laboratories.where((laboratory) {
        return laboratory.laboratoryName.toLowerCase().contains(query) ||
            laboratory.city.toLowerCase().contains(query) ||
            laboratory.address.toLowerCase().contains(query) ||
            laboratory.contact.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final laboratoryState = ref.watch(laboratoryProvider);
    final providers = ref.watch(laboratoryProvidersProvider);

    // Determine which laboratories to display
    final displayLaboratories = _searchController.text.isNotEmpty
        ? _filteredLaboratories
        : laboratoryState.laboratories;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: CustomText(title: 'Panel Laboratories', fontSize: 18.sp),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Provider Dropdown
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
            child: CustomDropdown(
              items: providers,
              selectedItem: _selectedProvider,
              onChanged: (provider) {
                setState(() => _selectedProvider = provider);
                ref
                    .read(laboratoryProvider.notifier)
                    .fetchLaboratoriesByProvider(provider);
              },
            ),
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
            child: CustomTextField(
              controller: _searchController,
              hintText: 'Search Laboratories',
              prefixIcon: const Icon(Icons.search),
              onChanged: (_) {
                // Filtering is handled by _filterLaboratories listener
              },
            ),
          ),

          // Laboratory List
          Expanded(
            child: laboratoryState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayLaboratories.isEmpty
                ? Center(
                    child: Text(
                      laboratoryState.error ?? 'No laboratories found',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  )
                : ListView.builder(
                    itemCount: displayLaboratories.length,
                    itemBuilder: (context, index) {
                      final laboratory = displayLaboratories[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.sp,
                          vertical: 8.sp,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.buttonColor1,
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          title: CustomText(
                            title: laboratory.laboratoryName,
                            fontSize: 17.sp,
                            weight: FontWeight.bold,
                            color: AppColors.buttonColor1,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: 'City: ${laboratory.city}',
                                fontSize: 15.sp,
                                weight: FontWeight.w600,
                              ),
                              CustomText(
                                title:
                                    'Services: ${laboratory.serviceAgiantItsLocation}',
                                maxLines: 3,
                                fontSize: 15.sp,
                                weight: FontWeight.w600,
                              ),
                              SizedBox(height: 4.sp),
                              CustomText(
                                title: 'Address: ${laboratory.address}',
                                maxLines: 4,
                                fontSize: 15.sp,
                                weight: FontWeight.w600,
                              ),
                              CustomText(
                                title: 'Contact: ${laboratory.contact}',
                                fontSize: 15.sp,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
