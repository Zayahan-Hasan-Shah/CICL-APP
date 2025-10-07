class FamilyModel {
  final int branch_code;
  final String client_code;
  final String card_number;
  final String name;
  final String date_of_birth;
  final String relation;
  final String gender;
  final String? cnic;

  FamilyModel({
    required this.branch_code,
    required this.client_code,
    required this.card_number,
    required this.name,
    required this.date_of_birth,
    required this.relation,
    required this.gender,
    this.cnic,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      branch_code: json['branch_code'],
      client_code: json['client_code'],
      card_number: json['card_number'],
      name: json['name'],
      date_of_birth: json['date_of_birth'],
      relation: json['relation'],
      gender: json['gender'],
      cnic: json['cnic']?.toString(),
    );
  }
}
