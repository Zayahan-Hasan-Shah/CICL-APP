class FamilyModel {
  final int branchCode;
  final String clientCode;
  final String cardNumber;
  final String name;
  final String dateOfBirth;
  final String relation;
  final String gender;
  final String? cnic;
  final String clientName;

  FamilyModel({
    required this.branchCode,
    required this.clientCode,
    required this.cardNumber,
    required this.name,
    required this.dateOfBirth,
    required this.relation,
    required this.gender,
    required this.clientName,
    this.cnic,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      branchCode: json['branch_code'] ?? 0,
      clientCode: (json['client_code'] ?? '').toString(),
      clientName: (json['client_name'] ?? '').toString(),
      cardNumber: (json['card_number'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      dateOfBirth: (json['date_of_birth'] ?? '').toString(),
      relation: (json['relation'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      cnic: json['cnic']?.toString(),
    );
  }
}
