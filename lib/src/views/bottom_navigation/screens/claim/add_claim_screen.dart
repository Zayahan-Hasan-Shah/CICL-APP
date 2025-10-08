import 'dart:io';

import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/constants/app_text.dart';
import 'package:cicl_app/src/core/storage/storage_service.dart';
import 'package:cicl_app/src/core/validations/app_validation.dart';
import 'package:cicl_app/src/models/claim_model.dart/add_claim_model.dart';
import 'package:cicl_app/src/providers/claim_provider/add_claim_riverpod.dart';
import 'package:cicl_app/src/states/claim_state/add_claim_state.dart';
import 'package:cicl_app/src/widgets/common_widgets/attachment_uploader_widget.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_button.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_dropdown_widget.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_textfield.dart';
import 'package:cicl_app/src/widgets/common_widgets/date_picker_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class AddClaimScreen extends ConsumerStatefulWidget {
  const AddClaimScreen({super.key});

  @override
  ConsumerState<AddClaimScreen> createState() => _AddClaimScreenState();
}

class _AddClaimScreenState extends ConsumerState<AddClaimScreen> {
  // Multiple claim form controllers
  List<TextEditingController> _billNoControllers = [];
  List<TextEditingController> _billDateControllers = [];
  List<TextEditingController> _billAmountControllers = [];
  List<TextEditingController> _hosLabClinDrControllers = [];
  List<TextEditingController> _admissionDateControllers = [];
  List<TextEditingController> _dischargeDateControllers = [];

  List<String?> _patients = [];
  List<String?> _benefitTypes = [];
  List<List<PlatformFile>> _uploadedFilesList = [];
  List<String> _patientNames = []; // Add this line

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadPatientNames();
    // Initialize first claim form
    _addNewClaimForm();
  }

  Future<void> _loadPatientNames() async {
    final storage = StorageService();
    final userName = await storage.getName() ?? '';
    final familyNames = await storage.getFamilyNames();

    setState(() {
      _patientNames = [userName, ...familyNames];
    });
  }

  void _addNewClaimForm() {
    setState(() {
      _billNoControllers.add(TextEditingController());
      _billDateControllers.add(TextEditingController());
      _billAmountControllers.add(TextEditingController());
      _hosLabClinDrControllers.add(TextEditingController());
      _admissionDateControllers.add(TextEditingController());
      _dischargeDateControllers.add(TextEditingController());

      _patients.add(null);
      _benefitTypes.add(null);
      _uploadedFilesList.add([]);
    });
  }

  void _removeClaimForm(int index) {
    setState(() {
      _billNoControllers[index].dispose();
      _billDateControllers[index].dispose();
      _billAmountControllers[index].dispose();
      _hosLabClinDrControllers[index].dispose();
      _admissionDateControllers[index].dispose();
      _dischargeDateControllers[index].dispose();

      _billNoControllers.removeAt(index);
      _billDateControllers.removeAt(index);
      _billAmountControllers.removeAt(index);
      _hosLabClinDrControllers.removeAt(index);
      _admissionDateControllers.removeAt(index);
      _dischargeDateControllers.removeAt(index);

      _patients.removeAt(index);
      _benefitTypes.removeAt(index);
      _uploadedFilesList.removeAt(index);
    });
  }

  void _resetForm() {
    // Dispose all controllers
    for (var controller in _billNoControllers) {
      controller.dispose();
    }
    for (var controller in _billDateControllers) {
      controller.dispose();
    }
    for (var controller in _billAmountControllers) {
      controller.dispose();
    }
    for (var controller in _hosLabClinDrControllers) {
      controller.dispose();
    }
    for (var controller in _admissionDateControllers) {
      controller.dispose();
    }
    for (var controller in _dischargeDateControllers) {
      controller.dispose();
    }

    // Reset all lists
    setState(() {
      _billNoControllers.clear();
      _billDateControllers.clear();
      _billAmountControllers.clear();
      _hosLabClinDrControllers.clear();
      _admissionDateControllers.clear();
      _dischargeDateControllers.clear();

      _patients.clear();
      _benefitTypes.clear();
      _uploadedFilesList.clear();

      // Add a new claim form
      _addNewClaimForm();
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _billNoControllers) {
      controller.dispose();
    }
    for (var controller in _billDateControllers) {
      controller.dispose();
    }
    for (var controller in _billAmountControllers) {
      controller.dispose();
    }
    for (var controller in _hosLabClinDrControllers) {
      controller.dispose();
    }
    for (var controller in _admissionDateControllers) {
      controller.dispose();
    }
    for (var controller in _dischargeDateControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AddClaimState>(addClaimProvider, (prev, next) {
      if (prev?.loading == true && next.loading == false) {
        if (next.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.message!)));
          _resetForm();
          _showSuccessDialog("Claim Save Successfully");
        } else if (next.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed to create claim")));
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.chevron_left_outlined),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const CustomText(
              title: 'Add Claims',
              weight: FontWeight.w700,
              alignText: TextAlign.center,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _addNewClaimForm,
              tooltip: 'Add New Claim',
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: _billNoControllers.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(8.sp),
                padding: EdgeInsets.all(8.sp),

                child: Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_billNoControllers.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeClaimForm(index),
                              tooltip: 'Remove Claim',
                            ),
                        ],
                      ),
                      // Existing form fields for each claim
                      CustomTextField(
                        controller: _billNoControllers[index],
                        hintText: 'Bill Number',
                        validator: AppValidation.checkText,
                      ),
                      SizedBox(height: 1.h),
                      headingText("Bill Date", true),
                      SizedBox(height: 1.h),
                      DatePickerTextField(
                        controller: _billDateControllers[index],
                        hintText: 'Select Date',
                        isValidate: true,
                        validator: AppValidation.validatePastDate,
                      ),
                      SizedBox(height: 1.h),
                      headingText("Patient", true),
                      SizedBox(height: 1.h),
                      CustomDropdown(
                        selectedItem: _patients[index],
                        items: _patientNames,
                        onChanged: (value) {
                          setState(() {
                            _patients[index] = value;
                          });
                        },
                      ),
                      SizedBox(height: 1.h),
                      headingText("Benefit Type", true),
                      SizedBox(height: 1.h),
                      CustomDropdown(
                        items: ["Hospital", "OPD", "Dental Treatment"],
                        selectedItem: _benefitTypes[index],
                        onChanged: (value) {
                          setState(() {
                            _benefitTypes[index] = value;
                          });
                        },
                      ),
                      SizedBox(height: 1.h),
                      headingText("Dr/Hospital", true),
                      buildTextField(
                        _hosLabClinDrControllers[index],
                        'Dr/Hospital',
                      ),
                      SizedBox(height: 1.h),
                      if (_benefitTypes[index] == "Hospital") ...[
                        headingText("Admission Date", true),
                        SizedBox(height: 1.h),
                        DatePickerTextField(
                          controller: _admissionDateControllers[index],
                          hintText: 'Select Date',
                          isValidate: true,
                          validator: AppValidation.validatePastDate,
                        ),
                        SizedBox(height: 1.h),
                        headingText("Discharge Date", true),
                        SizedBox(height: 1.h),
                        DatePickerTextField(
                          controller: _dischargeDateControllers[index],
                          hintText: 'Select Date',
                          isValidate: true,
                          validator: AppValidation.validatePastDate,
                        ),
                      ],
                      SizedBox(height: 1.h),
                      headingText("Bill Amount", true),
                      SizedBox(height: 1.h),
                      buildTextField(
                        _billAmountControllers[index],
                        'Bill Amount',
                        isNoFormat: true,
                      ),
                      SizedBox(height: 1.h),
                      headingText("Attachments", true),
                      SizedBox(height: 1.h),
                      AttachmentUploader(
                        onFilesChanged: (files) {
                          setState(() {
                            _uploadedFilesList[index] = files;
                          });
                        },
                      ),
                      SizedBox(height: 1.h),
                      _buildRestrictions(),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(4.h),
        child: CustomButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Create multiple claims
              final claims = List.generate(
                _billNoControllers.length,
                (index) => AddClaimModel(
                  items: [
                    ClaimItem(
                      billNo: _billNoControllers[index].text.trim(),
                      billDate: _billDateControllers[index].text.trim(),
                      employeeNo: _patients[index]!,
                      serviceCode: _benefitTypes[index].toString(),
                      billAmount: _billAmountControllers[index].text.trim(),
                      hospital: _hosLabClinDrControllers[index].text.trim(),
                      admitDate: _admissionDateControllers[index].text.trim(),
                      dischargeDate: _dischargeDateControllers[index].text
                          .trim(),
                      attachments: _uploadedFilesList[index]
                          .map((f) => Attachment(File(f.path!)))
                          .toList(),
                    ),
                  ],
                ),
              );

              // Submit all claims
              for (var claim in claims) {
                ref.read(addClaimProvider.notifier).addClaim(claim);
              }
            }
          },
          gradient: const LinearGradient(
            colors: [AppColors.buttonColor1, AppColors.buttonColor2],
          ),
          text: 'Submit Claims', // Added missing text parameter
        ),
      ),
    );
  }

  Widget headingText(String text, bool req) {
    return req
        ? Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: Row(
              children: [
                CustomText(
                  title: text,
                  fontSize: 16.sp,
                  weight: FontWeight.w600,
                ),
                const Text(
                  "*",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: Row(
              children: [
                CustomText(
                  title: text,
                  fontSize: 16.sp,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          );
  }

  CustomTextField buildTextField(
    TextEditingController controller,
    String hint, {
    bool isSuffix = false,
    bool isValidate = false,
    String? Function(String?)? val,
    bool isNoFormat = false,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hint,
      validator: isValidate ? val : null,
      keyboardType: isNoFormat ? TextInputType.number : TextInputType.text,
      inputFormatters: isNoFormat
          ? [FilteringTextInputFormatter.digitsOnly]
          : [],
      suffixIcon: isSuffix
          ? IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                AppAssets.calendarIcon,
                height: 30,
                width: 20,
              ),
            )
          : null,
    );
  }

  Widget _buildRestrictions() {
    return ListView.builder(
      itemCount: claimRestrictions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CustomText(
          title: '${index + 1}. ${claimRestrictions[index]}',
          fontSize: 16.sp,
          color: AppColors.restrictionColor,
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetForm(); // Reset form after successful submission
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget buildAddClaimButton() {
    return CustomButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Create multiple claims
          final claims = List.generate(
            _billNoControllers.length,
            (index) => AddClaimModel(
              items: [
                ClaimItem(
                  billNo: _billNoControllers[index].text.trim(),
                  billDate: _billDateControllers[index].text.trim(),
                  employeeNo: _patients[index]!,
                  serviceCode: _benefitTypes[index].toString(),
                  billAmount: _billAmountControllers[index].text.trim(),
                  hospital: _hosLabClinDrControllers[index].text.trim(),
                  admitDate: _admissionDateControllers[index].text.trim(),
                  dischargeDate: _dischargeDateControllers[index].text.trim(),
                  attachments: _uploadedFilesList[index]
                      .map((f) => Attachment(File(f.path!)))
                      .toList(),
                ),
              ],
            ),
          );

          // Submit all claims
          for (var claim in claims) {
            ref.read(addClaimProvider.notifier).addClaim(claim);
          }
        }
      },
      gradient: const LinearGradient(
        colors: [AppColors.buttonColor1, AppColors.buttonColor2],
      ),
      text: 'Submit Claims',
    );
  }
}
