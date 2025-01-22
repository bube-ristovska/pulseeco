import 'package:flutter/material.dart';

// OnboardingScreen widget that manages the state and navigation of the onboarding process
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller for managing page transitions
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // List of screen data for easy maintenance and scalability
  final List<OnboardingScreenData> screens = [
    OnboardingScreenData(
      title: 'Co-create the future of your city!',
      description: 'Join us in the effort to empower actions towards sustainable environmental development. Get informed and participate in gathering, analysis and visualization of environmental data to contribute for a better tomorrow.',
      imagePath: 'assets/images/welcome_map.png',
      primaryButtonText: 'CONTINUE',
      showSecondaryButton: false,
    ),
    OnboardingScreenData(
      title: 'Turn on notifications',
      description: 'Enable notifications to receive timely alerts about air quality changes in your area. You\'ll be notified about high pollution levels, health recommendations, and updates from local air monitoring stations.',
      imagePath: 'assets/images/notifications.png',
      primaryButtonText: 'TURN ON',
      secondaryButtonText: 'NO, THANKS',
      showSecondaryButton: true,
    ),
    OnboardingScreenData(
      title: 'Turn on location',
      description: 'Allow location access to see real-time air pollution levels and alerts for your area. We only use your location to provide accurate, location-based information to keep you safe and informed.',
      imagePath: 'assets/images/location.png',
      primaryButtonText: 'TURN ON',
      secondaryButtonText: 'NO, THANKS',
      showSecondaryButton: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Handle primary button actions based on current page
  void _handlePrimaryButtonTap() async {
    switch (_currentPage) {
      case 0:
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 1:
      // TODO: Implement notification permission request
        await _requestNotificationPermission();
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 2:
      // TODO: Implement location permission request
        await _requestLocationPermission();
        // Navigate to main app screen after completing onboarding
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        break;
    }
  }

  // Handle secondary button actions
  void _handleSecondaryButtonTap() {
    if (_currentPage < screens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // Placeholder for notification permission request
  Future<void> _requestNotificationPermission() async {
    // Implement platform-specific notification permission request
  }

  // Placeholder for location permission request
  Future<void> _requestLocationPermission() async {
    // Implement platform-specific location permission request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF322E99), // Deep purple background
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: screens.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                data: screens[index],
                onPrimaryButtonTap: _handlePrimaryButtonTap,
                onSecondaryButtonTap: _handleSecondaryButtonTap,
              );
            },
          ),
          // Page indicator dots
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                screens.length,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data class for organizing screen content
class OnboardingScreenData {
  final String title;
  final String description;
  final String imagePath;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final bool showSecondaryButton;

  OnboardingScreenData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.primaryButtonText,
    this.secondaryButtonText,
    this.showSecondaryButton = false,
  });
}

// Individual onboarding page widget
class OnboardingPage extends StatelessWidget {
  final OnboardingScreenData data;
  final VoidCallback onPrimaryButtonTap;
  final VoidCallback onSecondaryButtonTap;

  const OnboardingPage({
    Key? key,
    required this.data,
    required this.onPrimaryButtonTap,
    required this.onSecondaryButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  data.imagePath,
                  height: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  data.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: onPrimaryButtonTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF322E99),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(data.primaryButtonText),
              ),
              if (data.showSecondaryButton) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onSecondaryButtonTap,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(data.secondaryButtonText ?? ''),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}