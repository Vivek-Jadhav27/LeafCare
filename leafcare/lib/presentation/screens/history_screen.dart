import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:leafcare/data/models/history_model.dart';
import 'package:leafcare/data/repositories/auth_repository.dart';
import 'package:leafcare/presentation/bloc/history/history_bloc.dart';
import 'package:leafcare/presentation/bloc/history/history_even.dart';
import 'package:leafcare/presentation/bloc/history/history_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final historyBloc = BlocProvider.of<HistoryBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Scan History"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: authRepository.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User not found."));
          }

          final user = snapshot.data!;
          historyBloc.add(LoadHistory(user.id));

          return BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is HistoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HistoryError) {
                return Center(child: Text(state.message));
              }
              if (state is HistoryLoaded && state.history.isEmpty) {
                return const Center(child: Text("No scan history found."));
              }
              if (state is HistoryLoaded) {
                final groupedHistory = _groupHistoryByDate(state.history);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    children: groupedHistory.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              entry.key, // "Today", "Yesterday", "Previous"
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          ...entry.value.map((scan) => _buildScanCard(scan)),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }
              return const Center(child: Text("Unexpected error."));
            },
          );
        },
      ),
    );
  }

  /// ✅ **Group History by "Today", "Yesterday", and "Previous" & Sort in LIFO Order**
  Map<String, List<ScanHistory>> _groupHistoryByDate(
      List<ScanHistory> history) {
    Map<String, List<ScanHistory>> groupedHistory = {
      "Today": [],
      "Yesterday": [],
      "Previous": [],
    };

    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);
    String yesterday =
        DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));

    for (var scan in history) {
      String scanDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(scan.predictedAt));

      if (scanDate == today) {
        groupedHistory["Today"]!.add(scan);
      } else if (scanDate == yesterday) {
        groupedHistory["Yesterday"]!.add(scan);
      } else {
        groupedHistory["Previous"]!.add(scan);
      }
    }

    // **Sort scans in descending order (LIFO)**
    groupedHistory.forEach((key, value) {
      value.sort((a, b) => DateTime.parse(b.predictedAt)
          .compareTo(DateTime.parse(a.predictedAt)));
    });

    // Remove empty groups
    groupedHistory.removeWhere((key, value) => value.isEmpty);

    return groupedHistory;
  }

  /// ✅ **Build Individual Scan Card**
  Widget _buildScanCard(ScanHistory scan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(scan.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
            return Image.asset("assets/images/leafcare.jpg");
          }),
        ),
        title: Text(
          scan.diseaseName,
          style: GoogleFonts.poppins(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          scan.predictedAt,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: _buildSeverityChip(scan.severity),
      ),
    );
  }

  /// ✅ **Build Severity Chip**
  Widget _buildSeverityChip(String severity) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: _getSeverityColor(severity),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        severity,
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// ✅ **Get Severity Color**
  Color _getSeverityColor(String severity) {
    switch (severity) {
      case "Severe":
        return Colors.red;
      case "Moderate":
        return Colors.orange;
      case "Mild":
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
