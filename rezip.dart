import 'dart:io';

void unzipAndRezip(String filePath) {
  final originalFile = File(filePath);
  final originalFileName = originalFile.path.split('/').last;

  // Create a directory to extract the files
  final extractionPath =
      Directory('${originalFile.parent.path}/$originalFileName');
  extractionPath.createSync();

  // Unzip the original file
  Process.runSync(
      'unzip', ['-q', '-d', extractionPath.path, originalFile.path]);

  // Remove the original file
  originalFile.deleteSync();

  // Re-zip the extracted files
  final extractedFiles = extractionPath.listSync(recursive: true);
  final rezipFilePath = '${extractionPath.parent.path}/$originalFileName';
  Process.runSync('zip', ['-q', '-r', rezipFilePath, '.'],
      workingDirectory: extractionPath.path);

  // Remove the extracted files directory
  extractionPath.deleteSync(recursive: true);
}

void main() {
  final filePath = 'path/to/your/archive.zip';
  unzipAndRezip(filePath);
}
