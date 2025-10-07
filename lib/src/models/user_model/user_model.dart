class UserModel {
  final String accessToken;
  final String clientCode;
  final int branchCode;
  final String cardNumber;
  final String name;
  final String dateOfBirth;
  final String cnic;
  final String staffCode;
  final String staffDesignation;
  final String staffLocation;
  final String family;

  UserModel({
    required this.accessToken,
    required this.clientCode,
    required this.branchCode,
    required this.cardNumber,
    required this.name,
    required this.dateOfBirth,
    required this.cnic,
    required this.staffCode,
    required this.staffDesignation,
    required this.staffLocation,
    required this.family,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json['access-token'] ?? '',
      clientCode: json['client_code'] ?? '',
      branchCode: json['branch_code'] ?? 0,
      cardNumber: json['card_number'] ?? '',
      name: json['name'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      cnic: json['cnic'] ?? '',
      staffCode: json['staff_code'] ?? '',
      staffDesignation: json['staff_designation'] ?? '',
      staffLocation: json['staff_location'] ?? '',
      family: json['family'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "access-token": accessToken,
      "client_code": clientCode,
      "branch_code": branchCode,
      "card_number": cardNumber,
      "name": name,
      "date_of_birth": dateOfBirth,
      "cnic": cnic,
      "staff_code": staffCode,
      "staff_designation": staffDesignation,
      "staff_location": staffLocation,
      "family": family,
    };
  }
}
