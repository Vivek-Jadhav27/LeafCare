import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://192.168.244.99:8000"; // Replace with your actual API base URL
  static const String _predictEndpoint = "/predict_api/";

  // Upload Image and Get Prediction
  static Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$_baseUrl$_predictEndpoint"),
      );

      // Attach image
      request.files.add(
        await http.MultipartFile.fromPath("image", imageFile.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // {"image_url": "...", "prediction": "...", "confidence": ...}
      } else {
        return {"error": "Failed to get prediction", "status": response.statusCode};
      }
    } catch (e) {
      return {"error": "Error: $e"};
    }
  }
}
