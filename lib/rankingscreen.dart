import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show compute;
import 'dart:convert';
import 'apicalls.dart';
import 'cities.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Map<String, dynamic>> topCities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRankings();
  }

  Future<void> _fetchRankings() async {
    try {
      final rankings = await ApiService.fetchPollutionRanking();
      setState(() {
        topCities = rankings;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Most Polluted Cities',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _topCitiesSection(),
          _rankingListSection(),
        ],
      ),
    );
  }

  Widget _topCitiesSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (topCities.length > 1) _cityCircle(topCities[1], false),
        if (topCities.isNotEmpty) _cityCircle(topCities[0], true),
        if (topCities.length > 2) _cityCircle(topCities[2], false),
      ],
    );
  }

  Widget _cityCircle(Map<String, dynamic> city, bool isCenter) {
    return Column(
      children: [
        Container(
          width: isCenter ? 120 : 100,
          height: isCenter ? 120 : 100,
          decoration: const BoxDecoration(
            color: Color(0xFF3A36DB),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              city['value'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(city['country']),
      ],
    );
  }

  Widget _rankingListSection() {
    return Expanded(
      child: ListView.builder(
        itemCount: topCities.length > 3 ? topCities.length - 3 : 0,
        itemBuilder: (context, index) => _rankingListItem(topCities[index + 3]),
      ),
    );
  }

  Widget _rankingListItem(Map<String, dynamic> city) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFF4F3FF),
        child: Text('${city['rank']}'),
      ),
      title: Text(city['country']),
      trailing: Text(city['value']),
    );
  }
}