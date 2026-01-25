class Claim {
  final int srvcode;
  final String clmseqnos;
  final String cuserid;
  final String reportdate;
  final int billamount;
  final int deductamount;
  final int approvamt;
  final String serviceName;

  Claim({
    required this.srvcode,
    required this.clmseqnos,
    required this.cuserid,
    required this.reportdate,
    required this.billamount,
    required this.deductamount,
    required this.approvamt,
    required this.serviceName,
  });

  factory Claim.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String && value.isNotEmpty) {
        return int.tryParse(value) ?? 0;
      }
      return 0;
    }

    return Claim(
      srvcode: json['srvcode'],
      clmseqnos: json["clmseqnos"] ?? '',
      cuserid: json["cuserid"] ?? '',
      reportdate: json["reportdate"] ?? '',
      billamount: toInt(json["billamount"]), // "1600" -> 1600
      deductamount: toInt(json["deductamt"]), // NOTE: key is deductamt
      approvamt: toInt(json["approvamt"]), // "1600" -> 1600
      serviceName: json["serviceName"] ?? '',
    );
  }
}
