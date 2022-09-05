// To parse this JSON data, do
//
//     final errorPodo = errorPodoFromJson(jsonString);

import 'dart:convert';

ErrorPodo errorPodoFromJson(String str) => ErrorPodo.fromJson(json.decode(str));

String errorPodoToJson(ErrorPodo data) => json.encode(data.toJson());

class ErrorPodo {
    String? error;
    String? response;

    ErrorPodo({
        this.error,
        this.response,
    });

    factory ErrorPodo.fromJson(Map<String, dynamic> json) => ErrorPodo(
        error: json["error"],
        response: json["response"],
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "response": response,
    };
}


// To parse this JSON data, do
//
//     final errorString = errorStringFromJson(jsonString);



ErrorString errorStringFromJson(String str) => ErrorString.fromJson(json.decode(str));

String errorStringToJson(ErrorString data) => json.encode(data.toJson());

class ErrorString {
    int? longErrorCode;
    int? shortErrorCode;
    String? errorString;

    ErrorString({
        this.longErrorCode,
        this.shortErrorCode,
        this.errorString,
    });

    factory ErrorString.fromJson(Map<String, dynamic> json) => ErrorString(
        longErrorCode: json["longErrorCode"],
        shortErrorCode: json["shortErrorCode"],
        errorString: json["errorString"],
    );

    Map<String, dynamic> toJson() => {
        "longErrorCode": longErrorCode,
        "shortErrorCode": shortErrorCode,
        "errorString": errorString,
    };
}
