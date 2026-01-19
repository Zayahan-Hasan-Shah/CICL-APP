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

  Map<String, dynamic> toFormData() {
    final relationCode = relation.isNotEmpty ? relation[0] : relation;
    final genderCode = gender.isNotEmpty ? gender[0] : gender;

    return {
      "name": name,
      "dateOfBirth": dateOfBirth,
      if (cnic != null && cnic!.isNotEmpty) "cnic": cnic,
      "relation": relationCode,
      "gender": genderCode,
    };
  }
}
