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
    return Card(
      margin: const EdgeInsets.only(bottom: 14, left: 16, right: 16),
      color: const Color(0xFF1A237E),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.article,
            color: Color(0xFF1A237E),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.white), // Changed to open_in_new icon
        onTap: () => _launchUrl(url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: const BoxDecoration(
                color: Color(0xFFEFE2EF)
            ),
            child: const Text(
              'Learn',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  _buildLearnCard(
                    'What is Air Quality?',
                    'Learn about air quality basics',
                    'https://www.epa.gov/indoor-air-quality-iaq/introduction-indoor-air-quality',
                  ),
                  _buildLearnCard(
                    'Air Quality Index',
                    'Understanding AQI measurements',
                    'https://www.airnow.gov/aqi/aqi-basics/',
                  ),
                  _buildLearnCard(
                    'Health Impact',
                    'How air quality affects health',
                    'https://www.who.int/health-topics/air-pollution',
                  ),
                  _buildLearnCard(
                    'Prevention',
                    'Ways to protect yourself',
                    'https://www.epa.gov/indoor-air-quality-iaq/protecting-yourself-smoke',
                  ),
                  _buildLearnCard(
                    'Take Action',
                    'Steps to improve air quality',
                    'https://www.epa.gov/indoor-air-quality-iaq/improving-indoor-air-quality',
                  ),
                  _buildLearnCard(
                    'Sources of Air Pollution',
                    'Where pollutants come from',
                    'https://www.epa.gov/indoor-air-quality-iaq/indoor-pollutants-and-sources',
                  ),
                  _buildLearnCard(
                    'Indoor Air Quality',
                    'Improving air quality at home',
                    'https://www.epa.gov/indoor-air-quality-iaq',
                  ),
                  _buildLearnCard(
                    'Climate Change',
                    'The connection between air quality and the environment',
                    'https://www.epa.gov/climate-change',
                  ),
                  _buildLearnCard(
                    'Children and Air Pollution',
                    'Special concerns for kids',
                    'https://www.epa.gov/children/protecting-childrens-health-and-environment',
                  ),
                  _buildLearnCard(
                    'Monitoring Air Quality',
                    'How air quality is tracked',
                    'https://www.airnow.gov/how-to-use-this-site/',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}