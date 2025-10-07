class ClaimDetailResponse {
  final int code;
  final String? message;
  final List<ClaimDetail>? data;

  ClaimDetailResponse({required this.code, this.message, this.data});

  factory ClaimDetailResponse.fromJson(Map<String, dynamic> json) {
    return ClaimDetailResponse(
      code: json['code'] ?? 0,
      message: json['message'],
      data: json['data'] != null
          ? List<ClaimDetail>.from(
              json['data'].map((x) => ClaimDetail.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data?.map((x) => x.toJson()).toList(),
  };
}

class ClaimDetail {
  final String billNumber;
  final String billDate;
  final String? admitDate;
  final String? dischargeDate;
  final String employeeNo;
  final int serviceCode;
  final String serviceName;
  final double approvedAmount;
  final double deductedAmount;
  final String patientName;
  final String patientCNIC;
  final String patientDOB;
  final String patientRelation;

  ClaimDetail({
    required this.billNumber,
    required this.billDate,
    this.admitDate,
    this.dischargeDate,
    required this.employeeNo,
    required this.serviceCode,
    required this.serviceName,
    required this.approvedAmount,
    required this.deductedAmount,
    required this.patientName,
    required this.patientCNIC,
    required this.patientDOB,
    required this.patientRelation,
  });

  factory ClaimDetail.fromJson(Map<String, dynamic> json) {
    return ClaimDetail(
      billNumber: json['billNumber'] ?? "",
      billDate: json['billDate'] ?? "",
      admitDate: json['admitdt'],
      dischargeDate: json['dischargdt'],
      employeeNo: json['employeeNo'] ?? "",
      serviceCode: json['serviceCode'] ?? 0,
      serviceName: json['serivceName'] ?? "", // note: typo in API key
      approvedAmount: (json['approvedAmount'] ?? 0).toDouble(),
      deductedAmount: (json['deductedAmount'] ?? 0).toDouble(),
      patientName: json['patientName'] ?? "",
      patientCNIC: json['patientCNIC'] ?? "",
      patientDOB: json['patientDOB'] ?? "",
      patientRelation: json['patientRelation'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "billNumber": billNumber,
    "billDate": billDate,
    "admitdt": admitDate,
    "dischargdt": dischargeDate,
    "employeeNo": employeeNo,
    "serviceCode": serviceCode,
    "serivceName": serviceName,
    "approvedAmount": approvedAmount,
    "deductedAmount": deductedAmount,
    "patientName": patientName,
    "patientCNIC": patientCNIC,
    "patientDOB": patientDOB,
    "patientRelation": patientRelation,
  };
}
