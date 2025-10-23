class UserClaimLimit {
  final int code;
  final UserLimitData data;
  final String? message;
  final dynamic errors;

  UserClaimLimit({
    required this.code,
    required this.data,
    required this.message,
    required this.errors,
  });

  factory UserClaimLimit.fromJson(Map<String, dynamic> json) {
    return UserClaimLimit(
      code: json['code'],
      data: UserLimitData.fromJson(json['data']),
      message: json['message'],
      errors: json['errors'],
    );
  }
}

class UserLimitData {
  final Map<String, String> limitTypes;
  final List<Limits> limits;
  final UsedLimits usedLimits;
  final String policyStartDate;
  final String policyEndDate;
  final String clientName;
  final List<OPDClaims> opdClaims;
  final List<IpdClaim> ipdClaims;

  UserLimitData({
    required this.limitTypes,
    required this.limits,
    required this.usedLimits,
    required this.policyStartDate,
    required this.policyEndDate,
    required this.clientName,
    required this.opdClaims,
    required this.ipdClaims,
  });

  factory UserLimitData.fromJson(Map<String, dynamic> json) {
    return UserLimitData(
      limitTypes: Map<String, String>.from(json['limitTypes'] ?? {}),
      limits:
          (json['limits'] as List?)
              ?.map((item) => Limits.fromJson(item))
              .toList() ??
          [],
      usedLimits: UsedLimits.fromJson(json['usedLimits'] ?? {}),
      policyStartDate: json['policyStartDate'] ?? '',
      policyEndDate: json['policyEndDate'] ?? '',
      clientName: json['clientName'] ?? '',
      opdClaims:
          (json['opdClaims'] as List?)
              ?.map((item) => OPDClaims.fromJson(item))
              .toList() ??
          [],
      ipdClaims:
          (json['ipdClaims'] as List?)
              ?.map((item) => IpdClaim.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class OPDClaims {
  final String bill_amount;
  final String approved;
  final String? deduction;
  final int clmseqnos;
  final String employee_no;
  final String cl_cicempno;
  final int colcode;
  final String reportdate;
  final String glvoucherno;
  final String lossdate;
  final String colname;

  OPDClaims({
    required this.bill_amount,
    required this.approved,
    this.deduction,
    required this.clmseqnos,
    required this.employee_no,
    required this.cl_cicempno,
    required this.colcode,
    required this.reportdate,
    required this.glvoucherno,
    required this.lossdate,
    required this.colname,
  });

  factory OPDClaims.fromJson(Map<String, dynamic> json) {
    return OPDClaims(
      bill_amount: json['bill_amount']?.toString() ?? '',
      approved: json['approved']?.toString() ?? '',
      deduction: json['deduction']?.toString(),
      clmseqnos: json['clmseqnos'] ?? 0,
      employee_no: json['employee_no']?.toString() ?? '',
      cl_cicempno: json['cl_cicempno']?.toString() ?? '',
      colcode: json['colcode'] ?? 0,
      reportdate: json['reportdate']?.toString() ?? '',
      glvoucherno: json['glvoucherno']?.toString() ?? '',
      lossdate: json['lossdate']?.toString() ?? '',
      colname: json['colname']?.toString() ?? '',
    );
  }
}

class IpdClaim {
  final String? billAmount;
  final String? approved;

  IpdClaim({this.billAmount, this.approved});

  factory IpdClaim.fromJson(Map<String, dynamic> json) {
    return IpdClaim(
      billAmount: json['bill_amount']?.toString() ?? '',
      approved: json['approved']?.toString() ?? '',
    );
  }
}

class Limits {
  final int serviceCode;
  final String serviceName;
  final String hospitalAllowCode;
  final int hospitalType;
  final String hospitalDescription;
  final int dateClaimPackageLimit1;
  final int polSeqNos;

  Limits({
    required this.serviceCode,
    required this.serviceName,
    required this.hospitalAllowCode,
    required this.hospitalType,
    required this.hospitalDescription,
    required this.dateClaimPackageLimit1,
    required this.polSeqNos,
  });

  factory Limits.fromJson(Map<String, dynamic> json) {
    return Limits(
      serviceCode: json['srvcode'] ?? 0,
      serviceName: json['servicename']?.toString() ?? '',
      hospitalAllowCode: json['hp_allowcode']?.toString() ?? '',
      hospitalType: json['hptype'] ?? 0,
      hospitalDescription: json['hpdesc']?.toString() ?? '',
      dateClaimPackageLimit1: json['dt_clpackagelimit1'] ?? 0,
      polSeqNos: json['polseqnos'] ?? 0,
    );
  }
}

class UsedLimits {
  final Map<String, dynamic> usedLimits;

  UsedLimits({required this.usedLimits});

  factory UsedLimits.fromJson(dynamic json) {
    // If json is a list, convert to an empty map
    if (json is List && json.isEmpty) {
      return UsedLimits(usedLimits: {});
    }
    
    // If json is a map, use it directly
    if (json is Map<String, dynamic>) {
      return UsedLimits(usedLimits: json);
    }
    
    // If json is null or unexpected type, return an empty map
    return UsedLimits(usedLimits: {});
  }
}
