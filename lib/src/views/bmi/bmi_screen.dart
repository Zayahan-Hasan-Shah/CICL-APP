import 'package:cicl_app/src/core/constants/app_colors.dart';
import 'package:cicl_app/src/providers/bmi_provider/bmi_provider.dart';
import 'package:cicl_app/src/states/bmi_state/bmi_state.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_button.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_text.dart';
import 'package:cicl_app/src/widgets/common_widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class BmiScreen extends ConsumerStatefulWidget {
  const BmiScreen({super.key});

  @override
  ConsumerState<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends ConsumerState<BmiScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isMale = true;
  bool _heightInFeet = true;
  bool _weightInKg = true;

  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bmiProvider.notifier).clear();
      _heightCtrl.clear();
      _weightCtrl.clear();
      _ageCtrl.clear();
    });
  }

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  // Helper conversion methods
  double _convertHeightToMeters(String text) {
    final value = double.parse(text.trim());
    return _heightInFeet ? value * 0.3048 : value / 100.0;
  }

  double _convertWeightToKg(String text) {
    final value = double.parse(text.trim());
    return _weightInKg ? value : value * 0.453592;
  }

  void _swapHeightUnit() {
    if (_heightCtrl.text.isEmpty) {
      setState(() => _heightInFeet = !_heightInFeet);
      return;
    }
    final v = double.tryParse(_heightCtrl.text.trim());
    if (v == null) return;

    final converted = _heightInFeet ? v * 30.48 : v / 30.48;
    _heightCtrl.text = converted.toStringAsFixed(2);
    setState(() => _heightInFeet = !_heightInFeet);
  }

  void _swapWeightUnit() {
    if (_weightCtrl.text.isEmpty) {
      setState(() => _weightInKg = !_weightInKg);
      return;
    }
    final v = double.tryParse(_weightCtrl.text.trim());
    if (v == null) return;

    final converted = _weightInKg ? v * 2.20462 : v / 2.20462;
    _weightCtrl.text = converted.toStringAsFixed(2);
    setState(() => _weightInKg = !_weightInKg);
  }

  @override
  Widget build(BuildContext context) {
    final bmiState = ref.watch(bmiProvider);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left_outlined),
        ),
        backgroundColor: AppColors.whiteColor,
        title: CustomText(title: "BMI", fontSize: 18.sp),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: EdgeInsets.all(4.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _genderCard(),
                      SizedBox(height: 2.h),
                      _heightField(),
                      SizedBox(height: 2.h),
                      _weightField(),
                      SizedBox(height: 2.h),
                      _ageField(),
                      SizedBox(height: 3.h),
                      _calculateButton(),
                      if (bmiState.hasResult) ...[
                        SizedBox(height: 3.h),
                        _resultCard(bmiState),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderCard() => Container(
    padding: EdgeInsets.all(2.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: _genderBtn(
            Icons.male,
            "MALE",
            _isMale,
            () => setState(() => _isMale = true),
          ),
        ),
        SizedBox(width: 2.h),
        Expanded(
          child: _genderBtn(
            Icons.female,
            "FEMALE",
            !_isMale,
            () => setState(() => _isMale = false),
          ),
        ),
      ],
    ),
  );

  Widget _genderBtn(
    IconData icon,
    String label,
    bool selected,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(colors: AppColors.buttonGradientColor)
            : null,
        color: selected ? null : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32.sp,
            color: selected ? Colors.white : Colors.black54,
          ),
          SizedBox(height: 1.h),
          CustomText(
            title: label,
            fontSize: 16.sp,
            weight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black45,
          ),
        ],
      ),
    ),
  );

  Widget _heightField() => CustomTextField(
    controller: _heightCtrl,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
    ],
    hintText: _heightInFeet ? "Enter Height (ft)" : "Enter Height (cm)",
    prefixIcon: Icon(Icons.height, color: AppColors.buttonColor1, size: 24.sp),
    suffixIcon: GestureDetector(
      onTap: _swapHeightUnit,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.swap_horiz_rounded,
            color: AppColors.buttonColor1,
            size: 18.sp,
          ),
          SizedBox(width: 1.w),
          Text(
            _heightInFeet ? "ft" : "cm",
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.buttonColor1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
    validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
  );

  Widget _weightField() => CustomTextField(
    controller: _weightCtrl,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
    ],
    hintText: _weightInKg ? "Enter Weight (kg)" : "Enter Weight (lb)",
    prefixIcon: Icon(
      Icons.monitor_weight,
      color: AppColors.buttonColor1,
      size: 24.sp,
    ),
    suffixIcon: GestureDetector(
      onTap: _swapWeightUnit,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.swap_horiz_rounded,
            color: AppColors.buttonColor1,
            size: 18.sp,
          ),
          SizedBox(width: 1.w),
          Text(
            _weightInKg ? "kg" : "lb",
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.buttonColor1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
    validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
  );

  Widget _ageField() => CustomTextField(
    controller: _ageCtrl,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    hintText: "Enter Age",
    prefixIcon: Icon(Icons.cake, color: AppColors.buttonColor1, size: 24.sp),
    validator: (v) => v?.trim().isEmpty ?? true ? "Required" : null,
  );

  Widget _calculateButton() => SizedBox(
    width: double.infinity,
    child: CustomButton(
      text: "Calculate",
      fontSize: 18.sp,
      onPressed: () {
        if (!_formKey.currentState!.validate()) return;

        final heightM = _convertHeightToMeters(_heightCtrl.text);
        final weightKg = _convertWeightToKg(_weightCtrl.text);
        final age = double.parse(_ageCtrl.text.trim());

        ref
            .read(bmiProvider.notifier)
            .calculateBMI(
              heightMeters: heightM,
              weightKg: weightKg,
              age: age,
              isMale: _isMale,
            );
      },
      gradient: const LinearGradient(
        colors: [AppColors.buttonColor1, AppColors.buttonColor2],
      ),
      borderRadius: 12,
    ),
  );

  Widget _resultCard(BmiState state) {
    final color = switch (state.category) {
      "Underweight" => Colors.blue,
      "Normal" => Colors.green,
      "Overweight" => Colors.orange,
      "Obese" => Colors.red,
      _ => Colors.grey,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.buttonGradientColor),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("BMI:", state.bmi!.toStringAsFixed(2)),
          _row("CATEGORY:", state.category, color: color),
          const SizedBox(height: 8),
          CustomText(
            title: "ADVICE:",
            color: AppColors.whiteColor,
            fontSize: 18.sp,
            weight: FontWeight.bold,
          ),
          CustomText(
            title: state.advice,
            color: AppColors.whiteColor,
            fontSize: 18.sp,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? color}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        title: label,
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        weight: FontWeight.bold,
      ),
      CustomText(
        title: value,
        color: color ?? AppColors.whiteColor,
        fontSize: 20.sp,
        weight: FontWeight.bold,
      ),
    ],
  );
}
