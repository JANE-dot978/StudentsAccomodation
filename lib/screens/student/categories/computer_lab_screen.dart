import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsaccomodations/providers/theme_provider.dart';


class ComputerLabScreen extends StatefulWidget {
  const ComputerLabScreen({super.key});

  @override
  State<ComputerLabScreen> createState() => _ComputerLabScreenState();
}

class _ComputerLabScreenState extends State<ComputerLabScreen> with SingleTickerProviderStateMixin {
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
                'Computer Lab Facilities',
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
                    'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=800',
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
                          Colors.blue.shade600.withOpacity(0.15),
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
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.computer,
                            size: 64,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Study Smart, Live Smarter',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Live in hostels equipped with state-of-the-art computer labs. Perfect for tech students, researchers, and anyone who needs 24/7 access to computers.',
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

                  // WHY COMPUTER LAB HOSTELS
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
                                  colors: [Color(0xFF1976D2), Color(0xFF7B1FA2)],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '💻 Why Computer Lab Hostels?',
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
                          Icons.schedule,
                          '24/7 Access',
                          'Work on assignments anytime, day or night. No need to rush to campus computer labs before closing time.',
                          Colors.blue,
                        ),
                        _featureCard(
                          context,
                          Icons.speed,
                          'High-Speed Internet',
                          'Lightning-fast fiber optic internet connection (50-100 Mbps). Stream lectures, download resources, and submit assignments without lag.',
                          Colors.green,
                        ),
                        _featureCard(
                          context,
                          Icons.desktop_windows,
                          'Modern Equipment',
                          'Latest computers with powerful processors, large RAM, and professional software pre-installed (MS Office, Adobe Suite, IDEs).',
                          Colors.orange,
                        ),
                        _featureCard(
                          context,
                          Icons.print,
                          'Free Printing',
                          'Print your assignments, research papers, and study materials for free. Includes scanner and photocopier access.',
                          Colors.purple,
                        ),
                        _featureCard(
                          context,
                          Icons.support_agent,
                          'Tech Support',
                          'On-site IT support to help with software issues, network problems, or any technical difficulties you encounter.',
                          Colors.red,
                        ),
                        _featureCard(
                          context,
                          Icons.security,
                          'Secure & Private',
                          'Password-protected workstations, CCTV monitoring, and secure data storage. Your projects and files are safe.',
                          Colors.teal,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // COMPUTER LAB FEATURES
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                    child: Column(
                      children: [
                        Text(
                          '🖥️ Lab Specifications',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _specCard(context, Icons.computer_outlined, 'Hardware', 
                          'Intel Core i5/i7 processors, 8-16GB RAM, 256GB-1TB SSD storage, 24" full HD monitors'),
                        const SizedBox(height: 12),
                        _specCard(context, Icons.code, 'Software', 
                          'Windows 10/11, Microsoft Office 365, Visual Studio Code, Python, Java, Adobe Creative Cloud'),
                        const SizedBox(height: 12),
                        _specCard(context, Icons.wifi, 'Network', 
                          'Fiber optic 100 Mbps, Ethernet & WiFi, Network printers, Cloud storage access'),
                        const SizedBox(height: 12),
                        _specCard(context, Icons.group, 'Capacity', 
                          '10-30 workstations per lab, Group study areas, Private cubicles available'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // PERFECT FOR
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          '🎯 Perfect For',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _perfectForCard(context, Icons.code_outlined, 'IT & Computer Science', Colors.blue)),
                            const SizedBox(width: 12),
                            Expanded(child: _perfectForCard(context, Icons.engineering, 'Engineering Students', Colors.orange)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _perfectForCard(context, Icons.design_services, 'Graphic Designers', Colors.purple)),
                            const SizedBox(width: 12),
                            Expanded(child: _perfectForCard(context, Icons.science, 'Research Scholars', Colors.green)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _perfectForCard(context, Icons.video_library, 'Video Editors', Colors.red)),
                            const SizedBox(width: 12),
                            Expanded(child: _perfectForCard(context, Icons.laptop_mac, 'Online Learners', Colors.teal)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ADDITIONAL AMENITIES
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade50,
                          Colors.purple.shade50,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '✨ Additional Amenities',
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
                            _amenityChip(context, Icons.air, 'Air Conditioning'),
                            _amenityChip(context, Icons.chair, 'Ergonomic Chairs'),
                            _amenityChip(context, Icons.light_mode, 'Good Lighting'),
                            _amenityChip(context, Icons.local_cafe, 'Coffee Machine'),
                            _amenityChip(context, Icons.volume_off, 'Quiet Environment'),
                            _amenityChip(context, Icons.lock, 'Secure Lockers'),
                            _amenityChip(context, Icons.power, 'Backup Generator'),
                            _amenityChip(context, Icons.sanitizer, 'Hand Sanitizers'),
                            _amenityChip(context, Icons.extension, 'Power Outlets'),
                            _amenityChip(context, Icons.headphones, 'Audio Equipment'),
                            _amenityChip(context, Icons.scanner, 'Scanner Access'),
                            _amenityChip(context, Icons.usb, 'USB Ports'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // PRICING INFO
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.attach_money, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Affordable Pricing',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Computer lab access is included FREE with your room rent! No extra charges for printing (up to 100 pages/month) or internet usage.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text(
                            'KES 12,000 - 20,000 / month',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // STUDENT TESTIMONIALS
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
                          'James Omondi',
                          'Computer Science, JKUAT',
                          'Having a computer lab in my hostel saved me countless hours. I can code late at night and submit assignments on time. Best decision ever!',
                          '⭐⭐⭐⭐⭐',
                        ),
                        const SizedBox(height: 16),
                        _testimonialCard(
                          context,
                          'Mary Njeri',
                          'Graphic Design, Daystar',
                          'The Adobe Creative Suite is already installed! I don\'t need to buy expensive software. Plus the internet is super fast for uploading designs.',
                          '⭐⭐⭐⭐⭐',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // COMPARISON TABLE
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '📊 Hostel vs Campus Lab',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _comparisonRow(context, 'Opening Hours', '24/7', '8am - 6pm', true),
                        const Divider(),
                        _comparisonRow(context, 'Queue Time', 'No waiting', '10-30 mins', true),
                        const Divider(),
                        _comparisonRow(context, 'Printing Cost', 'Free (100pg)', 'KES 5/page', true),
                        const Divider(),
                        _comparisonRow(context, 'Distance', 'At home', '10-30 mins walk', true),
                        const Divider(),
                        _comparisonRow(context, 'Privacy', 'High', 'Limited', true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // HOW TO BOOK
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.deepOrange.shade500,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.celebration, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Ready to Book?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Browse available hostels with computer lab facilities below. Book now and enjoy 24/7 access to modern computing resources!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Scroll to bottom or show hostels
                          },
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

                  // COMING SOON - HOSTELS LIST
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.construction,
                                size: 64,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Feature Coming Soon!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'We\'re curating the best hostels with computer lab facilities. Check back soon or contact support for recommendations.',
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
                                  foregroundColor: Colors.blue.shade700,
                                  side: BorderSide(color: Colors.blue.shade700),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FOOTER
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      '© 2026 Cozy Corner - Smart Student Living',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 24),
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

  Widget _perfectForCard(BuildContext context, IconData icon, String label, Color color) {
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
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _amenityChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
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
          Icon(icon, size: 16, color: Colors.blue.shade700),
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
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
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

  Widget _comparisonRow(BuildContext context, String feature, String hostel, String campus, bool hostelBetter) {
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
                if (hostelBetter) const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    hostel,
                    style: TextStyle(
                      fontSize: 13,
                      color: hostelBetter ? Colors.green.shade700 : Colors.grey.shade700,
                      fontWeight: hostelBetter ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              campus,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}