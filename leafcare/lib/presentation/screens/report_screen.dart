import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/core/utils/icons_preventions.dart';
import 'package:leafcare/data/models/disease_model.dart';
import 'package:leafcare/data/models/leaf_model.dart';
import 'package:leafcare/data/models/prediction_model.dart';

class ReportScreen extends StatelessWidget {
  final Disease disease;
  final PredictionModel prediction;
  final LeafModel scanImage;

  const ReportScreen({
    super.key,
    required this.disease,
    required this.prediction,
    required this.scanImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Disease Report"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Implement bookmark functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 **Disease Image**
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    scanImage.imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/images/leafcare.jpg");
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Scanned on ${prediction.predictedAt.split(' ')[0]}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🟢 **Report Summary**
            _buildSectionTitle("Report Summary"),
            _buildInfoRow("Condition", disease.category),
            _buildInfoRow("Severity", disease.severity,
                chipColor: _getSeverityColor(disease.severity),
                textColor: _getSeverityTextColor(disease.severity)),
            _buildInfoRow("Confidence", "${prediction.confidence.toStringAsFixed(2)}%",
                chipColor: Colors.green.withOpacity(0.2),
                textColor: Colors.green),

            const SizedBox(height: 16),

            // 🟢 **Detailed Information**
            _buildSectionTitle("Detailed Information"),
            Text(
              disease.description,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            ),

            const SizedBox(height: 16),

            // 🟢 **Recommended Treatment**
            _buildSectionTitle("Recommended Treatment"),
            ...disease.recommendedTreatment.map((treatment) =>
                _buildBulletPoint(treatment)),

            const SizedBox(height: 16),

            // 🟢 **Prevention Methods**
            _buildSectionTitle("Prevention Methods"),
            ...disease.preventionMethods.map((prevention) {
              final iconData = IconsPreventions.getIconForPreventionMethod(prevention);
              return _buildPreventionCard(
                title: prevention,
                description: "Recommended action to prevent the disease.",
                icon: iconData["icon"],
                color: iconData["color"],
              );
            }),

            const SizedBox(height: 20),

            // 🟢 **Export & Share Buttons**
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Implement export PDF functionality
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text("Export as PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Implement share functionality
                    },
                    icon: const Icon(Icons.share, color: Colors.grey),
                    label: const Text("Share Report"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 **Section Title Widget**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // 🔹 **Information Row Widget**
  Widget _buildInfoRow(String label, String value,
      {Color chipColor = Colors.grey, Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800])),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: chipColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                  color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 **Bullet Point Widget**
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.black54),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 **Prevention Card Widget**
  Widget _buildPreventionCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(description,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
      ),
    );
  }

  // 🔹 **Severity Color Helper**
  Color _getSeverityColor(String severity) {
    switch (severity) {
      case "Severe":
        return Colors.red.withOpacity(0.2);
      case "Moderate":
        return Colors.orange.withOpacity(0.2);
      case "Mild":
        return Colors.green.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  // 🔹 **Severity Text Color**
  Color _getSeverityTextColor(String severity) {
    switch (severity) {
      case "Severe":
        return Colors.red;
      case "Moderate":
        return Colors.orange;
      case "Mild":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
