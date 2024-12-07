import 'package:flutter/material.dart';
import 'city.dart';  // Import the City model class
class City {
  final String name;

  City(this.name);
}

class CityListScreen extends StatelessWidget {
  const CityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A simple list of cities for demo purposes
    final List<City> cities = [
      City('Skopje'),
      City('Belgrade'),
      City('Zagreb'),
      City('Ljubljana'),
      City('Sarajevo'),
      City('Podgorica'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a City"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(cities[index].name),
              onTap: () {
                Navigator.pop(context, cities[index].name); // Pass selected city back
              },
            ),
          );
        },
      ),
    );
  }
}
