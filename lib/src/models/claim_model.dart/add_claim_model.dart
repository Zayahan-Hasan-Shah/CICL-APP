import 'dart:io';

class ClaimItem {
  final String billNo;
  final String billDate;
  final String employeeNo;
  final String serviceCode;
  final String billAmount;
  final String hospital;
  final String admitDate;
  final String dischargeDate;
  final List<Attachment> attachments;

  ClaimItem({
    required this.billNo,
    required this.billDate,
    required this.employeeNo,
    required this.serviceCode,
    required this.billAmount,
    required this.hospital,
    required this.admitDate,
    required this.dischargeDate,
    required this.attachments,
  });

  Map<String, String> toFormData(int index) {
    return {
      "ClaimItems[$index][billNo]": billNo,
      "ClaimItems[$index][billDate]": billDate,
      "ClaimItems[$index][employeeNo]": employeeNo,
      "ClaimItems[$index][serviceCode]": serviceCode,
      "ClaimItems[$index][billAmount]": billAmount,
      "ClaimItems[$index][hospital]": hospital,
      "ClaimItems[$index][admitDate]": admitDate,
      "ClaimItems[$index][dischargeDate]": dischargeDate,
    };
  }
}

class AddClaimModel {
  final List<ClaimItem> items;

  AddClaimModel({required this.items});
}

class Attachment {
  final File file;

  Attachment(this.file);
}
