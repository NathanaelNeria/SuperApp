// To parse this JSON data, do
//
//     final refreshToken = refreshTokenFromJson(jsonString);

import 'dart:convert';

RefreshToken refreshTokenFromJson(String str) => RefreshToken.fromJson(json.decode(str));

String refreshTokenToJson(RefreshToken data) => json.encode(data.toJson());

class RefreshToken {
  RefreshToken({
    this.refreshToken,
    this.accessToken,
    this.expiredAt,
    this.status,
    this.statusCode,
    this.statusMessage,
  });

  String? refreshToken;
  String? accessToken;
  int? expiredAt;
  String? status;
  int? statusCode;
  String? statusMessage;

  factory RefreshToken.fromJson(Map<String, dynamic> json) => RefreshToken(
    refreshToken: json["refresh_token"],
    accessToken: json["access_token"],
    expiredAt: json["expired_at"],
    status: json["status"],
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
  );

  Map<String, dynamic> toJson() => {
    "refresh_token": refreshToken,
    "access_token": accessToken,
    "expired_at": expiredAt,
    "status": status,
    "status_code": statusCode,
    "status_message": statusMessage,
  };
}
