import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'homescreen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String selectedParticle = 'PM10';
  bool showBottomSheet = false;
  String selectedSensor = '';
  double bottomSheetHeight = 0;
  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  final List<LatLng> sensorLocations = [
    LatLng(41.9981, 21.4254),
    LatLng(41.9921, 21.4234),
    LatLng(41.9923, 21.4221),
  ];

  final List<String> particles = ['PM10', 'PM20', 'NOISE', 'TEMP', 'HUMID'];
  final List<String> weekDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  final List<String> values = ['45', '52', '48', '50', '47', '46', '49'];

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
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
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
                      children: particles.map((particle) {
                        bool isSelected = selectedParticle == particle;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedParticle = particle;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.indigo : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                particle,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(7, (index) {
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
                                  weekDays[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                values[index],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              center: LatLng(41.9981, 21.4254),
                              zoom: 13.0,
                              interactiveFlags: InteractiveFlag.all,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              MarkerLayer(
                                markers: List.generate(
                                  sensorLocations.length,
                                      (index) => Marker(
                                        point: sensorLocations[index],
                                        width: 36,
                                        height: 36,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedSensor = 'Sensor ${index + 1}';
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
                                      ),
                                ),
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
                                    final currentZoom = mapController.zoom;
                                    if (currentZoom < 18) {
                                      mapController.move(
                                        mapController.center,
                                        currentZoom + 1,
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.add),
                                ),
                                const SizedBox(height: 8),
                                FloatingActionButton(
                                  mini: true,
                                  heroTag: 'zoom_out',
                                  onPressed: () {
                                    final currentZoom = mapController.zoom;
                                    if (currentZoom > 0) {
                                      mapController.move(
                                        mapController.center,
                                        currentZoom - 1,
                                      );
                                    }
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
                          selectedSensor,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$selectedParticle: ${values[0]} μg/m³',
                          style: const TextStyle(
                            fontSize: 16,
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
    mapController.dispose();
    super.dispose();
  }
}
