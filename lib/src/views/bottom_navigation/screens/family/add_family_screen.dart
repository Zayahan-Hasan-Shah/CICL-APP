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
import 'package:flutter/services.dart';
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
  int _formResetCounter = 0;
  bool _declarationAccepted = false;

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
      _formResetCounter++;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    _cnicCtrl.dispose();
    super.dispose();
  }

  bool get _isFormReady {
    return (_formKey.currentState?.validate() ?? false) &&
        relationSeleted != null &&
        genderSeleted != null &&
        uploadedFiles.isNotEmpty &&
        _declarationAccepted;
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
                    keyboardType: TextInputType.name,
                    inputFormatter: FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z\s]'),
                    ),
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
                    // CNIC/B-Form is optional; validator only checks format
                    // when user has entered some value.
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
                    key: ValueKey(_formResetCounter),
                    initialValue: uploadedFiles,
                    onFilesChanged: (files) {
                      setState(() {
                        uploadedFiles = files;
                      });
                    },
                  ),
                  SizedBox(height: 1.h),
                  buildAddFamilyButton(),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 40,
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
                          "I hereby certify and acknowledge that the information provided is correct to the best of my knowledge and the Family Member submitted are legitimate - officially covered under the company’s rules.",
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
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
    TextInputType keyboardType = TextInputType.text,
    TextInputFormatter? inputFormatter,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hint,
      validator: isValidate ? val : null,
      inputFormatters: isCNIC
          ? [CnicInputFormatter()]
          : inputFormatter != null
          ? [inputFormatter]
          : null,
      keyboardType: keyboardType,
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
          textColor: _isFormReady ? AppColors.whiteColor : Colors.black54,
          onPressed: () {
            if (!_isFormReady) {
              if (!_declarationAccepted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please accept the declaration to proceed"),
                  ),
                );
                return;
              }
              if (relationSeleted == null || genderSeleted == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select relation and gender"),
                  ),
                );
                return;
              }
              if (uploadedFiles.isEmpty ||
                  uploadedFiles.any((f) => f.path == null)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please attach at least one valid file"),
                  ),
                );
                return;
              }
              // If form fields are invalid
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please fill all required fields correctly"),
                ),
              );
              return;
            }

            // proceed with submission
            final model = AddFamilyModel(
              name: _nameCtrl.text.trim(),
              dateOfBirth: _dobCtrl.text.trim(),
              cnic: _cnicCtrl.text.trim(),
              relation: relationSeleted!,
              gender: genderSeleted!,
              attachments: uploadedFiles
                  .where((f) => f.path != null)
                  .map((f) => File(f.path!))
                  .toList(),
            );
            ref.read(addFamilyProvider.notifier).addFamilyMember(model);
            // if (_formKey.currentState?.validate() ?? false) {

            //   if (relationSeleted == null || genderSeleted == null) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(
            //         content: Text("Please select relation and gender"),
            //       ),
            //     );
            //     return;
            //   }

            //   if (!_declarationAccepted) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(
            //         content: Text("Please accept the declaration"),
            //       ),
            //     );
            //     return;
            //   }

            //   if (uploadedFiles.isEmpty || uploadedFiles.first.path == null) {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text("Please select a valid file")),
            //     );
            //     return;
            //   }

            //   final model = AddFamilyModel(
            //     name: _nameCtrl.text.trim(),
            //     dateOfBirth: _dobCtrl.text.trim(),
            //     cnic: _cnicCtrl.text.trim(),
            //     relation: relationSeleted!,
            //     gender: genderSeleted!,
            //     attachments: uploadedFiles
            //         .where((f) => f.path != null)
            //         .map((f) => File(f.path!))
            //         .toList(),
            //   );

            //   ref.read(addFamilyProvider.notifier).addFamilyMember(model);
            // }
          },
          gradient: _isFormReady
              ? const LinearGradient(
                  colors: [AppColors.buttonColor1, AppColors.buttonColor2],
                )
              : LinearGradient(colors: [Colors.grey, Colors.grey.shade400]),
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
              // Close dialog
              Navigator.pop(context);
              // Navigate back to family list screen
              context.pop();
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
