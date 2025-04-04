import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/data/datasources/database_helper.dart';
// import 'package:leafcare/core/constants.dart';
import 'package:leafcare/data/models/disease_model.dart';

class DiseaseLibraryScreen extends StatefulWidget {
  const DiseaseLibraryScreen({super.key});

  @override
  State<DiseaseLibraryScreen> createState() => _DiseaseLibraryScreenState();
}

class _DiseaseLibraryScreenState extends State<DiseaseLibraryScreen> {
  String selectedCategory = "All Diseases";
  List<Disease> diseases = [];
  List<Disease> filteredDiseases = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final List<String> categories = [
    "All Diseases",
    "Bacterial",
    "Fungal",
    "Viral"
  ];

  @override
  void initState() {
    super.initState();
    loadDiseases();
  }

  /// ✅ **Load Diseases from Database (First Time from JSON, Later from SQLite)**
  Future<void> loadDiseases() async {
    await _dbHelper.loadDataFromJson(); // Load JSON data first time only
    final dbDiseases = await _dbHelper.getDiseases(); // Fetch from database

    setState(() {
      diseases = dbDiseases;
      filteredDiseases = diseases;
    });
  }

  // Filter diseases based on category
  void filterDiseases() {
    setState(() {
      filteredDiseases = selectedCategory == "All Diseases"
          ? diseases
          : diseases
              .where((disease) => disease.category == selectedCategory)
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Leaf Diseases"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disease Category Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  bool isSelected = selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        filterDiseases();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 15),

            // Disease List
            Expanded(
              child: diseases.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredDiseases.length,
                      itemBuilder: (context, index) {
                        var disease = filteredDiseases[index];
                        return _buildDiseaseCard(disease);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(Disease disease) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.white,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              disease.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                    "assets/images/leafcare.jpg"); // Fallback image
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disease.name,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  disease.description,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildChip(disease.category, Colors.blue),
                    const SizedBox(width: 6),
                    _buildChip(
                        disease.severity, _getSeverityColor(disease.severity)),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case "Severe":
        return Colors.red;
      case "High":
        return Colors.orange;
      case "Moderate":
        return Colors.amber;
      default:
        return Colors.green;
    }
  }
}
