import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/data/models/disease_model.dart';
import 'package:leafcare/data/models/leaf_model.dart';
import 'package:leafcare/data/models/prediction_model.dart';
import 'package:leafcare/presentation/screens/report_screen.dart';

class ResultScreen extends StatefulWidget {
  final Disease disease;
  final PredictionModel prediction;
  final LeafModel scanImage;

  const ResultScreen({
    super.key,
    required this.disease,
    required this.prediction,
    required this.scanImage,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Scan Results",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disease Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.scanImage.imageUrl.isNotEmpty
                      ? widget.scanImage.imageUrl
                      : "assets/images/leafcare.jpg",
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset("assets/images/leafcare.jpg");
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Disease Name
              Text(
                widget.disease.name,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              // Detection Date
              Text(
                "Detected on ${DateTime.now().toLocal().toString().split(' ')[0]}",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              // Confidence Score
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Confidence Score",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                      )),
                  Text(
                      "${widget.prediction.confidence.toStringAsFixed(2)}%", // Keep 2 decimal places
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                ],
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: widget.prediction.confidence /
                    100, // Convert percentage to 0-1 range
                backgroundColor: Colors.grey[300],
                color: Colors.green,
                minHeight: 8,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 20),

              // Disease Description
              Text(
                "Description",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                widget.disease.description,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 20),

              // Recommended Treatment
              Text(
                "Recommended Treatment",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.disease.recommendedTreatment
                    .map((t) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(t,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black, fontSize: 14)),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),

              // Buttons: Save Report & Share Report
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportScreen(
                              disease: widget.disease,
                              prediction: widget.prediction,
                              scanImage: widget.scanImage,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: Text(
                        "Save Report",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share, color: Colors.green),
                      label: const Text("Share Report"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
