import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'choosecity.dart';
import 'cities.dart';
import 'apicalls.dart';
import 'mapscreen.dart'; // Import the API call function

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<City> selectedCities = [cities[0]]; // Default with the first city in cities
  Map<String, dynamic>? airQualityData;

  @override
  void initState() {
    super.initState();
    _fetchAirQualityData(selectedCities[0].name); // Fetch data for the default city
  }

  // Function to fetch air quality data for a specific city
  Future<void> _fetchAirQualityData(String cityName) async {
    final data = await fetchAirQualityData(cityName);
    setState(() {
      airQualityData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0, bottom: 16.0),
      child: SingleChildScrollView( // Wrap Column with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Add City button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cities', // The title for the city list
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final City? city = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChooseCityScreen(),
                      ),
                    );
                    if (city != null) {
                      setState(() {
                        selectedCities.add(city); // Add the selected city to the list
                      });
                      _fetchAirQualityData(city.name); // Fetch data for the new city
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(color: Color(0xFF1A237E)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add City',
                        style: TextStyle(color: Color(0xFF1A237E)),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.add,
                        size: 20,
                        color: Color(0xFF1A237E),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Loop through each selected city and display a card for each one
            ...selectedCities.map((city) {
              return Column(
                children: [
                  // Air Quality Card for the city
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1a237e), // Dark blue color
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.name, // Display city name
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          city.country, // Display city country
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Display Air Quality Data here for the city
                        airQualityData == null
                            ? const CircularProgressIndicator()
                            : Column(
                          children: [
                            if (airQualityData!['values']['temperature'] != null)
                              Text(
                                'Temperature: ${airQualityData!['values']['temperature']} °C',
                                style: const TextStyle(color: Colors.white),
                              ),
                            if (airQualityData!['values']['no2'] != null)
                              Text(
                                'NO2: ${airQualityData!['values']['no2']} µg/m³',
                                style: const TextStyle(color: Colors.white),
                              ),
                            if (airQualityData!['values']['o3'] != null)
                              Text(
                                'O3: ${airQualityData!['values']['o3']} µg/m³',
                                style: const TextStyle(color: Colors.white),
                              ),
                            if (airQualityData!['values']['pm25'] != null)
                              Text(
                                'PM2.5: ${airQualityData!['values']['pm25']} µg/m³',
                                style: const TextStyle(color: Colors.white),
                              ),
                            if (airQualityData!['values']['pm10'] != null)
                              Text(
                                'PM10: ${airQualityData!['values']['pm10']} µg/m³',
                                style: const TextStyle(color: Colors.white),
                              ),
                            if (airQualityData!['values']['humidity'] != null)
                              Text(
                                'Humidity: ${airQualityData!['values']['humidity']} %',
                                style: const TextStyle(color: Colors.white),
                              ),
                            if (airQualityData!['values']['pressure'] != null)
                              Text(
                                'Pressure: ${airQualityData!['values']['pressure']} hPa',
                                style: const TextStyle(color: Colors.white),
                              ),
                            if (airQualityData!['values']['noise_dba'] != null)
                              Text(
                                'Noise: ${airQualityData!['values']['noise_dba']} dBA',
                                style: const TextStyle(color: Colors.white),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Map Card for the city
                  GestureDetector(
                    onTap: () {
                      // Navigate to Map screen with the city coordinates
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MapScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Map',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  // Force map to rebuild when city changes using a ValueKey
                                  FlutterMap(
                                    key: ValueKey(city.coordinates), // Use ValueKey to trigger rebuild
                                    options: MapOptions(
                                      center: city.coordinates, // Coordinates from the city
                                      zoom: 12.0,
                                      interactiveFlags: InteractiveFlag.none,
                                    ),
                                    nonRotatedChildren: [
                                      TileLayer(
                                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            point: city.coordinates, // Use city's coordinates
                                            width: 36,
                                            height: 36,
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                              size: 36,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ], children: [],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
