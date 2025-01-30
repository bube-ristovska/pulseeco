import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({Key? key}) : super(key: key);

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildLearnCard(String title, String subtitle, String url) {
    final Map<String, IconData> iconMap = {
      'What is Air Quality?': Icons.info_outline,
      'Air Quality Index': Icons.analytics_outlined,
      'Health Impact': Icons.medical_services_outlined,
      'Prevention': Icons.shield_outlined,
      'Take Action': Icons.eco_outlined,
      'Sources of Air Pollution': Icons.factory_outlined,
      'Indoor Air Quality': Icons.home_outlined,
      'Climate Change': Icons.cloud_outlined,
      'Children and Air Pollution': Icons.child_care_outlined,
      'Monitoring Air Quality': Icons.settings_input_antenna,
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 26, left: 13, right: 13),
      color: const Color(0xFF1A237E),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24), // Increased padding
        child:
          InkWell(
            onTap: () => _launchUrl(url),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon with text below
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  Icon(
                    iconMap[title] ?? Icons.article,
                    color: Color(0xFF1A237E),
                    size: 32,  // Increased icon size
                  ),
                ),
                const SizedBox(height: 16), // Increased space between the icon and text
                // Title (Smaller font size)
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,  // Reduced font size for the title
                  ),
                  textAlign: TextAlign.center,
                ),
                 // More space between title and subtitle
                // Subtitle
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,  // Slightly smaller subtitle font to fit better
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
      child: SingleChildScrollView(  // Wrap the entire content with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: const BoxDecoration(
                color: Color(0x00b9b8cf),
              ),
              child: const Text(
                'Learn more about air quality',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:  Color(0xFF1A237E),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // GridView inside the scrollable column
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GridView.builder(
                shrinkWrap: true,  // This makes the GridView take up only as much space as needed
                physics: const NeverScrollableScrollPhysics(),  // Disable scroll on the GridView itself
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 4.0, // Spacing between columns
                  mainAxisSpacing: 4.0, // Spacing between rows
                  childAspectRatio: 0.7, // Adjusted the aspect ratio for a taller card
                ),
                itemCount: 10, // Number of items in the grid
                itemBuilder: (context, index) {
                  // Use a list of titles, subtitles, and URLs
                  List<Map<String, String>> cardData = [
                    {
                      'title': 'What is Air Quality?',
                      'subtitle': 'Learn about air quality basics',
                      'url': 'https://www.epa.gov/indoor-air-quality-iaq/introduction-indoor-air-quality',
                    },
                    {
                      'title': 'Air Quality Index',
                      'subtitle': 'Understanding AQI measurements',
                      'url': 'https://www.airnow.gov/aqi/aqi-basics/',
                    },
                    {
                      'title': 'Health Impact',
                      'subtitle': 'How air quality affects health',
                      'url': 'https://www.who.int/health-topics/air-pollution',
                    },
                    {
                      'title': 'Prevention',
                      'subtitle': 'Ways to protect yourself',
                      'url': 'https://www.epa.gov/indoor-air-quality-iaq/protecting-yourself-smoke',
                    },
                    {
                      'title': 'Take Action',
                      'subtitle': 'Steps to improve air quality',
                      'url': 'https://www.epa.gov/indoor-air-quality-iaq/improving-indoor-air-quality',
                    },
                    {
                      'title': 'Sources of Air Pollution',
                      'subtitle': 'Where pollutants come from',
                      'url': 'https://www.epa.gov/indoor-air-quality-iaq/indoor-pollutants-and-sources',
                    },
                    {
                      'title': 'Indoor Air Quality',
                      'subtitle': 'Improving air quality at home',
                      'url': 'https://www.epa.gov/indoor-air-quality-iaq',
                    },
                    {
                      'title': 'Climate Change',
                      'subtitle': 'The connection between air quality and the environment',
                      'url': 'https://www.epa.gov/climate-change',
                    },
                    {
                      'title': 'Children and Air Pollution',
                      'subtitle': 'Special concerns for kids',
                      'url': 'https://www.epa.gov/children/protecting-childrens-health-and-environment',
                    },
                    {
                      'title': 'Monitoring Air Quality',
                      'subtitle': 'How air quality is tracked',
                      'url': 'https://www.airnow.gov/how-to-use-this-site/',
                    },
                  ];

                  return _buildLearnCard(
                    cardData[index]['title']!,
                    cardData[index]['subtitle']!,
                    cardData[index]['url']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
