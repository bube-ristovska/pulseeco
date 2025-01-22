import 'package:flutter/material.dart';
//hi
class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final List<Map<String, dynamic>> topCountries = [
    {'rank': 1, 'country': 'Macedonia', 'value': '240'},
    {'rank': 2, 'country': 'India', 'value': '192'},
    {'rank': 3, 'country': 'Egypt', 'value': '115'},
    {'rank': 4, 'country': 'Germany', 'value': '95'},
    {'rank': 5, 'country': 'Austria', 'value': '85'},
    {'rank': 6, 'country': 'Austria', 'value': '82'},
    {'rank': 7, 'country': 'Denmark', 'value': '78'},
    {'rank': 8, 'country': 'Sweden', 'value': '75'},
  ];

  Widget buildCircle(Map<String, dynamic> data, bool isCenter) {
    final double size = isCenter ? 120.0 : 100.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF3A36DB),
            shape: BoxShape.circle,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Text(
                  data['value'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${data['rank']}',
                      style: const TextStyle(
                        color: Color(0xFF3A36DB),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data['country'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildListItem(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F3FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${data['rank']}',
                style: const TextStyle(
                  color: Color(0xFF3A36DB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            data['country'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F3FF),
      child: Column(
        children: [
          const SizedBox(height: 48),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Most polluted countries',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCircle(topCountries[1], false),  // India
              buildCircle(topCountries[0], true),   // Macedonia
              buildCircle(topCountries[2], false),  // Egypt
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: topCountries.length - 3, // Exclude top 3
              itemBuilder: (context, index) {
                return buildListItem(topCountries[index + 3]);
              },
            ),
          ),
        ],
      ),
    );
  }
}