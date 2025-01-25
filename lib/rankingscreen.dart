import 'package:flutter/material.dart';
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
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRankings();
  }

  Future<void> _fetchRankings() async {
    try {
      setState(() => isLoading = true);
      final rankings = await ApiService.fetchPollutionRanking();

      setState(() {
        topCities = rankings;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load rankings. Please check your connection.';
        isLoading = false;
      });
      print('Error fetching rankings: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF3A36DB),
          strokeWidth: 4.0,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
            ElevatedButton(
              onPressed: _fetchRankings,
              child: const Text('Retry'),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      body: RefreshIndicator(
        onRefresh: _fetchRankings,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text(
                'Most Polluted Cities',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: const Color(0xFFF4F3FF),
              floating: true,
            ),
            SliverToBoxAdapter(
              child: _topCitiesSection(),
            ),
            _rankingListSection(),
          ],
        ),
      ),
    );
  }

  Widget _topCitiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (topCities.length > 1) _cityCircle(topCities[1], false),
          if (topCities.isNotEmpty) _cityCircle(topCities[0], true),
          if (topCities.length > 2) _cityCircle(topCities[2], false),
        ],
      ),
    );
  }

  Widget _cityCircle(Map<String, dynamic> city, bool isCenter) {
    return Column(
      children: [
        Container(
          width: isCenter ? 120 : 100,
          height: isCenter ? 120 : 100,
          decoration: BoxDecoration(
            color: const Color(0xFF3A36DB),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
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
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            city['country'],
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  SliverList _rankingListSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => _rankingListItem(topCities[index + 3]),
        childCount: topCities.length > 3 ? topCities.length - 3 : 0,
      ),
    );
  }

  Widget _rankingListItem(Map<String, dynamic> city) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF4F3FF),
          child: Text(
            '${city['rank']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          city['country'],
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Text(
          city['value'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}