import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({Key? key}) : super(key: key);

  Widget _buildLearnCard(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.indigo[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.article,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Learn',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildLearnCard(
                  'What is Air Quality?',
                  'Learn about air quality basics',
                ),
                _buildLearnCard(
                  'Air Quality Index',
                  'Understanding AQI measurements',
                ),
                _buildLearnCard(
                  'Health Impact',
                  'How air quality affects health',
                ),
                _buildLearnCard(
                  'Prevention',
                  'Ways to protect yourself',
                ),
                _buildLearnCard(
                  'Take Action',
                  'Steps to improve air quality',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}