import 'dart:io';

class AddFamilyModel {
  final String name;
  final String dateOfBirth;
  final String? cnic;
  final String relation;
  final String gender;
  final File attachments;

  AddFamilyModel(
      {required this.name,
      required this.dateOfBirth,
      this.cnic,
      required this.relation,
      required this.gender,
      required this.attachments});

  Map<String, dynamic> toFormData() {
    return {
      "name": name,
      "dateOfBirth": dateOfBirth,
      if (cnic != null && cnic!.isNotEmpty) "cnic": cnic,
      "relation": relation,
      "gender": gender,
    };
  }
}
