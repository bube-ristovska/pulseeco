import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'main.dart';
import 'cities.dart'; // Assuming City class and list of cities are defined in city.dart
//hi
class ChooseCityScreen extends StatefulWidget {
  const ChooseCityScreen({Key? key}) : super(key: key);

  @override
  _ChooseCityScreenState createState() => _ChooseCityScreenState();
}

class _ChooseCityScreenState extends State<ChooseCityScreen> {
  TextEditingController _searchController = TextEditingController();
  List<City> filteredCities = cities; // Initial list is the full city list

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose a City',
          style: TextStyle(color: Colors.white), // Set the title text color to white
        ),
        backgroundColor: const Color(0xFF1A237E),
        iconTheme: const IconThemeData(color: Colors.white), // Set all icons in the app bar to white
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white, // Set the search icon color to white
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
            onTap: () {
              Navigator.pop(context, city); // Passing the selected city back to the home screen
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
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white, // Set the back arrow icon color to white
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
