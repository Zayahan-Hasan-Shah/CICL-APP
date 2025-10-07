class AddFamilyResponseModel<T> {
  final int code;
  final T? data;
  final String? message;
  final dynamic errors;

  AddFamilyResponseModel(
      {required this.code, this.data, this.message, this.errors});

  factory AddFamilyResponseModel.fromJson(Map<String, dynamic> json,
      {T Function(dynamic)? fromJsonT}) {
    return AddFamilyResponseModel(
      code: json["code"] ?? 0,
      data: fromJsonT != null && json["data"] != null
          ? fromJsonT(json["data"])
          : null,
      message: json["message"],
      errors: json["errors"],
    );
  }
}
