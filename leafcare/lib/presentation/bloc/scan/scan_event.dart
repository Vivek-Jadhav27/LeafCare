import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ScanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Select Image Event
class PickImageEvent extends ScanEvent {
  final ImageSource source;
  PickImageEvent(this.source);

  @override
  List<Object?> get props => [source];
}

// Start Scanning
class DetectDiseaseEvent extends ScanEvent {
  final XFile image; // Use XFile instead of File
  DetectDiseaseEvent(this.image);

  @override
  List<Object?> get props => [image];
}
