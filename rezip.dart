import 'dart:io';
import 'package:archive/archive.dart';

void unzipAndRezip(String filePath) {
  final originalFile = File(filePath);
  final originalFileName = originalFile.path.split('/').last;

  // Create a directory to extract the files
  final extractionPath =
      Directory('${originalFile.parent.path}/$originalFileName-extracted');
  extractionPath.createSync();

  // Unzip the original file
  final zipFile = ZipDecoder().decodeBytes(originalFile.readAsBytesSync());
  for (final file in zipFile) {
    final extractedPath = '${extractionPath.path}/${file.name}';
    if (file.isFile) {
      final data = file.content as List<int>;
      File(extractedPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    } else {
      Directory(extractedPath)..createSync(recursive: true);
    }
  }

  // Remove the original file
  originalFile.deleteSync();

  // Re-zip the extracted files with compression
  final rezipFilePath = '${originalFile.parent.path}/$originalFileName';
  final encoder = ZipEncoder();
  final rezipArchive = Archive();

  for (final entity in extractionPath.listSync(recursive: true)) {
    if (entity is File) {
      final filePath = entity.path.substring(extractionPath.path.length + 1);
      final fileData = entity.readAsBytesSync();
      rezipArchive.addFile(ArchiveFile(filePath, fileData.length, fileData));
    }
  }

  final rezipBytes = encoder.encode(rezipArchive);
  File(rezipFilePath).writeAsBytesSync(rezipBytes!);

  // Remove the extracted files directory
  extractionPath.deleteSync(recursive: true);
}

void main() {
  final filePath = 'Warp.zip';
  unzipAndRezip(filePath);
}
