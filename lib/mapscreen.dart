import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'apicalls.dart';
import 'cities.dart';

class MapScreen extends StatefulWidget {
  final bool isFromMenu;
  const MapScreen({Key? key, this.isFromMenu = false}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  String selectedParticle = 'pm10';
  bool showBottomSheet = false;
  String selectedSensor = '';
  double bottomSheetHeight = 0;
  late final MapController mapController;
  List<City> selectedCities = [];
  City? selectedCity;
  List<Sensor> sensors = [];
  List<SensorData> currentData = [];
  Map<String, double> weeklyData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
     mapController=MapController();
    _loadCities(); // Load cities from SharedPreferences
  }

  Future<void> _loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    final cityData = prefs.getStringList('selectedCities');
    if (cityData != null) {
      setState(() {
        selectedCities = cityData.map((e) => City.fromJson(e)).toList();
        if (selectedCities.isNotEmpty) {
          selectedCity = selectedCities.first;
          loadData();
        }
      });
    }
  }

  Future<void> _saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    final cityData = selectedCities.map((city) => city.toJson()).toList();
    await prefs.setStringList('selectedCities', cityData);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final City city = ModalRoute
        .of(context)
        ?.settings
        .arguments as City;
    if (cities != null && selectedCities.isEmpty) {
      selectedCities = [city, ... cities.where((c) => c != city)];
      selectedCity = selectedCities.first;
      _saveCities(); // Save cities to SharedPreferences
      if (mounted) {
        loadData();
      }
    }
  }

  Future<void> loadData() async {
    if (selectedCity == null) return;

    setState(() => isLoading = true);
    try {
      final sensorsData = await ApiService.getSensors(selectedCity!);
      final currentSensorData = await ApiService.getCurrentData(selectedCity!);
      final weeklyDataResult = await ApiService.getWeeklyData(
          selectedCity!, selectedParticle);

      if (!mounted) return; // Avoid calling setState if the widget is disposed

      setState(() {
        sensors = sensorsData;
        currentData = currentSensorData;
        weeklyData = weeklyDataResult;
        isLoading = false;
      });

      if (sensors.isNotEmpty) {
        try{
        final firstSensor = sensors[0];
        final position = firstSensor.position.split(',');
        if (!mounted) return; // Avoid mapController move if widget is disposed

        mapController.move(
          LatLng(double.parse(position[0]), double.parse(position[1])),
          13.0,
        );}
            catch(e){
              print('Map controller initialization error:$e');
            }

      }
    } catch (e) {
      if (!mounted) return; // Avoid calling setState if the widget is disposed

      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!widget.isFromMenu)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      else const  SizedBox(width: 48),
                      // City Selection Dropdown
                      if (selectedCities.isNotEmpty)
                        DropdownButton<City>(
                          value: selectedCity,
                          items: selectedCities.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(city.name),
                            );
                          }).toList(),
                          onChanged: (City? newCity) {
                            if (newCity != null) {
                              setState(() {
                                selectedCity = newCity;
                              });
                              loadData();
                            }
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.language),
                        onPressed: () {
                          // Language selection logic
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['pm10', 'pm25', 'no2', 'o3', 'co'].map((
                          particle) {
                        bool isSelected = selectedParticle == particle;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedParticle = particle;
                              });
                              loadData();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.indigo : Colors
                                    .grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                particle.toUpperCase(),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors
                                      .black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (weeklyData.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: weeklyData.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entry.value.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          if (isLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                center: selectedCity?.coordinates ??
                                    const LatLng(41.9981, 21.4254),
                                zoom: 13.0,
                                interactiveFlags: InteractiveFlag.all,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                ),
                                MarkerLayer(
                                  markers: sensors.map((sensor) {
                                    final position = sensor.position.split(',');
                                    return Marker(
                                      point: LatLng(
                                        double.parse(position[0]),
                                        double.parse(position[1]),
                                      ),
                                      width: 36,
                                      height: 36,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedSensor = sensor.sensorId;
                                            showBottomSheet = true;
                                            bottomSheetHeight = 200;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.indigo,
                                          size: 36,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Column(
                              children: [
                                FloatingActionButton(
                                  mini: true,
                                  heroTag: 'zoom_in',
                                  onPressed: () {
                                    final currentZoom = mapController!.zoom;
                                    mapController!.move(
                                      mapController!.center,
                                      currentZoom + 1,
                                    );
                                  },
                                  child: const Icon(Icons.add),
                                ),
                                const SizedBox(height: 8),
                                FloatingActionButton(
                                  mini: true,
                                  heroTag: 'zoom_out',
                                  onPressed: () {
                                    final currentZoom = mapController!.zoom;
                                    mapController!.move(
                                      mapController!.center,
                                      currentZoom - 1,
                                    );
                                  },
                                  child: const Icon(Icons.remove),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showBottomSheet)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      bottomSheetHeight -= details.delta.dy;
                      bottomSheetHeight = bottomSheetHeight.clamp(0.0, 300.0);
                      if (bottomSheetHeight < 50) showBottomSheet = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: bottomSheetHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Text(
                          'Sensor: $selectedSensor',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (currentData.isNotEmpty)
                          Text(
                            '${selectedParticle.toUpperCase()}: ${currentData
                                .firstWhere(
                                  (data) => data.sensorId == selectedSensor,
                              orElse: () => currentData.first,
                            )
                                .value} μg/m³',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          'Last updated: ${DateFormat('MMM dd, HH:mm').format(
                            currentData
                                .firstWhere(
                                  (data) => data.sensorId == selectedSensor,
                              orElse: () => currentData.first,
                            )
                                .stamp
                                .toLocal(),
                          )}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    mapController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      mapController.dispose();
    }
  }
}