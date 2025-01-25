import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'choosecity.dart';
import 'cities.dart';
import 'apicalls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Needed to encode/decode city objects
//hi
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<City> selectedCities=[];
  @override
  void initState() {
    super.initState();
    _loadCitiesFromPrefs(); // Load saved cities on startup
  }

  Map<String, Map<String, dynamic>> airQualityDataMap = {};
  bool isLoading = false;
  void _loadCitiesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cityList=prefs.getStringList('selectedCities');

    if (cityList != null) {
      setState(() {
        selectedCities = cityList.map((cityJson) => City.fromMap(jsonDecode(cityJson))).toList();
      });
    }
    await _fetchAllCitiesData();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the main city from route arguments
    final mainCity = ModalRoute.of(context)?.settings.arguments as City?;
    if (mainCity != null && selectedCities.isEmpty) {
      setState(() {
        selectedCities = [mainCity];


      });
      _fetchAllCitiesData();
    }else if (selectedCities.isNotEmpty && airQualityDataMap.isEmpty) {
      // Fetch data if cities are loaded but no data exists
      _fetchAllCitiesData();
    }
  }

  Future<void> _fetchAllCitiesData() async {
    setState(() {
      isLoading = true;
    });

    for (var city in selectedCities) {
      await _fetchCityData(city);
    }

    setState(() {
      isLoading = false;
    });
  }

  void _saveCitiesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cityList = selectedCities.map((city) => jsonEncode(city.toMap())).toList();
    await prefs.setStringList('selectedCities', cityList);
  }

  Future<void> _fetchCityData(City city) async { // Changed to Future<void>
    try {
      final data = await fetchAirQualityData(city.name);
      setState(() {
        airQualityDataMap[city.name] = data!;
        _saveCitiesToPrefs(); // Save updated list
      });
    } catch (e) {
      print('Error fetching data for ${city.name}: $e');
    }
  }

  void _removeCity(City city) {
    if (selectedCities.indexOf(city) == 0) return;
    setState(() {
      selectedCities.remove(city);
      airQualityDataMap.remove(city.name);
      _saveCitiesToPrefs(); // Save updated list
    });
  }

  Widget _buildAirQualityInfo(Map<String, dynamic> data) {
    final values = data['values'] as Map<String, dynamic>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (values['temperature'] != null)
          Text('Temperature: ${values['temperature']}°C',
              style: const TextStyle(color: Colors.white)),
        if (values['humidity'] != null)
          Text('Humidity: ${values['humidity']}%',
              style: const TextStyle(color: Colors.white)),
        if (values['pm25'] != null)
          Text('PM2.5: ${values['pm25']} µg/m³',
              style: const TextStyle(color: Colors.white)),
        if (values['pm10'] != null)
          Text('PM10: ${values['pm10']} µg/m³',
              style: const TextStyle(color: Colors.white)),
        if (values['no2'] != null)
          Text('NO₂: ${values['no2']} µg/m³',
              style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: selectedCities.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Add City button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cities',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final City? city = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChooseCityScreen(),
                        ),
                      );
                      if (city != null && !selectedCities.contains(city)) {
                        setState(() {
                          selectedCities.add(city);
                        });
                        _fetchCityData(city);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add City'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A237E),
                      side: const BorderSide(color: Color(0xFF1A237E)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Main city map
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: MapOptions(
                      center: selectedCities[0].coordinates,
                      zoom: 12.0,
                    ),
                    nonRotatedChildren: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: selectedCities[0].coordinates,
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
                ),
              ),

              // Add this new Row widget
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/mapscreen',
                          arguments: selectedCities.first,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: Color(0xFF1A237E),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'View Full Map',
                            style: TextStyle(
                              color: Color(0xFF1A237E),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Cities list
              Expanded(
                child: ListView.builder(
                  itemCount: selectedCities.length,
                  itemBuilder: (context, index) {
                    final city = selectedCities[index];
                    final cityData = airQualityDataMap[city.name];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A237E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            city.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (index == 0)
                                            const Padding(
                                              padding: EdgeInsets.only(left: 8.0),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                                size: 20,
                                              ),
                                            ),
                                        ],
                                      ),
                                      Text(
                                        city.country,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (index > 0) // Only show delete for additional cities
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () => _removeCity(city),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (isLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            else if (cityData != null)
                              _buildAirQualityInfo(cityData)
                            else
                              const Text(
                                'No data available',
                                style: TextStyle(color: Colors.white70),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}