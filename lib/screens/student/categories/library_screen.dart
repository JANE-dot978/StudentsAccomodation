import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsaccomodations/providers/theme_provider.dart';


class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ANIMATED APP BAR
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Library Facilities',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=800',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CONTENT
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // HERO SECTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.shade600.withOpacity(0.15),
                          Colors.purple.shade600.withOpacity(0.15),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_library,
                            size: 64,
                            color: Color(0xFF5E35B1),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Your Personal Study Sanctuary',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Live in hostels with fully-equipped libraries. Study in peace, access thousands of books, and excel in your academics without leaving home.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // WHY LIBRARY HOSTELS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 4,
                              width: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF5E35B1), Color(0xFF7E57C2)],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '📚 Why Library Hostels?',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF2D3142),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _featureCard(
                          context,
                          Icons.menu_book,
                          'Extensive Book Collection',
                          'Access thousands of academic books, reference materials, journals, and research papers across all subjects.',
                          Colors.deepPurple,
                        ),
                        _featureCard(
                          context,
                          Icons.volume_off,
                          'Quiet Study Environment',
                          'Noise-free zones with strict silence policies. Perfect for concentration, exam preparation, and deep study sessions.',
                          Colors.blue,
                        ),
                        _featureCard(
                          context,
                          Icons.schedule,
                          '24/7 Access',
                          'Study anytime you want. Open round the clock for night owls and early birds. No closing times!',
                          Colors.green,
                        ),
                        _featureCard(
                          context,
                          Icons.table_restaurant,
                          'Private Study Desks',
                          'Individual study carrels with proper lighting, ergonomic chairs, and personal storage space for your books.',
                          Colors.orange,
                        ),
                        _featureCard(
                          context,
                          Icons.groups,
                          'Group Study Rooms',
                          'Dedicated spaces for group discussions, project work, and collaborative study sessions with classmates.',
                          Colors.teal,
                        ),
                        _featureCard(
                          context,
                          Icons.wifi,
                          'High-Speed WiFi',
                          'Fast internet for online research, e-learning platforms, downloading academic materials, and video tutorials.',
                          Colors.red,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // LIBRARY FEATURES
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                    child: Column(
                      children: [
                        Text(
                          '📖 Library Specifications',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _specCard(context, Icons.book, 'Book Collection', 
                          '2,000+ academic books, reference materials, fiction, non-fiction, magazines, and journals'),
                        const SizedBox(height: 12),
                        _specCard(context, Icons.chair, 'Seating Capacity', 
                          '30-50 students, Individual desks, Group tables, Reading corners with comfortable chairs'),
                        const SizedBox(height: 12),
                        _specCard(context, Icons.air, 'Environment', 
                          'Air conditioned, Noise-proof walls, Natural lighting, Reading lamps at every desk'),
                        const SizedBox(height: 12),
                        _specCard(context, Icons.access_time, 'Opening Hours', 
                          '24/7 access, Librarian available 8am-8pm, Self-service checkout system'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // BOOK CATEGORIES
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          '📑 Book Categories Available',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _categoryCard(context, Icons.science, 'Science & Engineering', Colors.blue)),
                            const SizedBox(width: 12),
                            Expanded(child: _categoryCard(context, Icons.account_balance, 'Business & Economics', Colors.green)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _categoryCard(context, Icons.calculate, 'Mathematics', Colors.orange)),
                            const SizedBox(width: 12),
                            Expanded(child: _categoryCard(context, Icons.computer, 'Computer Science', Colors.purple)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _categoryCard(context, Icons.health_and_safety, 'Medicine & Health', Colors.red)),
                            const SizedBox(width: 12),
                            Expanded(child: _categoryCard(context, Icons.language, 'Languages & Literature', Colors.teal)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _categoryCard(context, Icons.public, 'Social Sciences', Colors.indigo)),
                            const SizedBox(width: 12),
                            Expanded(child: _categoryCard(context, Icons.auto_stories, 'General Reading', Colors.amber)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // STUDY ZONES
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade50,
                          Colors.indigo.shade50,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '🎯 Different Study Zones',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _zoneCard(context, Icons.volume_off, 'Silent Zone', 
                          'Absolutely no talking. Perfect for exam preparation and intense study sessions.', Colors.blue),
                        const SizedBox(height: 12),
                        _zoneCard(context, Icons.people, 'Discussion Zone', 
                          'Group study area where quiet discussions are allowed. Great for project work.', Colors.green),
                        const SizedBox(height: 12),
                        _zoneCard(context, Icons.laptop_mac, 'Digital Zone', 
                          'Area with power outlets and WiFi for laptop users and online research.', Colors.orange),
                        const SizedBox(height: 12),
                        _zoneCard(context, Icons.weekend, 'Reading Corner', 
                          'Comfortable seating for leisure reading and general knowledge books.', Colors.purple),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ADDITIONAL SERVICES
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          '✨ Additional Services',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _amenityChip(context, Icons.photo_library, 'Photocopying'),
                            _amenityChip(context, Icons.print, 'Printing'),
                            _amenityChip(context, Icons.scanner, 'Scanning'),
                            _amenityChip(context, Icons.laptop, 'Laptop Charging'),
                            _amenityChip(context, Icons.usb, 'USB Ports'),
                            _amenityChip(context, Icons.coffee, 'Water Dispenser'),
                            _amenityChip(context, Icons.lock, 'Personal Lockers'),
                            _amenityChip(context, Icons.sanitizer, 'Sanitizers'),
                            _amenityChip(context, Icons.event_seat, 'Reserved Seats'),
                            _amenityChip(context, Icons.headphones, 'Audio Books'),
                            _amenityChip(context, Icons.newspaper, 'Daily Papers'),
                            // _amenityChip(context, Icons.magazine, 'Magazines'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // STUDY TIPS
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.lightbulb, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Library Rules & Etiquette',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ruleItem('Maintain silence in designated zones'),
                        _ruleItem('Return books within 2 weeks'),
                        _ruleItem('No food or drinks (water allowed)'),
                        _ruleItem('Keep mobile phones on silent'),
                        _ruleItem('Respect other students\' study time'),
                        _ruleItem('Report damaged books immediately'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // TESTIMONIALS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          '💬 What Students Say',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _testimonialCard(
                          context,
                          'Peter Kamau',
                          'Law Student, UoN',
                          'The library in my hostel is a lifesaver! I can study until 2am without worrying about transport back. My grades have improved significantly!',
                          '⭐⭐⭐⭐⭐',
                        ),
                        const SizedBox(height: 16),
                        _testimonialCard(
                          context,
                          'Faith Wanjiku',
                          'Medical Student, KU',
                          'Having access to medical textbooks and journals right in my hostel saves me so much time. The quiet environment helps me concentrate better.',
                          '⭐⭐⭐⭐⭐',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // BENEFITS COMPARISON
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.purple.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '📊 Library Hostel vs Regular Hostel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _comparisonRow(context, 'Study Space', 'Dedicated library', 'Just bedroom', true),
                        const Divider(),
                        _comparisonRow(context, 'Books Available', '2,000+ books', 'Your own only', true),
                        const Divider(),
                        _comparisonRow(context, 'Noise Level', 'Quiet zones', 'Can be noisy', true),
                        const Divider(),
                        _comparisonRow(context, 'Study Until', '24/7 access', 'Room only', true),
                        const Divider(),
                        _comparisonRow(context, 'Academic Support', 'Research materials', 'Limited', true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // CTA SECTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrange.shade400,
                          Colors.orange.shade500,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.celebration, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Ready to Boost Your Grades?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Book a room in a hostel with library facilities today! Study better, achieve more!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_downward),
                          label: const Text('View Available Hostels'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // COMING SOON
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.construction,
                            size: 64,
                            color: Colors.purple.shade700,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Feature Coming Soon!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We\'re carefully selecting hostels with the best library facilities. Check back soon!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Browse Other Categories'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.purple.shade700,
                              side: BorderSide(color: Colors.purple.shade700),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specCard(BuildContext context, IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _zoneCard(BuildContext context, IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _amenityChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.deepPurple.shade700),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ruleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _testimonialCard(
    BuildContext context,
    String name,
    String role,
    String review,
    String rating,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E35B1),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(rating, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"$review"',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _comparisonRow(BuildContext context, String feature, String library, String regular, bool libraryBetter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (libraryBetter) const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    library,
                    style: TextStyle(
                      fontSize: 13,
                      color: libraryBetter ? Colors.green.shade700 : Colors.grey.shade700,
                      fontWeight: libraryBetter ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              regular,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}