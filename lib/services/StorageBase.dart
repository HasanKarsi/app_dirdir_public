import 'dart:io';

abstract class StorageBase {
  Future<void> uploadFile(String userId, String fileType, File file);
  Future<String?> downloadFile(String fileName);
  Future<void> deleteFile(String fileName);
}
