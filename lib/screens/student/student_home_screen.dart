import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsaccomodations/providers/theme_provider.dart';

import 'categories/bedsitter_screen.dart';
import 'categories/shared_room_screen.dart';
import 'categories/single_room_screen.dart';
import 'categories/library_screen.dart';
import 'categories/computer_lab_screen.dart';
import 'categories/tv_lounge_screen.dart';
import 'categories/play_area_screen.dart';
import 'categories/about_screen.dart';
import 'search_screen.dart';

// ✅ Same theme colors
const kNavy = Color(0xFF1A237E);
const kSlate = Color(0xFF37474F);

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;

  // ✅ Banner slides with images + overlay text
  final List<Map<String, dynamic>> _banners = [
    {
      'image': 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
      'title': 'Find Your Perfect Room',
      'subtitle': 'Comfortable student accommodation near campus',
      'tag': 'Single Rooms',
    },
    {
      'image': 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?w=800',
      'title': 'Modern Bedsitters',
      'subtitle': 'Self-contained living with all amenities included',
      'tag': 'Bedsitters',
    },
    {
      'image': 'https://images.unsplash.com/photo-1529333166437-7750a6dd5a70?w=800',
      'title': 'Meet New Friends',
      'subtitle': 'Affordable shared rooms with great community vibes',
      'tag': 'Shared Rooms',
    },
    {
      'image': 'https://images.unsplash.com/photo-1568667256549-094345857637?w=800',
      'title': 'Study in Peace',
      'subtitle': 'Well-equipped libraries for focused studying',
      'tag': 'Library',
    },
    {
      'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
      'title': 'Stay Active',
      'subtitle': 'Recreational facilities to keep you energized',
      'tag': 'Play Area',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        final next = (_currentBanner + 1) % _banners.length;
        _bannerController.animateToPage(
          next,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [

            // ✅ AUTO-SCROLLING BANNER
            _buildBanner(),

            const SizedBox(height: 20),

            // ✅ SEARCH BAR
            _buildSearchBar(context),

            const SizedBox(height: 24),

            // ✅ SECTION TITLE
            _buildSectionTitle(context, isDark),

            const SizedBox(height: 16),

            // ✅ CATEGORY GRID
            _buildCategoryGrid(context, isDark),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============ BANNER ============
  Widget _buildBanner() {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) {
              setState(() => _currentBanner = index);
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return _buildBannerSlide(banner);
            },
          ),

          // ✅ Dot Indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentBanner == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentBanner == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSlide(Map<String, dynamic> banner) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.network(
              banner['image'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kNavy, kSlate],
                  ),
                ),
              ),
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.75),
                  ],
                ),
              ),
            ),

            // Text Content
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      banner['tag'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    banner['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    banner['subtitle'],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ SEARCH BAR ============
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kNavy, kSlate],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Search rooms, facilities...",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: kNavy.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(
                    color: kNavy,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ SECTION TITLE ============
  Widget _buildSectionTitle(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Left accent bar
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kNavy, kSlate],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Explore Categories",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A237E),
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kNavy.withOpacity(0.1), kSlate.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: kNavy.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Text(
              '8 Services',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: kNavy,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ CATEGORY GRID ============
  Widget _buildCategoryGrid(BuildContext context, bool isDark) {
    final categories = [
      {
        'icon': Icons.home_rounded,
        'label': 'Single\nRooms',
        'gradient': [const Color(0xFF1A237E), const Color(0xFF3949AB)],
        'screen': const SingleRoomScreen(),
        'badge': 'Private',
      },
      {
        'icon': Icons.home_rounded,
        'label': 'Bedsitters',
        'gradient': [const Color(0xFF37474F), const Color(0xFF546E7A)],
        'screen': const BedsitterScreen(),
        'badge': 'Popular',
      },
      {
        'icon': Icons.people_rounded,
        'label': 'Shared\nRooms',
        'gradient': [const Color(0xFF1565C0), const Color(0xFF1976D2)],
        'screen': const SharedRoomScreen(),
        'badge': 'Budget',
      },
      {
        'icon': Icons.menu_book_rounded,
        'label': 'Library',
        'gradient': [const Color(0xFF263238), const Color(0xFF455A64)],
        'screen': const LibraryScreen(),
        'badge': 'Study',
      },
      {
        'icon': Icons.computer_rounded,
        'label': 'Computer\nLab',
        'gradient': [const Color(0xFF0D47A1), const Color(0xFF1565C0)],
        'screen': const ComputerLabScreen(),
        'badge': 'Tech',
      },
      {
        'icon': Icons.tv_rounded,
        'label': 'TV Lounge',
        'gradient': [const Color(0xFF37474F), const Color(0xFF607D8B)],
        'screen': const TVLoungeScreen(),
        'badge': 'Relax',
      },
      {
        'icon': Icons.sports_esports_rounded,
        'label': 'Play Area',
        'gradient': [const Color(0xFF1A237E), const Color(0xFF283593)],
        'screen': const PlayAreaScreen(),
        'badge': 'Fun',
      },
      {
        'icon': Icons.info_rounded,
        'label': 'About',
        'gradient': [const Color(0xFF455A64), const Color(0xFF546E7A)],
        'screen': const AboutScreen(),
        'badge': 'Info',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.82,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _buildCategoryItem(
            context: context,
            icon: cat['icon'] as IconData,
            label: cat['label'] as String,
            gradientColors: cat['gradient'] as List<Color>,
            badge: cat['badge'] as String,
            isDark: isDark,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => cat['screen'] as Widget,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
    required String badge,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Icon with gradient background
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors[0].withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 24, color: Colors.white),
                  ),

                  // ✅ Badge chip (top right corner)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: gradientColors[0],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ✅ Label
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A237E),
                  height: 1.2,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}