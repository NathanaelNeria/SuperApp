import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class PhotoCompressor {
  Future<File> compressor1(File photo) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/LivenessCompressed';
    await Directory(dirPath).create(recursive: true);
    final filePath = photo.absolute.path;
    final outPath = '$dirPath/1.jpg';

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath, quality: 35);

    return null;
  }

  Future<File> compressor2(File photo) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/LivenessCompressed';
    final filePath = photo.absolute.path;
    final outPath = '$dirPath/2.jpg';

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath, quality: 35);

    return null;
  }

  Future<File>compressor3(File photo) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/LivenessCompressed';
    final filePath = photo.absolute.path;
    final outPath = '$dirPath/3.jpg';

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath, quality: 35);

    return null;
  }

  Future<File>compressor4(File photo) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/LivenessCompressed';
    final filePath = photo.absolute.path;
    final outPath = '$dirPath/4.jpg';

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath, quality: 35);

    return null;
  }

  Future<File>compressor5(File photo) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/LivenessCompressed';
    final filePath = photo.absolute.path;
    final outPath = '$dirPath/5.jpg';

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath, quality: 35);

    return null;
  }

  Future<File> compressor6(File photo) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/LivenessCompressed';
    final filePath = photo.absolute.path;
    final outPath = '$dirPath/6.jpg';

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath, quality: 35);

    return null;
  }

  Future<File> compressor7(File photo) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/LivenessCompressed';
    final filePath = photo.absolute.path;
    final outPath = '$dirPath/7.jpg';

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath, quality: 35);

    return null;
  }

  Future<File> compressor8(File photo) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/LivenessCompressed';
    final filePath = photo.absolute.path;
    final outPath = '$dirPath/8.jpg';

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath, quality: 35);

    return null;
  }
}