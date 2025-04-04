import 'dart:typed_data';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class StorageRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  ///    **Upload Profile Image to Supabase**
  Future<String?> uploadProfileImage(String userId, String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        Uint8List imageBytes = response.bodyBytes;
        String filePath = "$userId.jpg";

        // Upload image to Supabase Storage
        await _supabase.storage.from("profileimages").uploadBinary(
              filePath,
              imageBytes,
              fileOptions: const FileOptions(contentType: "image/jpeg"),
            );

        // Return the public URL of the uploaded image
        return _supabase.storage.from("profileimages").getPublicUrl(filePath);
      } else {
        print("Error downloading image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Profile Image Upload Error: $e");
      return null;
    }
  }

  ///    **Update Profile Image**
  Future<String?> updateProfileImage(String userId, File imageFile) async {
    try {
      await deleteProfileImage(userId);
      String filePath = "$userId.jpg";
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Upload image to Supabase Storage (overwrite existing)
      await _supabase.storage.from("profileimages").uploadBinary(
            filePath,
            imageBytes,
            fileOptions:
                const FileOptions(contentType: "image/jpeg", upsert: true),
          );

      // Return the new public URL of the uploaded image
      print("   Profile image updated successfully!");
      return _supabase.storage.from("profileimages").getPublicUrl(filePath);
    } catch (e) {
      print("    Profile Image Update Error: $e");
      return null;
    }
  }

  ///    **Delete Profile Image**
  Future<void> deleteProfileImage(String userId) async {
    try {
      String filePath = "profileimages/$userId.jpg";
      await _supabase.storage.from("profileimages").remove([filePath]);
      print("   Profile image deleted successfully!");
    } catch (e) {
      print("    Error deleting profile image: $e");
    }
  }

  // ============================== //
  //        Scan Image Methods      //
  // ============================== //

  ///    **Upload Scanned Image**
  Future<String?> uploadScanImage(String userId, File imageFile) async {
    try {
      String filePath = "$userId-${DateTime.now().millisecondsSinceEpoch}.jpg";
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Upload image to Supabase Storage
      await _supabase.storage.from("scanimages").uploadBinary(
            filePath,
            imageBytes,
            fileOptions: const FileOptions(contentType: "image/jpeg"),
          );

      // Return the public URL of the uploaded image
      return _supabase.storage.from("scanimages").getPublicUrl(filePath);
    } catch (e) {
      print("    Scan Image Upload Error: $e");
      return null;
    }
  }

  ///    **Delete Scan Image**
  Future<void> deleteScanImage(String imagePath) async {
    try {
      await _supabase.storage.from("scanimages").remove([imagePath]);
      print("   Scan image deleted successfully!");
    } catch (e) {
      print("    Error deleting scan image: $e");
    }
  }
}
