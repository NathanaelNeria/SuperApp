// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mrtd_combined_recognizer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MrtdCombinedRecognizer _$MrtdCombinedRecognizerFromJson(
        Map<String, dynamic> json) =>
    MrtdCombinedRecognizer()
      ..recognizerType = json['recognizerType'] as String?
      ..allowSpecialCharacters = json['allowSpecialCharacters'] as bool?
      ..allowUnparsedResults = json['allowUnparsedResults'] as bool?
      ..allowUnverifiedResults = json['allowUnverifiedResults'] as bool?
      ..detectorType = $enumDecodeNullable(
          _$DocumentFaceDetectorTypeEnumMap, json['detectorType'])
      ..faceImageDpi = json['faceImageDpi'] as int?
      ..fullDocumentImageDpi = json['fullDocumentImageDpi'] as int?
      ..fullDocumentImageExtensionFactors =
          json['fullDocumentImageExtensionFactors'] == null
              ? null
              : ImageExtensionFactors.fromJson(
                  json['fullDocumentImageExtensionFactors']
                      as Map<String, dynamic>)
      ..numStableDetectionsThreshold =
          json['numStableDetectionsThreshold'] as int?
      ..returnFaceImage = json['returnFaceImage'] as bool?
      ..returnFullDocumentImage = json['returnFullDocumentImage'] as bool?
      ..signResult = json['signResult'] as bool?;

Map<String, dynamic> _$MrtdCombinedRecognizerToJson(
        MrtdCombinedRecognizer instance) =>
    <String, dynamic>{
      'recognizerType': instance.recognizerType,
      'allowSpecialCharacters': instance.allowSpecialCharacters,
      'allowUnparsedResults': instance.allowUnparsedResults,
      'allowUnverifiedResults': instance.allowUnverifiedResults,
      'detectorType': _$DocumentFaceDetectorTypeEnumMap[instance.detectorType],
      'faceImageDpi': instance.faceImageDpi,
      'fullDocumentImageDpi': instance.fullDocumentImageDpi,
      'fullDocumentImageExtensionFactors':
          instance.fullDocumentImageExtensionFactors,
      'numStableDetectionsThreshold': instance.numStableDetectionsThreshold,
      'returnFaceImage': instance.returnFaceImage,
      'returnFullDocumentImage': instance.returnFullDocumentImage,
      'signResult': instance.signResult,
    };

const _$DocumentFaceDetectorTypeEnumMap = {
  DocumentFaceDetectorType.TD1: 'TD1',
  DocumentFaceDetectorType.TD2: 'TD2',
  DocumentFaceDetectorType.PassportsAndVisas: 'PassportsAndVisas',
};
