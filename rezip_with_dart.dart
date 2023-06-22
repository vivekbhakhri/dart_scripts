import 'dart:io';

void main() {
  unzipDeleteRezip('./Warp.zip');
}

void unzipDeleteRezip(String zipFilePath) {
  final zipFile = File(zipFilePath);
  final directory = Directory(zipFile.parent.path);
  final originalFileName = zipFile.path.split('/').last;

  // Unzip the original file
  final extractionPath = Directory('${directory.path}/temp_extraction');
  extractionPath.createSync();

  Process.runSync('unzip', ['-q', '-d', extractionPath.path, zipFilePath]);

  // Delete the original zip
  zipFile.deleteSync();

  // Re-zip the extracted File
  // final extractedFiles = extractionPath.listSync(recursive: true);

  final insideFolderName = Directory('${directory.path}/temp_extraction');

  final extractedFiles = extractionPath.listSync(recursive: true);

  final rezipPath = '${directory.path}/$originalFileName';
  print(extractedFiles);

  // final currentDirectory = Directory.current.path;
  // Directory.current = Directory('temp_extraction');

  // final result = Process.runSync('zip', ['-r', 'Warp', './temp_extraction']);

  // Directory.current = Directory(currentDirectory);

  // working but not fully
  Process.runSync('zip', ['-r', originalFileName, './temp_extraction']);

  // Process.runSync('zip', [
  //   '-r',
  //   '$originalFileName',
  //   'j',
  //   rezipPath,
  //   ...extractedFiles.map((file) => file.path)
  // ]);

  // Process.runSync('zip',
  //     ['-r', originalFileName, ...extractedFiles.map((file) => file.path)]);

  // Delete rhw extracted files Directory
  extractionPath.deleteSync(recursive: true);
  print('done');
}
