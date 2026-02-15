import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsaccomodations/providers/theme_provider.dart';


class PlayAreaScreen extends StatefulWidget {
  const PlayAreaScreen({super.key});

  @override
  State<PlayAreaScreen> createState() => _PlayAreaScreenState();
}

class _PlayAreaScreenState extends State<PlayAreaScreen> with SingleTickerProviderStateMixin {
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
                'Play & Recreation',
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
                    'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800',
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
                          Colors.cyan.shade600.withOpacity(0.15),
                          Colors.teal.shade600.withOpacity(0.15),
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
                                color: Colors.cyan.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.sports_soccer,
                            size: 64,
                            color: Color(0xFF00897B),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Stay Active, Stay Healthy',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Live in hostels with outdoor play areas and sports facilities. Balance your studies with recreation, fitness, and fun!',
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

                  // WHY PLAY AREAS
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
                                  colors: [Color(0xFF00897B), Color(0xFF26A69A)],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '⚽ Why Play Area Hostels?',
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
                          Icons.fitness_center,
                          'Stay Physically Fit',
                          'Regular exercise improves concentration, reduces stress, and boosts academic performance. Get your daily workout without gym fees!',
                          Colors.teal,
                        ),
                        _featureCard(
                          context,
                          Icons.group_add,
                          'Build Friendships',
                          'Sports bring students together. Play football, volleyball, or basketball with classmates and create lifelong bonds.',
                          Colors.blue,
                        ),
                        _featureCard(
                          context,
                          Icons.self_improvement,
                          'Stress Relief',
                          'Break from studying? Head to the play area! Physical activity releases endorphins and helps you relax and recharge.',
                          Colors.green,
                        ),
                        _featureCard(
                          context,
                          Icons.schedule,
                          'Convenient Access',
                          'No need to commute to sports facilities. Play whenever you want, right where you live. Morning jog or evening game!',
                          Colors.orange,
                        ),
                        _featureCard(
                          context,
                          Icons.games,
                          'Variety of Activities',
                          'From team sports to solo workouts, there\'s something for everyone. Basketball courts, football pitch, badminton, and more.',
                          Colors.purple,
                        ),
                        _featureCard(
                          context,
                          Icons.security,
                          'Safe Environment',
                          'Well-lit, secure play areas with CCTV monitoring. Exercise safely at any time of day with peace of mind.',
                          Colors.red,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // FACILITIES AVAILABLE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                    child: Column(
                      children: [
                        Text(
                          '🏀 Sports Facilities',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _facilityCard(context, Icons.sports_soccer, 'Football Pitch', 
                          'Full-size or 5-a-side courts, floodlights for night games', Colors.green),
                        const SizedBox(height: 12),
                        _facilityCard(context, Icons.sports_basketball, 'Basketball Court', 
                          'Standard hoops, marked lines, perfect for 3v3 or full games', Colors.orange),
                        const SizedBox(height: 12),
                        _facilityCard(context, Icons.sports_volleyball, 'Volleyball Net', 
                          'Beach or indoor volleyball setup with quality nets', Colors.blue),
                        const SizedBox(height: 12),
                        _facilityCard(context, Icons.sports_tennis, 'Badminton Court', 
                          'Indoor or outdoor courts with equipment available', Colors.red),
                        const SizedBox(height: 12),
                        _facilityCard(context, Icons.sports_handball, 'Multi-Purpose Court', 
                          'Versatile space for various sports and activities', Colors.purple),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ADDITIONAL AMENITIES
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        Row(
                          children: [
                            Expanded(child: _amenityCard(context, Icons.shower, 'Shower Rooms', Colors.blue)),
                            const SizedBox(width: 12),
                            Expanded(child: _amenityCard(context, Icons.water, 'Water Stations', Colors.cyan)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _amenityCard(context, Icons.lock, 'Lockers', Colors.orange)),
                            const SizedBox(width: 12),
                            Expanded(child: _amenityCard(context, Icons.light_mode, 'Floodlights', Colors.amber)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _amenityCard(context, Icons.event_seat, 'Seating Area', Colors.green)),
                            const SizedBox(width: 12),
                            Expanded(child: _amenityCard(context, Icons.medical_services, 'First Aid', Colors.red)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // SPORTS EQUIPMENT
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal.shade50,
                          Colors.cyan.shade50,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '🎾 Equipment Provided',
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
                            _equipmentChip(context, Icons.sports_soccer, 'Footballs'),
                            _equipmentChip(context, Icons.sports_basketball, 'Basketballs'),
                            _equipmentChip(context, Icons.sports_volleyball, 'Volleyballs'),
                            _equipmentChip(context, Icons.sports_tennis, 'Badminton Sets'),
                            _equipmentChip(context, Icons.sports_baseball, 'Bats & Balls'),
                            _equipmentChip(context, Icons.sports_handball, 'Handballs'),
                            _equipmentChip(context, Icons.sports_gymnastics, 'Yoga Mats'),
                            _equipmentChip(context, Icons.sports, 'Jump Ropes'),
                            _equipmentChip(context, Icons.directions_run, 'Running Track'),
                            _equipmentChip(context, Icons.fitness_center, 'Weights'),
                            _equipmentChip(context, Icons.pool, 'Swimming Pool'),
                            _equipmentChip(context, Icons.pedal_bike, 'Cycling Track'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // HEALTH BENEFITS
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
                        const Icon(Icons.favorite, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Health Benefits of Regular Exercise',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        _benefitItem('Improves memory and concentration'),
                        _benefitItem('Reduces stress and anxiety'),
                        _benefitItem('Boosts energy levels and mood'),
                        _benefitItem('Enhances sleep quality'),
                        _benefitItem('Strengthens immune system'),
                        _benefitItem('Promotes overall well-being'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ACTIVITY SCHEDULE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          '📅 Typical Activity Schedule',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _scheduleCard(context, '6:00 AM - 8:00 AM', 'Morning Jog & Yoga', Icons.wb_sunny, Colors.orange),
                        const SizedBox(height: 12),
                        _scheduleCard(context, '4:00 PM - 6:00 PM', 'Afternoon Sports (Football, Basketball)', Icons.sports_soccer, Colors.green),
                        const SizedBox(height: 12),
                        _scheduleCard(context, '7:00 PM - 9:00 PM', 'Evening Games & Recreation', Icons.nightlight, Colors.indigo),
                        const SizedBox(height: 12),
                        _scheduleCard(context, 'Weekends', 'Tournaments & Special Events', Icons.emoji_events, Colors.amber),
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
                          'Kevin Ochieng',
                          'Sports Science, KU',
                          'The play area is fantastic! I play football every evening after class. It keeps me fit and I\'ve made great friends through the games.',
                          '⭐⭐⭐⭐⭐',
                        ),
                        const SizedBox(height: 16),
                        _testimonialCard(
                          context,
                          'Mercy Wambui',
                          'Nursing Student, UoN',
                          'Having a sports facility right at home is amazing. Morning yoga sessions help me start my day refreshed and focused!',
                          '⭐⭐⭐⭐⭐',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // RULES & GUIDELINES
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
                        const Icon(Icons.rule, size: 48, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Play Area Guidelines',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ruleItem('Book courts in advance during peak hours'),
                        _ruleItem('Return equipment after use'),
                        _ruleItem('Respect other players and share facilities'),
                        _ruleItem('Wear appropriate sports attire'),
                        _ruleItem('No rough play or aggressive behavior'),
                        _ruleItem('Report injuries or equipment damage'),
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
                          'Ready to Stay Active?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Book a hostel with play area facilities today! Balance academics with fitness and fun!',
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
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.teal.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.construction,
                            size: 64,
                            color: Colors.teal.shade700,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Feature Coming Soon!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We\'re curating hostels with the best play areas and sports facilities. Check back soon!',
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
                              foregroundColor: Colors.teal.shade700,
                              side: BorderSide(color: Colors.teal.shade700),
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

  // Helper widgets (same structure as previous screens)
  Widget _featureCard(BuildContext context, IconData icon, String title, String description, Color color) {
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

  Widget _facilityCard(BuildContext context, IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
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

  Widget _amenityCard(BuildContext context, IconData icon, String label, Color color) {
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

  Widget _equipmentChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
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
          Icon(icon, size: 16, color: Colors.teal.shade700),
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

  Widget _benefitItem(String text) {
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

  Widget _scheduleCard(BuildContext context, String time, String activity, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
                backgroundColor: Colors.teal.withOpacity(0.1),
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00897B),
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
}