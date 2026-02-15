import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsaccomodations/providers/theme_provider.dart';


class TVLoungeScreen extends StatefulWidget {
  const TVLoungeScreen({super.key});

  @override
  State<TVLoungeScreen> createState() => _TVLoungeScreenState();
}

class _TVLoungeScreenState extends State<TVLoungeScreen> with SingleTickerProviderStateMixin {
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
                'TV Lounge & Entertainment',
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
                    'https://images.unsplash.com/photo-1522156373667-4c7234bbd804?w=800',
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
                          Colors.red.shade600.withOpacity(0.15),
                          Colors.orange.shade600.withOpacity(0.15),
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
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.tv,
                            size: 64,
                            color: Color(0xFFD32F2F),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Relax, Unwind, Connect',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Live in hostels with modern TV lounges. Watch your favorite shows, play games, and socialize with fellow students in comfort.',
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

                  // WHY TV LOUNGE
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
                                  colors: [Color(0xFFD32F2F), Color(0xFFFF6F00)],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '📺 Why TV Lounge Hostels?',
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
                          Icons.weekend,
                          'Entertainment Hub',
                          'Large flat-screen TVs with DStv, Netflix, and streaming services. Watch movies, series, sports, and news anytime.',
                          Colors.red,
                        ),
                        _featureCard(
                          context,
                          Icons.people,
                          'Social Connection',
                          'Meet and bond with fellow students. Watch matches together, host movie nights, and build lasting friendships.',
                          Colors.blue,
                        ),
                        _featureCard(
                          context,
                          Icons.sports_esports,
                          'Gaming Zone',
                          'PlayStation, Xbox, and gaming consoles available. Enjoy FIFA, Call of Duty, and other popular games with friends.',
                          Colors.green,
                        ),
                        _featureCard(
                          context,
                          Icons.chair_alt,
                          'Comfortable Seating',
                          'Plush sofas, bean bags, and recliners. Designed for maximum comfort during long viewing sessions.',
                          Colors.orange,
                        ),
                        _featureCard(
                          context,
                          Icons.ac_unit,
                          'Climate Controlled',
                          'Fully air-conditioned space. Enjoy your entertainment in cool, comfortable temperatures year-round.',
                          Colors.purple,
                        ),
                        _featureCard(
                          context,
                          Icons.volume_up,
                          'Premium Sound',
                          'Surround sound systems and high-quality audio. Feel every explosion, goal, and musical note.',
                          Colors.teal,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // LOUNGE FEATURES
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                    child: Column(
                      children: [
                        Text(
                          '🎬 Lounge Specifications',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _specCard(context, Icons.tv, 'Display', 
                          '55-75 inch 4K Smart TVs, Projector screens, Multiple viewing angles'),
                        const SizedBox(height: 12),
                        _specCard(context, Icons.subscriptions, 'Subscriptions', 
                          'DStv Premium, Netflix, YouTube, Showmax, Amazon Prime, Disney+'),
                        const SizedBox(height: 12),
                        _specCard(context, Icons.event_seat, 'Seating', 
                          'L-shaped sofas, Individual recliners, Bean bags, Floor cushions for 20-30 people'),
                        const SizedBox(height: 12),
                        _specCard(context, Icons.access_time, 'Hours', 
                          'Open 24/7, Special late-night screenings, Sports events broadcasts'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ENTERTAINMENT OPTIONS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          '🎮 Entertainment Options',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _optionCard(context, Icons.movie, 'Movies & Series', Colors.red)),
                            const SizedBox(width: 12),
                            Expanded(child: _optionCard(context, Icons.sports_soccer, 'Live Sports', Colors.green)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _optionCard(context, Icons.videogame_asset, 'Video Games', Colors.blue)),
                            const SizedBox(width: 12),
                            Expanded(child: _optionCard(context, Icons.music_note, 'Music Videos', Colors.purple)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _optionCard(context, Icons.emoji_events, 'E-Sports', Colors.orange)),
                            const SizedBox(width: 12),
                            Expanded(child: _optionCard(context, Icons.podcasts, 'Documentaries', Colors.teal)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // POPULAR CHANNELS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.shade50,
                          Colors.orange.shade50,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '📡 Popular Channels & Streaming',
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
                            _channelChip(context, 'SuperSport'),
                            _channelChip(context, 'Netflix'),
                            _channelChip(context, 'CNN'),
                            _channelChip(context, 'BBC'),
                            _channelChip(context, 'KTN'),
                            _channelChip(context, 'Citizen'),
                            _channelChip(context, 'NTV'),
                            _channelChip(context, 'Discovery'),
                            _channelChip(context, 'Disney+'),
                            _channelChip(context, 'MTV'),
                            _channelChip(context, 'Comedy Central'),
                            _channelChip(context, 'Cartoon Network'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // GAMING CONSOLES
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          '🎮 Gaming Consoles Available',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _gamingCard(context, 'PlayStation 5', 
                          'Latest games including FIFA 24, GTA V, Spider-Man, God of War', Colors.blue),
                        const SizedBox(height: 12),
                        _gamingCard(context, 'Xbox Series X', 
                          'Halo Infinite, Forza Horizon, Call of Duty, Gears of War', Colors.green),
                        const SizedBox(height: 12),
                        _gamingCard(context, 'Nintendo Switch', 
                          'Mario Kart, Zelda, Animal Crossing, Super Smash Bros', Colors.red),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // LOUNGE RULES
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.deepOrange.shade500,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.rule, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Lounge Etiquette',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ruleItem('Book gaming consoles in advance'),
                        _ruleItem('Volume down after 10pm'),
                        _ruleItem('Clean up after yourself'),
                        _ruleItem('No food that stains or smells'),
                        _ruleItem('Respect viewing preferences'),
                        _ruleItem('Report any equipment issues'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // EVENTS & SCREENINGS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          '🎉 Special Events & Screenings',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _eventCard(context, Icons.sports_soccer, 'Match Days', 
                          'Watch Premier League, La Liga, Champions League matches with snacks and drinks', Colors.green),
                        const SizedBox(height: 12),
                        _eventCard(context, Icons.movie_creation, 'Movie Nights', 
                          'Friday & Saturday movie marathons with popcorn and themed screenings', Colors.red),
                        const SizedBox(height: 12),
                        _eventCard(context, Icons.videogame_asset, 'Gaming Tournaments', 
                          'Monthly FIFA, PES, and other gaming competitions with prizes', Colors.blue),
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
                          'Brian Otieno',
                          'Business Student, Strathmore',
                          'The TV lounge is amazing! We watch all the big matches together. It\'s like having a sports bar in your home!',
                          '⭐⭐⭐⭐⭐',
                        ),
                        const SizedBox(height: 16),
                        _testimonialCard(
                          context,
                          'Lucy Akinyi',
                          'Communication Student, USIU',
                          'Movie nights every Friday are the highlight of my week. Made so many friends through the TV lounge!',
                          '⭐⭐⭐⭐⭐',
                        ),
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
                          Colors.red.shade500,
                          Colors.deepOrange.shade600,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.celebration, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Ready for Entertainment?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Book a room in a hostel with TV lounge today! All-in-one living, studying, and entertainment!',
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
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.construction,
                            size: 64,
                            color: Colors.red.shade700,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Feature Coming Soon!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We\'re selecting hostels with the best entertainment facilities. Stay tuned!',
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
                              foregroundColor: Colors.red.shade700,
                              side: BorderSide(color: Colors.red.shade700),
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

  // HELPER WIDGETS
  Widget _featureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
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

  Widget _specCard(
    BuildContext context,
    IconData icon,
    String title,
    String details,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionCard(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _channelChip(BuildContext context, String channel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Text(
        channel,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFD32F2F),
        ),
      ),
    );
  }

  Widget _gamingCard(
    BuildContext context,
    String console,
    String games,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            console,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            games,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ruleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              rule,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _testimonialCard(
    BuildContext context,
    String name,
    String title,
    String testimonial,
    String rating,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rating,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            testimonial,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}