import 'package:cicl_app/src/states/bmi_state/bmi_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class BmiController extends StateNotifier<BmiState> {
  BmiController() : super(const BmiState());

  void calculateBMI({
    required double heightMeters,
    required double weightKg,
    required double age,
    required bool isMale,
  }) {
    final bmi = weightKg / (heightMeters * heightMeters);

    String category;
    String advice;

    if (bmi < 18.5) {
      category = "Underweight";
      advice = "You should eat more nutritious food and build some muscle mass.";
    } else if (bmi < 24.9) {
      category = "Normal";
      advice = "Great job! Keep up your balanced diet and exercise routine.";
    } else if (bmi < 29.9) {
      category = "Overweight";
      advice = "Consider a calorie-controlled diet and regular exercise.";
    } else {
      category = "Obese";
      advice = "Consult a nutritionist or trainer for a sustainable health plan.";
    }

    // Gender-specific tweak for “Normal”
    if (category == "Normal") {
      advice = isMale
          ? "Ideal range! Maintain muscle tone with strength training."
          : "Excellent! Keep balancing cardio and nutrition for optimal health.";
    }

    state = state.copyWith(bmi: bmi, category: category, advice: advice);
  }

  void clear() => state = const BmiState();
}