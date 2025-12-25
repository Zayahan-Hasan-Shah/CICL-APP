class FamilyModel {
  final int branchCode;
  final String clientCode;
  final String cardNumber;
  final String name;
  final String dateOfBirth;
  final String relation;
  final String gender;
  final String? cnic;

  FamilyModel({
    required this.branchCode,
    required this.clientCode,
    required this.cardNumber,
    required this.name,
    required this.dateOfBirth,
    required this.relation,
    required this.gender,
    this.cnic,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      branchCode: json['branch_code'],
      clientCode: json['client_code'],
      cardNumber: json['card_number'],
      name: json['name'],
      dateOfBirth: json['date_of_birth'],
      relation: json['relation'],
      gender: json['gender'],
      cnic: json['cnic']?.toString(),
    );
  }
}
