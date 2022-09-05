
import 'package:logger/logger.dart';
import 'LogPrinter.dart';
import 'dart:convert';

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}

String getEncodedValue(dynamic res){
  return jsonEncode(res);
}