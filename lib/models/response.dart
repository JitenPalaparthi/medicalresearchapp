class GeneralResponse {
  final String message;
  final String status;
  final String token;
  final int httpStatus;

  GeneralResponse({this.message, this.status, this.token, this.httpStatus});

  factory GeneralResponse.fromJson(Map<String, dynamic> json, int httpStatus) {
    return GeneralResponse(
      message: json['message'],
      status: json['status'],
      token: json['token'],
      httpStatus: httpStatus,
    );
  }
}
