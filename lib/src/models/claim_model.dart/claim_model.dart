class Claim {
  final int srvcode;
  final String clmseqnos;
  final String cuserid;
  final String reportdate;
  final int billamount;
  final int deductamount;
  final int approvamt;

  Claim(
      {required this.srvcode,
      required this.clmseqnos,
      required this.cuserid,
      required this.reportdate,
      required this.billamount,
      required this.deductamount,
      required this.approvamt});

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      srvcode: json['srvcode'] ?? 0,
      clmseqnos: json["clmseqnos"] ?? '',
      cuserid: json["cuserid"] ?? '',
      reportdate: json["reportdate"] ?? '',
      billamount: json["billamount"] ?? 0,
      deductamount: json["deductamount"] ?? 0,
      approvamt: json["approvamt"] ?? 0,
    );
  }
}
