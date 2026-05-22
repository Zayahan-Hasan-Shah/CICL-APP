import 'dart:io';

import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
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
  final List<TextEditingController> _billNoControllers = [];
  final List<TextEditingController> _billDateControllers = [];
  final List<TextEditingController> _billAmountControllers = [];
  final List<TextEditingController> _hosLabClinDrControllers = [];
  final List<TextEditingController> _admissionDateControllers = [];
  final List<TextEditingController> _dischargeDateControllers = [];

  final List<String?> _patients = [];
  final List<String?> _benefitTypes = [];
  final List<List<PlatformFile>> _uploadedFilesList = [];
  List<String> _patientNames = [];
  // Map from patient display-name to their card_number
  final Map<String, String> _patientCardNumbers = {};

  bool _declarationAccepted = false;
  int _formResetCounter = 0;

  // Add restriction map for benefit types
  final Map<String, List<String>> _benefitTypeRestrictions = {
    "Hospital": [
      "All receipts and bills (including itemized hospital and pharmacy invoices) must be original.",
      "A copy of the discharge summary.",
      "A copy of Birth certificate is required in case of maternity.",
    ],
    "OPD": ["All OPD-related receipts and invoices must be original."],
    "Dental Treatment": [
      "All Dental-related receipts and invoices must be original.",
      "Dental X-rays must be submitted.",
    ],
  };

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
    final userCardNumber = await storage.getCardNumber() ?? '';
    final familyNames = await storage.getFamilyNames();
    final familyCardNumbers = await storage.getFamilyCardNumbers();

    final Map<String, String> cardMap = {};
    if (userName.isNotEmpty) {
      cardMap[userName] = userCardNumber;
    }
    for (int i = 0; i < familyNames.length; i++) {
      final name = familyNames[i];
      final card = i < familyCardNumbers.length ? familyCardNumbers[i] : '';
      cardMap[name] = card;
    }

    setState(() {
      _patientNames = [userName, ...familyNames];
      _patientCardNumbers
        ..clear()
        ..addAll(cardMap);
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

      _formResetCounter++;

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

  Future<void> _submitAllClaims() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
        ),
      );
      return;
    }

    // Optional: validate dropdowns
    for (int i = 0; i < _patients.length; i++) {
      if (_patients[i] == null || _benefitTypes[i] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select Patient and Benefit Type for all claims',
            ),
          ),
        );
        return;
      }
    }

    final storage = StorageService();
    // Fallback: current user's own card number
    final userCardNumber = (await storage.getCardNumber()) ?? '';

    final claims = List.generate(_billNoControllers.length, (index) {
      final benefitType = _benefitTypes[index];
      final isHospital = benefitType == "Hospital";
      final selectedPatient = _patients[index] ?? '';

      // Use the selected patient's card number if available,
      // otherwise fall back to the current user's card number.
      final employeeNo =
          _patientCardNumbers[selectedPatient]?.isNotEmpty == true
              ? _patientCardNumbers[selectedPatient]!
              : userCardNumber;

      // Map selected benefit type to correct service code
      String serviceCode;
      switch (benefitType) {
        case "Hospital":
          serviceCode = "20001";
          break;
        case "Dental Treatment":
          serviceCode = "70003";
          break;
        case "OPD":
        default:
          serviceCode = "70005";
          break;
      }

      return AddClaimModel(
        items: [
          ClaimItem(
            billNo: _billNoControllers[index].text.trim(),
            billDate: _billDateControllers[index].text.trim(),
            employeeNo: employeeNo,
            serviceCode: serviceCode,
            billAmount: _billAmountControllers[index].text.trim(),
            hospital: _hosLabClinDrControllers[index].text.trim(),
            admitDate: isHospital
                ? _admissionDateControllers[index].text.trim()
                : "",
            dischargeDate: isHospital
                ? _dischargeDateControllers[index].text.trim()
                : "",
            attachments: _uploadedFilesList[index]
                .map((f) => Attachment(File(f.path!)))
                .toList(),
          ),
        ],
      );
    });

    for (var claim in claims) {
      ref.read(addClaimProvider.notifier).addClaim(claim);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addClaimState = ref.watch(addClaimProvider);
    final bool isLoading = addClaimState.loading;
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
                        key: ValueKey('attachment_${_formResetCounter}_$index'),
                        initialValue: _uploadedFilesList[index],
                        onFilesChanged: (files) {
                          setState(() {
                            _uploadedFilesList[index] = files;
                          });
                          if (files.isNotEmpty) {
                            final navigator = Navigator.of(context);
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (dialogContext) {
                                return const AlertDialog(
                                  content: Text(
                                    "Hard copies of the Bill's/Receipt's (in original) to be maintained by respective policy holder for submission to CICL (if required)",
                                  ),
                                );
                              },
                            );

                            Future.delayed(const Duration(seconds: 3), () {
                              if (!mounted) return;
                              if (navigator.canPop()) {
                                navigator.pop();
                              }
                            });
                          }
                        },
                      ),
                      SizedBox(height: 1.h),
                      _buildRestrictions(_benefitTypes[index]),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---- Declaration + Checkbox ----
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Checkbox(
                        value: _declarationAccepted,
                        onChanged: (val) {
                          setState(() => _declarationAccepted = val ?? false);
                        },
                        activeColor: AppColors.buttonColor1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "I hereby certify that the information provided is correct to the best of my knowledge and that the medical expense claims submitted are valid under the company’s rules.",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 12),
              CustomButton(
                onPressed: (_declarationAccepted && !isLoading)
                    ? _submitAllClaims
                    : () {},
                gradient: LinearGradient(
                  colors: (_declarationAccepted && !isLoading)
                      ? [AppColors.buttonColor1, AppColors.buttonColor2]
                      : [Colors.grey.shade400, Colors.grey.shade600],
                ),
                width: 40.h,
                text: isLoading ? 'Submitting...' : 'Submit Claims',
              ),
            ],
          ),
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

  Widget _buildRestrictions(String? benefitType) {
    final restrictions =
        benefitType != null && _benefitTypeRestrictions.containsKey(benefitType)
        ? _benefitTypeRestrictions[benefitType]!
        : [];
    return restrictions.isNotEmpty
        ? ListView.builder(
            itemCount: restrictions.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CustomText(
                title: '${index + 1}. ${restrictions[index]}',
                fontSize: 16.sp,
                color: AppColors.restrictionColor,
              );
            },
          )
        : const SizedBox.shrink();
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Claim Submitted'),
        content: Text(message),
        actions: [
          CustomButton(
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: AppColors.buttonColor1,
            fontSize: 18.sp,
            textColor: AppColors.whiteColor,
            text: "OK",
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
          final storage = StorageService();

          storage.getCardNumber().then((cardNumberValue) async {
            final cardNumber = (cardNumberValue ?? '').trim();

            final claims = List.generate(
              _billNoControllers.length,
              (index) {
                final benefitType = _benefitTypes[index];

                String serviceCode;
                switch (benefitType) {
                  case "Hospital":
                    serviceCode = "20001";
                    break;
                  case "Dental Treatment":
                    serviceCode = "70003";
                    break;
                  case "OPD":
                  default:
                    serviceCode = "70005";
                    break;
                }

                return AddClaimModel(
                  items: [
                    ClaimItem(
                      billNo: _billNoControllers[index].text.trim(),
                      billDate: _billDateControllers[index].text.trim(),
                      employeeNo: cardNumber,
                      serviceCode: serviceCode,
                      billAmount: _billAmountControllers[index].text.trim(),
                      hospital: _hosLabClinDrControllers[index].text.trim(),
                      admitDate: _admissionDateControllers[index].text.trim(),
                      dischargeDate:
                          _dischargeDateControllers[index].text.trim(),
                      attachments: _uploadedFilesList[index]
                          .map((f) => Attachment(File(f.path!)))
                          .toList(),
                    ),
                  ],
                );
              },
            );

            // Submit all claims
            for (var claim in claims) {
              ref.read(addClaimProvider.notifier).addClaim(claim);
            }
          });
        }
      },
      gradient: const LinearGradient(
        colors: [AppColors.buttonColor1, AppColors.buttonColor2],
      ),
      text: 'Submit Claims',
    );
  }
}
