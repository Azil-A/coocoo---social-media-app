import 'dart:io';
import 'dart:typed_data';
import 'package:coocoo/features/storage/domain/storage_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Mobile platform
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  // Web platform
  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  Future<String?> _uploadFile(String path, String fileName, String folder) async {
    try {
      // Get file
      final file = File(path); // Corrected to create a File object

      // Find place to store
      final storageRef = storage.ref().child('$folder/$fileName');


      // Upload
      final uploadTask = await storageRef.putFile(file);

      // Get image download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  // Web platforms (bytes)
  Future<String?> _uploadFileBytes(Uint8List fileBytes, String fileName, String folder) async {
    try {
      // Find place to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // Upload
      final uploadTask = await storageRef.putData(fileBytes);

      // Get image download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName,'post_images');
  }
}