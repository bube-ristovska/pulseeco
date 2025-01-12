import 'package:flutter/material.dart';
import 'cities.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  City? selectedCity;

  final List<OnboardingScreenData> screens = [
    OnboardingScreenData(
      title: 'Co-create the future of your city!',
      description: 'Join us in the effort to empower actions towards sustainable environmental development.',
      imagePath: 'assets/images/welcome_map.png',
      primaryButtonText: 'CONTINUE',
      showSecondaryButton: false,
    ),
    OnboardingScreenData(
      title: 'Choose Your Main City',
      description: 'Select your primary city to monitor air quality and environmental data.',
      imagePath: 'assets/images/city.jpg',
      primaryButtonText: 'CHOOSE CITY',
      showSecondaryButton: false,
      isChooseCity: true,
    ),
    OnboardingScreenData(
      title: 'Turn on notifications',
      description: 'Enable notifications to receive timely alerts about air quality changes in your area.',
      imagePath: 'assets/images/notifications.png',
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

  void _handlePrimaryButtonTap() async {
    if (_currentPage == 1 && selectedCity == null) {
      // Show city selection dialog if no city is selected
      _showCitySelectionDialog();
      return;
    }

    if (_currentPage < screens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to home screen with selected city
      if (mounted && selectedCity != null) {
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: selectedCity,
        );
      }
    }
  }

  void _handleSecondaryButtonTap() {
    if (_currentPage < screens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home', arguments: selectedCity);
    }
  }

  Future<void> _showCitySelectionDialog() async {
    final City? result = await showDialog<City>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Your Main City'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cities[index].name),
                  subtitle: Text(cities[index].country),
                  onTap: () {
                    Navigator.pop(context, cities[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedCity = result;
        _handlePrimaryButtonTap(); // Proceed to next page after selection
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF322E99),
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
                selectedCity: selectedCity,
              );
            },
          ),
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

class OnboardingScreenData {
  final String title;
  final String description;
  final String imagePath;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final bool showSecondaryButton;
  final bool isChooseCity;

  OnboardingScreenData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.primaryButtonText,
    this.secondaryButtonText,
    this.showSecondaryButton = false,
    this.isChooseCity = false,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingScreenData data;
  final VoidCallback onPrimaryButtonTap;
  final VoidCallback onSecondaryButtonTap;
  final City? selectedCity;

  const OnboardingPage({
    Key? key,
    required this.data,
    required this.onPrimaryButtonTap,
    required this.onSecondaryButtonTap,
    this.selectedCity,
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
                if (data.isChooseCity && selectedCity != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Selected City: ${selectedCity!.name}, ${selectedCity!.country}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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