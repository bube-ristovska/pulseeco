import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({Key? key}) : super(key: key);

  Widget _buildLearnCard(BuildContext context, String title, String subtitle, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14,left: 16,right: 16),
      color: const Color(0xFF1A237E),// Card color set to 0xFF1A237E
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LearnDetailScreen(
                title: title,
                content: content,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0), // Top padding set to 40 and others to 16
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity, // Makes the container take up the full width
            padding: const EdgeInsets.symmetric(vertical: 12.0), // Adds padding to top and bottom
            decoration: const BoxDecoration(
              color: const Color(0xFFEFE2EF) // Background color
            ),
            child: const Text(
              'Learn',
              textAlign: TextAlign.center, // Centers the text horizontally
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E), // Text color
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
                  context,
                  'What is Air Quality?',
                  'Learn about air quality basics',
                  'Air quality refers to the condition of the air around us. It is determined by measuring different pollutants including particulate matter (PM2.5 and PM10), nitrogen dioxide, sulfur dioxide, and ozone. Good air quality is essential for human health and the environment.\n\nPoor air quality can be caused by various factors such as:\n- Industrial emissions\n- Vehicle exhaust\n- Natural sources like wildfires\n- Agricultural activities',
                ),
                _buildLearnCard(
                  context,
                  'Air Quality Index',
                  'Understanding AQI measurements',
                  'The Air Quality Index (AQI) is a standardized system used to measure and communicate air pollution levels. The scale typically ranges from 0 to 500, with higher numbers indicating worse air quality.\n\nAQI Categories:\n- 0-50: Good (Green)\n- 51-100: Moderate (Yellow)\n- 101-150: Unhealthy for Sensitive Groups (Orange)\n- 151-200: Unhealthy (Red)\n- 201-300: Very Unhealthy (Purple)\n- 301-500: Hazardous (Maroon)',
                ),
                _buildLearnCard(
                  context,
                  'Health Impact',
                  'How air quality affects health',
                  'Poor air quality can have both short-term and long-term effects on human health. These impacts can vary from mild irritation to serious health conditions.\n\nCommon health effects include:\n- Respiratory issues\n- Cardiovascular problems\n- Eye and throat irritation\n- Headaches\n- Increased risk of certain cancers\n\nVulnerable groups such as children, elderly, and those with pre-existing conditions are particularly at risk.',
                ),
                _buildLearnCard(
                  context,
                  'Prevention',
                  'Ways to protect yourself',
                  'There are several ways to protect yourself from poor air quality:\n\n1. Check daily air quality reports\n2. Use air purifiers indoors\n3. Wear appropriate masks when necessary\n4. Avoid outdoor activities during high pollution periods\n5. Keep windows closed on high pollution days\n6. Maintain good ventilation indoors\n7. Regular cleaning to reduce indoor pollutants',
                ),
                _buildLearnCard(
                  context,
                  'Take Action',
                  'Steps to improve air quality',
                  'Everyone can contribute to improving air quality through simple actions:\n\n1. Use public transportation or carpool\n2. Reduce energy consumption\n3. Avoid burning leaves or trash\n4. Use environmentally friendly products\n5. Support clean air initiatives\n6. Plant trees and maintain green spaces\n7. Report air quality violations to local authorities',
                ),
                _buildLearnCard(
                  context,
                  'Sources of Air Pollution',
                  'Where pollutants come from',
                  'Air pollution comes from various sources:\n\n- Vehicles\n- Factories\n- Construction activities\n- Natural sources like volcanic eruptions and wildfires\n- Agriculture, including livestock emissions and crop burning.',
                ),
                _buildLearnCard(
                  context,
                  'Indoor Air Quality',
                  'Improving air quality at home',
                  'Indoor air quality can be improved by:\n\n1. Avoiding smoking indoors\n2. Using exhaust fans in kitchens and bathrooms\n3. Reducing the use of chemical cleaning products\n4. Regular maintenance of HVAC systems\n5. Keeping indoor plants for natural air purification.',
                ),
                _buildLearnCard(
                  context,
                  'Climate Change',
                  'The connection between air quality and the environment',
                  'Air quality is closely linked to climate change. For instance:\n\n- Greenhouse gases like CO2 contribute to global warming.\n- Warmer temperatures can worsen ozone pollution.\n- Efforts to reduce emissions also help mitigate climate change and improve air quality.',
                ),
                _buildLearnCard(
                  context,
                  'Children and Air Pollution',
                  'Special concerns for kids',
                  'Children are more vulnerable to air pollution because:\n\n- Their lungs are still developing.\n- They breathe more air per body weight compared to adults.\n- Exposure can lead to long-term health issues, such as asthma and reduced lung function.',
                ),
                _buildLearnCard(
                  context,
                  'Monitoring Air Quality',
                  'How air quality is tracked',
                  'Air quality is monitored using:\n\n- Stationary monitors in cities\n- Satellite observations\n- Portable air quality sensors for personal use\n\nThese devices measure pollutants and provide real-time data to inform the public.',
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

// learn_detail_screen.dart
class LearnDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const LearnDetailScreen({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Added margin inside
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}