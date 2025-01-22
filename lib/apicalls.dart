import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// hi
import 'cities.dart';
Future<Map<String, dynamic>?> fetchAirQualityData(String cityName) async {
  try {
    final url = Uri.parse('https://$cityName.pulse.eco/rest/overall');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a successful response, parse the JSON.
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      // If the server returns an error response, throw an exception.
      print('Failed to load air quality data');
      return null;
    }
  } catch (e) {
    print('Error occurred: $e');
    return null;
  }
}



class SensorData {
  final String sensorId;
  final String position;
  final String type;
  final String value;
  final DateTime stamp;

  SensorData({
    required this.sensorId,
    required this.position,
    required this.type,
    required this.value,
    required this.stamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      sensorId: json['sensorId'] ?? '',
      position: json['position'] ?? '',
      type: json['type'] ?? '',
      value: json['value']?.toString() ?? '0',
      stamp: DateTime.parse(json['stamp']),
    );
  }
}

class Sensor {
  final String sensorId;
  final String position;
  final String type;
  final String description;
  final String status;

  Sensor({
    required this.sensorId,
    required this.position,
    required this.type,
    required this.description,
    required this.status,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      sensorId: json['sensorId'] ?? '',
      position: json['position'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class ApiService {
  // Fetch all sensors for a specific city
  static Future<List<Sensor>> getSensors(City city) async {
    final response = await http.get(Uri.parse('${city.baseUrl}/rest/sensor'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData
          .map((data) => Sensor.fromJson(data))
          .where((sensor) => sensor.status == 'ACTIVE')
          .toList();
    } else {
      throw Exception('Failed to load sensors');
    }
  }

  // Fetch current data for all sensors in a city
  static Future<List<SensorData>> getCurrentData(City city) async {
    final response = await http.get(Uri.parse('${city.baseUrl}/rest/current'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => SensorData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load current data');
    }
  }

  // Fetch historical data for a specific type
  static Future<List<SensorData>> getHistoricalData(City city, String type, DateTime from, DateTime to) async {
    final fromStr = from.toUtc().toIso8601String();
    final toStr = to.toUtc().toIso8601String();

    final response = await http.get(
      Uri.parse('${city.baseUrl}/rest/dataRaw?type=$type&from=$fromStr&to=$toStr'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => SensorData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load historical data');
    }
  }

  // Get daily average data for the last week
  static Future<Map<String, double>> getWeeklyData(City city, String type) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final data = await getHistoricalData(city, type, weekAgo, now);

    // Group data by day and calculate averages
    Map<String, List<double>> dailyValues = {};

    for (var reading in data) {
      String day = DateFormat('EEE').format(reading.stamp);
      dailyValues[day] ??= [];
      if (double.tryParse(reading.value) != null) {
        dailyValues[day]!.add(double.parse(reading.value));
      }
    }

    // Calculate averages
    Map<String, double> dailyAverages = {};
    dailyValues.forEach((day, values) {
      if (values.isNotEmpty) {
        dailyAverages[day] = values.reduce((a, b) => a + b) / values.length;
      }
    });

    return dailyAverages;
  }
}