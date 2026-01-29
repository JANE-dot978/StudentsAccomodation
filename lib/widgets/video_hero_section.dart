import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoHeroSection extends StatefulWidget {
  const VideoHeroSection({super.key});

  @override
  State<VideoHeroSection> createState() => _VideoHeroSectionState();
}

class _VideoHeroSectionState extends State<VideoHeroSection> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/hostels.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..setVolume(0) // autoplay silently like modern landing pages
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const SizedBox(
        height: 500,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 520,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🎥 Background Video
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),

          // 🌑 Dark overlay for text readability
          Container(color: Colors.black.withOpacity(0.45)),

          // 🏢 Text Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Cozy Corner Residences",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Modern student living • Safe • Affordable • Community-driven",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // CTA Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Explore Hostels",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
