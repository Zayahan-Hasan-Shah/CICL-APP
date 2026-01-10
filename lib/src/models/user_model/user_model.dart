import 'package:cicl_app/src/models/family_model/family_model.dart';

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
  final List<FamilyModel> family;
  final String married;

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
    required this.married,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> familyJson = json['family'] ?? [];

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
      family: familyJson
          .map((e) => FamilyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      married: json['married'] ?? '',
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
      "family": family
          .map(
            (e) => {
              'branch_code': e.branchCode,
              'client_code': e.clientCode,
              'card_number': e.cardNumber,
              'name': e.name,
              'date_of_birth': e.dateOfBirth,
              'relation': e.relation,
              'gender': e.gender,
              'cnic': e.cnic,
            },
          )
          .toList(),
      "married": married,
    };
  }
}
