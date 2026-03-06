import 'dart:io';

class AddFamilyModel {
  final String name;
  final String dateOfBirth;
  final String? cnic;
  final String relation;
  final String gender;
  final List<File> attachments;

  AddFamilyModel({
    required this.name,
    required this.dateOfBirth,
    this.cnic,
    required this.relation,
    required this.gender,
    required this.attachments,
  });

  static const Map<String, String> _relationToCode = {
    "Spouse": "S",
    "Son": "B",
    "Daughter": "G",
    "Parent": "P",
  };

  static const Map<String, String> _genderToCode = {"Male": "M", "Female": "F"};

  Map<String, dynamic> toFormData() {
    // final relationCode = relation.isNotEmpty ? relation[0] : relation;
    // final genderCode = gender.isNotEmpty ? gender[0] : gender;

    final relationCode =
        _relationToCode[relation.trim()] ??
        (relation.isNotEmpty ? relation[0].toUpperCase() : "");

    final genderCode =
        _genderToCode[gender.trim()] ??
        (gender.isNotEmpty ? gender[0].toUpperCase() : "");

    return {
      "name": name,
      "dateOfBirth": dateOfBirth,
      if (cnic != null && cnic!.isNotEmpty) "cnic": cnic,
      "relation": relationCode,
      "gender": genderCode,
    };
  }
}
