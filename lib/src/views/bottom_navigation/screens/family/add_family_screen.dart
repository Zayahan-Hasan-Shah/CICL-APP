import 'dart:developer';
import 'dart:io';

import 'package:cicl_app/src/core/constants/app_assets.dart';
import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/core/constants/app_text.dart';
import 'package:cicl_app/src/core/validations/app_validation.dart';
import 'package:cicl_app/src/models/family_model/add_family_model.dart';
import 'package:cicl_app/src/providers/family_provider/add_family_riverpod.dart';
import 'package:cicl_app/src/states/family_state/add_family_state.dart';
import 'package:cicl_app/src/widgets/common_widgets/attachment_uploader_widget.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_button.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_dropdown_widget.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_textfield.dart';
import 'package:cicl_app/src/widgets/common_widgets/date_picker_widget.dart';
import 'package:cicl_app/src/widgets/family_widget/cnic_input_formtatter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class AddFamilyScreen extends ConsumerStatefulWidget {
  const AddFamilyScreen({super.key});

  @override
  ConsumerState<AddFamilyScreen> createState() => _AddFamilyScreenState();
}

class _AddFamilyScreenState extends ConsumerState<AddFamilyScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _dobCtrl = TextEditingController();
  final TextEditingController _cnicCtrl = TextEditingController();
  String? relationSeleted;
  String? genderSeleted;
  List<PlatformFile> uploadedFiles = [];

  @override
  void initState() {
    super.initState();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _dobCtrl.clear();
    _cnicCtrl.clear();

    setState(() {
      relationSeleted = null;
      genderSeleted = null;
      uploadedFiles = [];
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    _cnicCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AddFamilyState>(addFamilyProvider, (prev, next) {
      if (prev?.loading == true && next.loading == false) {
        if (next.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.message!)));
          _resetForm();
          _showSuccessDialog("New Family Member has Added");
        } else if (next.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.error!)));
        }
      }
    });

    final state = ref.watch(addFamilyProvider);
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
        title: const CustomText(
          title: 'Add Family Member',
          weight: FontWeight.w700,
          alignText: TextAlign.center,
        ),
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
                  headingText("Name", true),
                  SizedBox(height: 1.h),
                  buildTextField(
                    _nameCtrl,
                    'Name Here',
                    isValidate: true,
                    val: AppValidation.checkText,
                  ),
                  SizedBox(height: 1.h),
                  headingText("Date of Birth", true),
                  SizedBox(height: 1.h),
                  DatePickerTextField(
                    controller: _dobCtrl,
                    hintText: 'Select Date',
                    isValidate: true,
                    validator: AppValidation.validatePastDate,
                  ),
                  SizedBox(height: 1.h),
                  headingText("CNIC/B Form", false),
                  SizedBox(height: 1.h),
                  buildTextField(
                    _cnicCtrl,
                    'CNIC/B-Form',
                    isValidate: true,
                    val: AppValidation.cnicValidator,
                    isCNIC: true,
                  ),
                  SizedBox(height: 1.h),
                  headingText("Relation", true),
                  SizedBox(height: 1.h),
                  CustomDropdown(
                    items: ["Spouse", "Son", "Daughter", "Parent"],
                    selectedItem: relationSeleted,
                    onChanged: (value) {
                      setState(() {
                        relationSeleted = value;
                      });
                    },
                  ),
                  SizedBox(height: 1.h),
                  headingText("Gender", true),
                  SizedBox(height: 1.h),
                  CustomDropdown(
                    items: ["Female", "Male"],
                    selectedItem: genderSeleted,
                    onChanged: (value) {
                      setState(() {
                        genderSeleted = value;
                      });
                    },
                  ),
                  SizedBox(height: 1.h),
                  headingText("Attachment File", false),
                  SizedBox(height: 1.h),
                  AttachmentUploader(
                    onFilesChanged: (files) {
                      setState(() {
                        uploadedFiles = files;
                      });
                    },
                  ),
                  SizedBox(height: 1.h),
                  buildAddFamilyButton(),
                  SizedBox(height: 1.h),
                  _buildRestrictions(),
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
    val,
    bool isCNIC = false,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hint,
      validator: isValidate ? val : null,
      inputFormatters: isCNIC ? [CnicInputFormatter()] : null,
      suffixIcon: isSuffix
          ? IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                AppAssets
                    .calendarIcon, // points to your assets/icons/cut_icon.svg
                height: 30,
                width: 20,
              ),
            )
          : null,
    );
  }

  Widget buildAddFamilyButton() {
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
          text: 'Add Family',
          fontSize: 15.sp,
          textColor: AppColors.whiteColor,
          onPressed: () async {
            log("message : $_cnicCtrl");
            log("message : $_dobCtrl");
            log("message : $_nameCtrl");
            log("message : $genderSeleted");
            log("message : $relationSeleted");
            log("message : $uploadedFiles");
            if (_formKey.currentState?.validate() ?? false) {
              if (relationSeleted == null || genderSeleted == null) {
                ScaffoldMessenger.of(context).showSnackBar( 
                  const SnackBar(
                    content: Text("Please select relation and gender"),
                  ),
                );
                return;
              }

              if (uploadedFiles.isEmpty || uploadedFiles.first.path == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select a valid file")),
                );
                return;
              }

              final model = await AddFamilyModel(
                name: _nameCtrl.text.trim(),
                dateOfBirth: _dobCtrl.text.trim(),
                cnic: _cnicCtrl.text.trim(),
                relation: relationSeleted!,
                gender: genderSeleted!,
                attachments: File(uploadedFiles.first.path!), // fix
              );

              ref.read(addFamilyProvider.notifier).addFamilyMember(model);
            }
          },
          gradient: const LinearGradient(
            colors: [AppColors.buttonColor1, AppColors.buttonColor2],
          ),
        ),
      ],
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
            backgroundColor: AppColors.buttonColor1,
            fontSize: 18.sp,
            textColor: AppColors.whiteColor,
            text: "OK",
          ),
        ],
      ),
    );
  }

  Widget _buildRestrictions() {
    return ListView.builder(
      itemCount: familyRestrictions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CustomText(
          title: '${index + 1}. ${familyRestrictions[index]}',
          fontSize: 16.sp,
          color: AppColors.restrictionColor,
        );
      },
    );
  }
}
