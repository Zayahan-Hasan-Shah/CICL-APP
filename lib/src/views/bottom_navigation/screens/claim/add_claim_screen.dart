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
  final TextEditingController _billNo = TextEditingController();
  final TextEditingController _billDate = TextEditingController();
  final TextEditingController _billAmount = TextEditingController();
  final TextEditingController _hosLabClinDr =
      TextEditingController(); // Hospital/Laboratory/Clinic/DrName
  final TextEditingController _admissionDate = TextEditingController();
  final TextEditingController _dischargeDate = TextEditingController();
  String? patient;
  String? benefitType;
  List<PlatformFile> uploadedFiles = [];
  List<String> _patientNames = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadPatientNames();
  }

  Future<void> _loadPatientNames() async {
    final storage = StorageService();
    final userName = await storage.getName() ?? '';
    final familyNames = await storage.getFamilyNames();

    setState(() {
      _patientNames = [userName, ...familyNames];
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _billNo.clear();
    _billDate.clear();
    _hosLabClinDr.clear();
    _billAmount.clear();
    _admissionDate.clear();
    _dischargeDate.clear();
    setState(() {
      patient = null;
      benefitType = null;
      uploadedFiles = [];
    });
  }

  @override
  void dispose() {
    _billNo.dispose();
    _billDate.dispose();
    _hosLabClinDr.dispose();
    _billAmount.dispose();
    _admissionDate.dispose();
    _dischargeDate.dispose();
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
    final state = ref.watch(addClaimProvider);
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
          children: const [
            Spacer(),
            CustomText(
              title: 'Add Claim',
              weight: FontWeight.w700,
              alignText: TextAlign.center,
            ),
            Spacer(),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  headingText("ID (Bill No)", true),
                  SizedBox(height: 1.h),
                  buildTextField(
                    _billNo,
                    'Bill Number',
                    isValidate: true,
                    val: AppValidation.checkText,
                  ),
                  SizedBox(height: 1.h),
                  headingText("Bill Date", true),
                  SizedBox(height: 1.h),
                  DatePickerTextField(
                    controller: _billDate,
                    hintText: 'Select Date',
                    isValidate: true,
                    validator: AppValidation.validatePastDate,
                  ),
                  SizedBox(height: 1.h),
                  headingText("Patient", true),
                  SizedBox(height: 1.h),
                  CustomDropdown(
                    selectedItem: patient,
                    items: _patientNames,
                    onChanged: (value) {
                      setState(() {
                        patient = value;
                      });
                    },
                  ),
                  SizedBox(height: 1.h),
                  headingText("Benefit Type", true),
                  SizedBox(height: 1.h),
                  CustomDropdown(
                    items: ["Hospital", "OPD", "Dental Treatment"],
                    selectedItem: benefitType,
                    onChanged: (value) {
                      setState(() {
                        benefitType = value;
                      });
                    },
                  ),
                  SizedBox(height: 1.h),
                  headingText("Dr/Hospital", true),
                  buildTextField(_hosLabClinDr, 'Dr/Hospital'),
                  SizedBox(height: 1.h),
                  if (benefitType == "Hospital") ...[
                    headingText("Admission Date", true),
                    SizedBox(height: 1.h),
                    DatePickerTextField(
                      controller: _admissionDate,
                      hintText: 'Select Date',
                      isValidate: true,
                      validator: AppValidation.validatePastDate,
                    ),
                    SizedBox(height: 1.h),
                    headingText("Discharge Date", true),
                    SizedBox(height: 1.h),
                    DatePickerTextField(
                      controller: _dischargeDate,
                      hintText: 'Select Date',
                      isValidate: true,
                      validator: AppValidation.validatePastDate,
                    ),
                  ],
                  SizedBox(height: 1.h),
                  headingText("Bill Amount", true),
                  SizedBox(height: 1.h),
                  buildTextField(_billAmount, 'Bill Amount', isNoFormat: true),
                  SizedBox(height: 1.h),
                  headingText("Attachments", true),
                  SizedBox(height: 1.h),
                  AttachmentUploader(
                    onFilesChanged: (files) {
                      setState(() {
                        uploadedFiles = files;
                      });
                    },
                  ),
                  SizedBox(height: 1.h),
                  _buildRestrictions(),
                  SizedBox(height: 1.h),
                  buildAddClaimButton(),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
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
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          CustomButton(
            onPressed: () {
              Navigator.pop(context);
            },
            fontSize: 18.sp,
            textColor: AppColors.whiteColor,
            text: "OK",
          ),
        ],
      ),
    );
  }

  Widget buildAddClaimButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomButton(
          text: 'Cancel',
          fontSize: 16.sp,
          outlined: true,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          borderColor: AppColors.buttonColor1,
          onPressed: () {
            _resetForm();
          },
        ),
        CustomButton(
          text: 'Add Claim',
          fontSize: 15.sp,
          textColor: AppColors.whiteColor,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Extra manual checks
              if (patient == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select a patient")),
                );
                return;
              }
              if (benefitType == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select a benefit type")),
                );
                return;
              }
              if (uploadedFiles.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please upload at least one attachment"),
                  ),
                );
                return;
              }

              final claim = AddClaimModel(
                items: [
                  ClaimItem(
                    billNo: _billNo.text.trim(),
                    billDate: _billDate.text.trim(),
                    employeeNo: patient!,
                    serviceCode: benefitType.toString(),
                    billAmount: _billAmount.text.trim(),
                    hospital: _hosLabClinDr.text.trim(),
                    admitDate: _admissionDate.text.trim(),
                    dischargeDate: _dischargeDate.text.trim(),
                    attachments: uploadedFiles
                        .map((f) => Attachment(File(f.path!)))
                        .toList(),
                  ),
                ],
              );

              ref.read(addClaimProvider.notifier).addClaim(claim);
            }
          },
          gradient: const LinearGradient(
            colors: [AppColors.buttonColor1, AppColors.buttonColor2],
          ),
        ),
      ],
    );
  }
}
