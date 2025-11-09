class BmiState {
  final double? bmi;
  final String category;
  final String advice;

  const BmiState({this.bmi, this.category = '', this.advice = ''});

  BmiState copyWith({double? bmi, String? category, String? advice}) {
    return BmiState(
      bmi: bmi ?? this.bmi,
      category: category ?? this.category,
      advice: advice ?? this.advice,
    );
  }

  bool get hasResult => bmi != null;
}
