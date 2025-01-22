import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//hi
class YourDeviceScreen extends StatefulWidget {
  const YourDeviceScreen({Key? key}) : super(key: key);

  @override
  State<YourDeviceScreen> createState() => YourDeviceScreenState();
}

class YourDeviceScreenState extends State<YourDeviceScreen> {
  final List<bool> _checkedItems = List.generate(9, (_) => false);

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $urlString'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildChecklistItem(int index, String text, {String? url}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: _checkedItems[index]
                ? const Icon(Icons.check, size: 16, color: Colors.blue)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: url != null
                ? GestureDetector(
              onTap: () => _launchUrl(url),
              child: Text(
                text,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            )
                : Text(text),
          ),
          Checkbox(
            value: _checkedItems[index],
            onChanged: (bool? value) {
              setState(() {
                _checkedItems[index] = value ?? false;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add a device'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adding a device helps your community',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'If your city is already present on the pulse.eco map, and you\'d like to contribute by constructing a new sensor device or integrating one already, then this manual is for you.',
                      ),
                      SizedBox(height: 16),
                      Text(
                        'If however your city is not to be found in the pulse.eco map, then head to Add City to learn how you can do that.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Guideline to add your sensor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildChecklistItem(
                0,
                'Get a suitable device for the pulse.eco network',
              ),
              _buildChecklistItem(
                1,
                'Read the prerequisites and configuration guidelines',
                url: 'https://pulse.eco/construct',
              ),
              _buildChecklistItem(
                2,
                'Place the device outside (balcony or yard), fixed to a wall or a post, and protected from direct sunlight and rain',
              ),
              _buildChecklistItem(
                3,
                'Place the device away from active sources of contamination (anything that produces smoke, vibration or sound)',
              ),
              _buildChecklistItem(
                4,
                'Face the device to the louder side of the object, so the noise measurement is more realistic',
              ),
              _buildChecklistItem(
                5,
                'Don\'t install the device very high (more than 3 or 4 stories) because the air pollution measurement will be unreliable',
              ),
              _buildChecklistItem(
                6,
                'Provide a solid and reliable network coverage (WiFi or TTN LoRaWAN)',
              ),
              _buildChecklistItem(
                7,
                'Log in or Register if you don\'t have an account',
                url: 'https://skopje.pulse.eco/register',
              ),
              _buildChecklistItem(
                8,
                'Register your device HERE',
                url: 'https://skopje.pulse.eco/requestDevice',
              ),
            ],
          ),
        ),
      ),
    );
  }
}