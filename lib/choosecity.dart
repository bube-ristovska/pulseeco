import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cities.dart'; // Assuming City class and list of cities are defined here

class ChooseCityScreen extends StatefulWidget {
  const ChooseCityScreen({Key? key}) : super(key: key);

  @override
  _ChooseCityScreenState createState() => _ChooseCityScreenState();
}

class _ChooseCityScreenState extends State<ChooseCityScreen> {
  TextEditingController _searchController = TextEditingController();
  List<City> filteredCities = cities; // Initial list is the full city list
  List<String> savedCities = []; // To hold the saved cities from SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadSavedCities();
  }

  // Load saved cities from SharedPreferences
  void _loadSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedCities = prefs.getStringList('savedCities') ?? [];
    setState(() {
      savedCities = storedCities;
    });
  }

  // Filter cities based on search query
  void _filterCities(String query) {
    setState(() {
      filteredCities = cities.where((city) {
        final cityNameLower = city.name.toLowerCase();
        final cityCountryLower = city.country.toLowerCase();
        final searchLower = query.toLowerCase();

        return cityNameLower.contains(searchLower) ||
            cityCountryLower.contains(searchLower);
      }).toList();
    });
  }

  // Save city to SharedPreferences
  void _saveCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> updatedCities = List.from(savedCities);
    if (!updatedCities.contains(cityName)) {
      updatedCities.add(cityName);
      await prefs.setStringList('savedCities', updatedCities);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose a City',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              showSearch(
                context: context,
                delegate: CitySearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredCities.length,
        itemBuilder: (context, index) {
          final city = filteredCities[index];
          return ListTile(
            title: Text(city.name),
            subtitle: Text(city.country),
            onTap: () async {
              // Save selected city
              _saveCity(city.name);
              // Refresh saved cities list
              _loadSavedCities();

              // Return the selected city to the previous screen
              Navigator.pop(context, city);
            },
          );
        },
      ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search City';

  @override
  TextInputType get keyboardType => TextInputType.text;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = cities.where((city) {
      final cityNameLower = city.name.toLowerCase();
      final cityCountryLower = city.country.toLowerCase();
      final searchLower = query.toLowerCase();

      return cityNameLower.contains(searchLower) ||
          cityCountryLower.contains(searchLower);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final city = results[index];
        return ListTile(
          title: Text(city.name),
          subtitle: Text(city.country),
          onTap: () {
            Navigator.pop(context, city);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = cities.where((city) {
      final cityNameLower = city.name.toLowerCase();
      final cityCountryLower = city.country.toLowerCase();
      final searchLower = query.toLowerCase();

      return cityNameLower.contains(searchLower) ||
          cityCountryLower.contains(searchLower);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final city = suggestions[index];
        return ListTile(
          title: Text(city.name),
          subtitle: Text(city.country),
          onTap: () {
            Navigator.pop(context, city);
          },
        );
      },
    );
  }
}
