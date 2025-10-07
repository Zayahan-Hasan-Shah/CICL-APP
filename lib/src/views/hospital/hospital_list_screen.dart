import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/app_colors.dart';
import '../../models/hospital_model.dart';
import '../../providers/hospital_provider/hospital_provider.dart';
import '../../widgets/common_widgets/custom_dropdown_widget.dart';
import '../../widgets/common_widgets/custom_text.dart';
import '../../widgets/common_widgets/custom_textfield.dart';

class HospitalListScreen extends ConsumerStatefulWidget {
  const HospitalListScreen({super.key});

  @override
  ConsumerState<HospitalListScreen> createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends ConsumerState<HospitalListScreen> {
  String? _selectedCity;
  final TextEditingController _searchController = TextEditingController();
  List<PanelHospital> _filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterHospitals);
  }

  void _filterHospitals() {
    final hospitalState = ref.read(hospitalProvider);
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredHospitals = hospitalState.hospitals.where((hospital) {
        return hospital.hospitalName.toLowerCase().contains(query) ||
            hospital.address.toLowerCase().contains(query) ||
            hospital.contact.toLowerCase().contains(query);
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
    final hospitalState = ref.watch(hospitalProvider);
    final cities = ref.watch(citiesProvider);

    // Determine which hospitals to display
    final displayHospitals = _searchController.text.isNotEmpty
        ? _filteredHospitals
        : hospitalState.hospitals;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: CustomText(
          title: 'Panel Hospitals',
          fontSize: 18.sp,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // City Dropdown
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
            child: CustomDropdown(
              items: cities,
              selectedItem: _selectedCity,
              onChanged: (city) {
                setState(() => _selectedCity = city);
                ref.read(hospitalProvider.notifier).fetchHospitalsByCity(city);
              },
            ),
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
            child: CustomTextField(
              controller: _searchController,
              hintText: 'Search Hospitals',
              prefixIcon: const Icon(Icons.search),
              onChanged: (_) {
                // Filtering is handled by _filterHospitals listener
              },
            ),
          ),

          // Hospital List
          Expanded(
            child: hospitalState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayHospitals.isEmpty
                ? Center(
                    child: Text(
                      hospitalState.error ?? 'No hospitals found',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  )
                : ListView.builder(
                    itemCount: displayHospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = displayHospitals[index];
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
                            title: hospital.hospitalName,
                            fontSize: 16.sp,
                            weight: FontWeight.bold,
                            color: AppColors.buttonColor1,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: hospital.address,
                                maxLines: 4,
                                fontSize: 15.sp,
                                weight: FontWeight.w400,
                              ),
                              SizedBox(height: 4.sp),
                              CustomText(
                                title: 'Contact: ${hospital.contact}',
                                fontSize: 14.sp,
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
