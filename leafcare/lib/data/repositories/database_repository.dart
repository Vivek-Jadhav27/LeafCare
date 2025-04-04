import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:leafcare/data/models/disease_model.dart';
import 'package:leafcare/data/models/history_model.dart';
import 'package:leafcare/data/models/user_model.dart';
import 'package:leafcare/data/models/leaf_model.dart';
import 'package:leafcare/data/models/prediction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class DatabaseRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ============================== //
  //        USER METHODS            //
  // ============================== //

  ///     **Get User by ID**
  Future<UserModel?> getUserById(String userId) async {
    try {
      final response =
          await _supabase.from('users').select().eq('id', userId).single();
      return UserModel.fromMap(response);
    } catch (e) {
      print("    Error fetching user: $e");
      return null;
    }
  }

  ///     **Save or Update User Data**
  Future<void> saveUserData(UserModel user) async {
    try {
      await _supabase.from('users').upsert(user.toMap());
      print("    User data saved successfully!");
    } catch (e) {
      print("    Error saving user: $e");
    }
  }

  ///     **Update User Profile Picture**
  Future<void> updateUserProfilePicture(String id, String imageUrl) async {
    try {
      await _supabase
          .from('users')
          .update({'profile_image': imageUrl}).eq('id', id);
      print("    Profile picture updated successfully!");
    } catch (e) {
      if (kDebugMode) {
        print("    Error updating user profile picture: $e");
      }
    }
  }

  ///     **Fetch All Users**
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _supabase.from('users').select();

      return response
          .map<UserModel>((data) => UserModel.fromMap(data))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("    Error fetching users: $e");
      }
      return [];
    }
  }

  // ============================== //
  //        SCANNED IMAGES          //
  // ============================== //

  ///     **Save Scan Image**
  Future<void> saveScanImage(LeafModel scanImage) async {
    try {
      await _supabase.from('leaf_scans').insert(scanImage.toMap());
      print("    Scan image saved successfully!");
    } catch (e) {
      print("    Error saving scan image: $e");
    }
  }

  ///     **Fetch Scan Images by User ID**
  Future<List<LeafModel>> getScanImagesByUser(String userId) async {
    try {
      final response =
          await _supabase.from('leaf_scans').select().eq('user_id', userId);

      return response
          .map<LeafModel>((data) => LeafModel.fromJson(data))
          .toList();
    } catch (e) {
      print("    Error fetching scan images: $e");
      return [];
    }
  }

  ///     **Delete Scan Image**
  Future<void> deleteScanImage(String id) async {
    try {
      await _supabase.from('leaf_scans').delete().eq('id', id);
      print("    Scan image deleted successfully!");
    } catch (e) {
      print("    Error deleting scan image: $e");
    }
  }
  // ============================== //
  //      Disease History           //
  // ============================== //

  ///     **Save Disease Data**

  Future<void> saveDisease(Disease disease) async {
    try {
      await _supabase.from('diseases').insert(disease.toJson());
      print("    Disease saved successfully!");
    } catch (e) {
      print("    Error saving disease: $e");
    }
  }

  /// get all Disease
  Future<List<Disease>> getAllDiseases() async {
    try {
      final response = await _supabase.from('diseases').select();

      return response.map<Disease>((data) => Disease.fromJson(data)).toList();
    } catch (e) {
      print("    Error fetching diseases: $e");
      return [];
    }
  }

  ///     **Check if Disease Exists in `diseases` Table**
  Future<Disease?> getDiseaseByName(String diseaseName) async {
    try {
      print(" Checking if disease '$diseaseName' exists in database...");
      final response = await _supabase
          .from('diseases')
          .select()
          .eq('disease_name', diseaseName)
          .maybeSingle();

      if (response == null) {
        print("    Disease '$diseaseName' not found in database.");
        return null;
      }

      print("    Disease '$diseaseName' found in database.");
      return Disease.fromJson(response);
    } catch (e) {
      print("    Error fetching disease '$diseaseName': $e");
      return null;
    }
  }

  ///     **Insert Disease from JSON into `diseases` Table**
  Future<Disease?> insertDiseaseFromJson(
      String diseaseName, String imageUrl) async {
    try {
      print(" Loading disease details from JSON for '$diseaseName'...");
      final disease = await loadDiseaseFromJson(diseaseName, imageUrl);

      if (disease != null) {
        print("    Disease data found in JSON. Inserting into Supabase...");
        await _supabase.from('diseases').insert(disease.toJson());
        print("    Disease '$diseaseName' inserted into database.");
      } else {
        print("    Disease '$diseaseName' not found in JSON.");
      }
      return disease;
    } catch (e) {
      print("    Error inserting disease '$diseaseName': $e");
      return null;
    }
  }

  ///     **Fetch Disease Details from JSON**
  Future<Disease?> loadDiseaseFromJson(
      String diseaseName, String imageUrl) async {
    try {
      print(" Reading JSON file...");
      final String jsonString =
          await rootBundle.loadString('assets/json/disease_info.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      if (jsonData.containsKey('diseases')) {
        print("    JSON file loaded successfully.");
        final List<Disease> diseases = (jsonData['diseases'] as List)
            .map((data) => Disease.fromJson(data))
            .toList();

        final disease = diseases.firstWhere(
          (disease) => disease.name == diseaseName,
          orElse: () {
            print(
                " Disease '$diseaseName' not found in JSON, returning default values.");
            return Disease(
              id: Uuid().v4(),
              name: diseaseName,
              category: "Unknown",
              description: "No details available.",
              severity: "Unknown",
              recommendedTreatment: [],
              preventionMethods: [],
              imageUrl: "",
            );
          },
        );

        disease.id = Uuid().v4();
        disease.imageUrl = imageUrl;

        print("    Disease '$diseaseName' loaded from JSON.");
        return disease;
      } else {
        print("    No 'diseases' key found in JSON.");
      }
    } catch (e) {
      print("    Error loading disease '$diseaseName' from JSON: $e");
    }
    return null;
  }
  // ============================== //
  //      PREDICTIONS HISTORY       //
  // ============================== //

  ///     **Save Prediction Data**
  Future<void> savePrediction(PredictionModel prediction) async {
    try {
      await _supabase.from('predictions').insert(prediction.toMap());
      print("    Prediction saved successfully!");
    } catch (e) {
      print("    Error saving prediction: $e");
    }
  }

  ///     **Fetch Predictions by User ID**
  Future<List<PredictionModel>> getPredictionsByUser(String userId) async {
    try {
      final response =
          await _supabase.from('predictions').select().eq('user_id', userId);

      return response
          .map<PredictionModel>((data) => PredictionModel.fromJson(data))
          .toList();
    } catch (e) {
      print("    Error fetching predictions: $e");
      return [];
    }
  }

  ///     **Delete Prediction**
  Future<void> deletePrediction(String id) async {
    try {
      await _supabase.from('predictions').delete().eq('id', id);
      print("    Prediction deleted successfully!");
    } catch (e) {
      print("    Error deleting prediction: $e");
    }
  }

  // ============================== //
  //         Scan History           //
  // ============================== //

  Future<List<ScanHistory>> getScanHistory(String userId) async {
    List<ScanHistory> scanHistory = [];

    try {
      //     Fetch all predictions for the user
      List<PredictionModel> predictions = await getPredictionsByUser(userId);

      for (PredictionModel prediction in predictions) {
        //     Fetch Disease details
        Disease? disease = await getDiseaseById(prediction.diseaseId);
        if (disease == null) {
          print(
              " Disease ID '${prediction.diseaseId}' not found. Using placeholder.");
          disease = Disease(
            id: prediction
                .diseaseId, // Use original ID instead of a random UUID
            name: "Unknown Disease",
            category: "Unknown",
            description: "No details available.",
            severity: "Unknown",
            recommendedTreatment: [],
            preventionMethods: [],
            imageUrl: "",
          );
        }

        //     Fetch Scan Image details
        LeafModel? scanImage = await getScanImageById(prediction.imageId);
        if (scanImage == null) {
          print(
              " Image ID '${prediction.imageId}' not found. Using placeholder.");
          scanImage = LeafModel(
            id: prediction.imageId, // Use original ID instead of generating new
            imageUrl: "",
            userId: userId,
            uploadedAt: DateTime.now().toString(),
          );
        }

        //     Create ScanHistory object
        ScanHistory scan = ScanHistory(
          id: prediction
              .id, // Use prediction ID instead of generating a new one
          predictedAt: prediction.predictedAt,
          confidence: double.parse(prediction.confidence
              .toStringAsFixed(2)), // Ensure 2 decimal places
          imageUrl: scanImage.imageUrl,
          diseaseName: disease.name,
          category: disease.category,
          description: disease.description,
          severity: disease.severity,
          recommendedTreatment: disease.recommendedTreatment,
          preventionMethods: disease.preventionMethods,
        );

        scanHistory.add(scan);
      }

      return scanHistory;
    } catch (e) {
      print("    Error fetching scan history: $e");
      return [];
    }
  }

  Future<Disease?> getDiseaseById(String diseaseId) async {
    try {
      final response = await _supabase
          .from('diseases')
          .select()
          .eq('id', diseaseId)
          .maybeSingle(); // Ensures it doesn't throw an error if no match

      if (response == null) {
        print(" No disease found with ID: $diseaseId");
        return null;
      }

      return Disease.fromJson(response);
    } catch (e) {
      print("    Error fetching disease: $e");
      return null; // Return null on error
    }
  }

  Future<LeafModel?> getScanImageById(String scanImageId) async {
    try {
      final response = await _supabase
          .from('leaf_scans')
          .select()
          .eq('id', scanImageId)
          .maybeSingle(); // Ensures it doesn't throw an error if no match

      if (response == null) {
        print(" No scan image found with ID: $scanImageId");
        return null;
      }

      return LeafModel.fromJson(response);
    } catch (e) {
      print("    Error fetching scan image: $e");
      return null; // Return null on error
    }
  }
}
