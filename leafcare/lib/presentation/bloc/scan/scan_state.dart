import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafcare/data/models/disease_model.dart';
import 'package:leafcare/data/models/leaf_model.dart';
import 'package:leafcare/data/models/prediction_model.dart';

abstract class ScanState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Step 1: Initial State (No Image Selected)
class ScanInitial extends ScanState {}

// Step 2: Image Selected
class ImagePickedState extends ScanState {
  final XFile image;
  ImagePickedState(this.image);

  @override
  List<Object?> get props => [image];
}

// Step 3: Scanning In Progress
class ScanningState extends ScanState {}

// Step 4: Scan Completed
class ScanCompletedState extends ScanState {
  final Disease disease;
  final PredictionModel prediction;
  final LeafModel scanImage;
  ScanCompletedState({
    required this.disease,
    required this.prediction,
    required this.scanImage,
  });

  @override
  List<Object?> get props => [disease , prediction, scanImage];
}

// Step 5: Error State
class ScanErrorState extends ScanState {
  final String message;
  ScanErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
