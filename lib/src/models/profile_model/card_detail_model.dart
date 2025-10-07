import 'dart:convert';

CardDetailsResponse cardDetailsResponseFromJson(String str) =>
    CardDetailsResponse.fromJson(json.decode(str));

class CardDetailsResponse {
  final int code;
  final CardDetailsData? data;
  final String? message;
  final String? errors;

  CardDetailsResponse({
    required this.code,
    this.data,
    this.message,
    this.errors,
  });

  factory CardDetailsResponse.fromJson(Map<String, dynamic> json) =>
      CardDetailsResponse(
        code: json["code"],
        data: json["data"] == null
            ? null
            : CardDetailsData.fromJson(json["data"]),
        message: json["message"],
        errors: json["errors"],
      );
}

class CardDetailsData {
  final String clientName;
  final String policyNumber;
  final String expiryDate;
  final String employeeName;
  final String employeeDesignation;
  final String cardNumber;
  final String plan;
  final int age;
  final String employeeId;
  final String cnic;
  final Limits limits;
  final List<FamilyMember> familyMembers;

  CardDetailsData({
    required this.clientName,
    required this.policyNumber,
    required this.expiryDate,
    required this.employeeName,
    required this.employeeDesignation,
    required this.cardNumber,
    required this.plan,
    required this.age,
    required this.employeeId,
    required this.cnic,
    required this.limits,
    required this.familyMembers,
  });

  factory CardDetailsData.fromJson(Map<String, dynamic> json) =>
      CardDetailsData(
        clientName: json["clientName"],
        policyNumber: json["policyNumber"],
        expiryDate: json["expiryDate"],
        employeeName: json["employeeName"],
        employeeDesignation: json["employeeDesignation"],
        cardNumber: json["cardNumber"],
        plan: json["plan"],
        age: json["age"],
        employeeId: json["employeeId"],
        cnic: json["cnic"],
        limits: Limits.fromJson(json["limits"]),
        familyMembers: List<FamilyMember>.from(
          json["familyMembers"].map((x) => FamilyMember.fromJson(x)),
        ),
      );
}

class Limits {
  final String roomLimit;
  final String normalDelivery;
  final String cSection;

  Limits({
    required this.roomLimit,
    required this.normalDelivery,
    required this.cSection,
  });

  factory Limits.fromJson(Map<String, dynamic> json) => Limits(
    roomLimit: json["roomLimit"],
    normalDelivery: json["normalDelivery"],
    cSection: json["cSection"],
  );
}

class FamilyMember {
  final int branchCode;
  final String clientCode;
  final String cardNumber;
  final String name;
  final String dateOfBirth;
  final String relation;
  final String gender;
  final String cnic;

  FamilyMember({
    required this.branchCode,
    required this.clientCode,
    required this.cardNumber,
    required this.name,
    required this.dateOfBirth,
    required this.relation,
    required this.gender,
    required this.cnic,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
    branchCode: json["branch_code"],
    clientCode: json["client_code"],
    cardNumber: json["card_number"],
    name: json["name"],
    dateOfBirth: json["date_of_birth"],
    relation: json["relation"],
    gender: json["gender"],
    cnic: json["cnic"],
  );
}
