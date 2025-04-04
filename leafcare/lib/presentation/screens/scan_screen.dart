import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafcare/presentation/bloc/scan/scan_bloc.dart';
import 'package:leafcare/presentation/bloc/scan/scan_event.dart';
import 'package:leafcare/presentation/bloc/scan/scan_state.dart';
import 'package:leafcare/presentation/screens/result_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanBloc(),
      child: const ScanScreenBody(),
    );
  }
}

class ScanScreenBody extends StatelessWidget {
  const ScanScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text("Scan", style: GoogleFonts.poppins(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<ScanBloc, ScanState>(
          listener: (context, state) {
            if (state is ScanCompletedState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    scanImage: state.scanImage,
                    prediction: state.prediction,
                    disease: state.disease,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            ScanBloc scanBloc = BlocProvider.of<ScanBloc>(context);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Capture Image Button
                GestureDetector(
                  onTap: () => scanBloc.add(PickImageEvent(ImageSource.camera)),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Capture Image",
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Upload from Gallery Button
                GestureDetector(
                  onTap: () => scanBloc.add(
                    PickImageEvent(ImageSource.gallery),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder,
                          size: 30,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Upload from Gallery",
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Image Preview Section
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: state is ImagePickedState
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(state.image.path),
                              fit: BoxFit.cover,
                            ),
                          )
                        : state is ScanningState
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 10),
                                  const Text("AI Scanning in progress..."),
                                ],
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image,
                                        size: 50, color: Colors.grey),
                                    SizedBox(height: 10),
                                    Text("No image selected"),
                                  ],
                                ),
                              ),
                  ),
                ),
                const SizedBox(height: 20),

                // Detect Disease Button
                GestureDetector(
                  onTap: state is ImagePickedState
                      ? () => scanBloc.add(DetectDiseaseEvent(state.image))
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          state is ScanningState
                              ? "Scanning..."
                              : "Detect Disease",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                // Show Scan Results
                if (state is ScanCompletedState)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      state.disease.name,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
