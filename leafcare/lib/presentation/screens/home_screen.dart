import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/data/models/user_model.dart';
import 'package:leafcare/data/repositories/auth_repository.dart';
import 'package:leafcare/presentation/screens/disease_library_screen.dart';
import 'package:leafcare/presentation/screens/history_screen.dart';
import 'package:leafcare/presentation/screens/profile_screen.dart';
import 'package:leafcare/presentation/widgets/option_card.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:leafcare/presentation/screens/scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track selected tab

  final List<Widget> _pages = [
    HomeContent(), // Extract home content into a separate widget
    ScanScreen(),
    // ReportScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // If "Scan" is tapped, navigate to ScanScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex, // Highlight selected tab
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.scanLine), label: "Scan"),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.user), label: "Profile"),
        ],
      ),
    );
  }

  // Reusable Card Widget with GestureDetector for Clicks
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: FutureBuilder<UserModel?>(
          future: authRepository.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Text("Welcome!");
            }
            final user = snapshot.data!;
            return Row(
              children: [
                CircleAvatar(
                  backgroundImage: user.profileImage != null &&
                          user.profileImage!.isNotEmpty
                      ? NetworkImage(user.profileImage!)
                      : AssetImage('assets/images/avatar.png'),
                  radius: 18,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      user.name.isNotEmpty ? user.name : "User",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search diseases, scans...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Cards with Navigation
            buildOptionCard(
              title: "Scan Leaf",
              subtitle: "Analyze plant health instantly",
              gradientColors: [
                const Color(0xFF10B981),
                const Color(0xFF10B981)
              ],
              icon: CupertinoIcons.camera_fill,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanScreen()),
                );
              },
            ),

            buildOptionCard(
              title: "Disease Info",
              subtitle: "Browse plant diseases library",
              gradientColors: [
                const Color(0xFF3B82F6),
                const Color(0xFF3B82F6)
              ],
              icon: CupertinoIcons.book_fill,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DiseaseLibraryScreen()),
                );
              },
            ),

            buildOptionCard(
              title: "Scan History",
              subtitle: "View previous analyses",
              gradientColors: [
                const Color(0xFF8B5CF6),
                const Color(0xFF8B5CF6)
              ],
              icon: CupertinoIcons.folder_fill,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
