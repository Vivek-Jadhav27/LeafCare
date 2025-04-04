import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafcare/data/datasources/api_service.dart';
import 'package:leafcare/data/models/disease_model.dart';
import 'package:leafcare/data/models/leaf_model.dart';
import 'package:leafcare/data/models/prediction_model.dart';
import 'package:leafcare/data/repositories/auth_repository.dart';
import 'package:leafcare/data/repositories/database_repository.dart';
import 'package:leafcare/data/repositories/storage_repository.dart';
// import 'package:tflite_flutter/tflite_flutter.d  art';
// import 'dart:async';

import 'package:uuid/uuid.dart';
import 'scan_event.dart';
import 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ImagePicker _picker = ImagePicker();
  final AuthRepository _authRepository = AuthRepository();
  final StorageRepository _storageRepository = StorageRepository();
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  // late Interpreter interpreter;
  ScanBloc() : super(ScanInitial()) {
    // Image Selection
    on<PickImageEvent>((event, emit) async {
      try {
        final XFile? image = await _picker.pickImage(source: event.source);
        if (image != null) {
          emit(ImagePickedState(image)); // Keep it as XFile
        } else {
          emit(ScanErrorState("No image selected"));
        }
      } catch (e) {
        emit(ScanErrorState("Failed to pick image: $e"));
      }
    });

    // AI Scanning
    on<DetectDiseaseEvent>((event, emit) async {
      if (state is! ImagePickedState) return;
      final imageFile = File((state as ImagePickedState).image.path);

      emit(ScanningState());

      try {
        String userId =
            await _authRepository.getCurrentUser().then((user) => user!.id);

        // Upload image to Supabase Storage

        String? imageUrl =
            await _storageRepository.uploadScanImage(userId, imageFile);
        if (imageUrl == null) {
          emit(ScanErrorState("Failed to upload image"));
          return;
        }

        // Save scan image to Supabase Database
        LeafModel scanImage = LeafModel(
          id: Uuid().v4(),
          imageUrl: imageUrl,
          userId: userId,
          uploadedAt: DateTime.now().toString(),
        );

        await _databaseRepository.saveScanImage(scanImage);

        // Get Prediction

        Map<String, dynamic> prediction =
            await ApiService.uploadImage(imageFile);

        String diseaseName = prediction["prediction"];
        String confidence = prediction["confidence"].toString();

        print("Prediction: $diseaseName, Confidence: $confidence");
        // Fetch Disease Info from JSON

        Disease? disease =
            await _databaseRepository.getDiseaseByName(diseaseName);

        disease ??= await _databaseRepository.insertDiseaseFromJson(
            diseaseName, imageUrl);

        // Save Prediction

        PredictionModel predictionModel = PredictionModel(
          id: Uuid().v4(),
          confidence: double.parse(confidence),
          userId: userId,
          imageId: scanImage.id,
          diseaseId: disease!.id,
          predictedAt: DateTime.now().toString(),
        );

        await _databaseRepository.savePrediction(predictionModel);

        emit(
          ScanCompletedState(
              disease: disease,
              prediction: predictionModel,
              scanImage: scanImage),
        );
      } catch (e) {
        emit(ScanErrorState("Error during scanning: $e"));
      }
    });
  }
}
