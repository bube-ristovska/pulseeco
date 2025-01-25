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
  final String description;

  SensorData({
    required this.sensorId,
    required this.position,
    required this.type,
    required this.value,
    required this.stamp,
    required this.description
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      sensorId: json['sensorId'] ?? '',
      position: json['position'] ?? '',
      type: json['type'] ?? '',
      value: json['value']?.toString() ?? '0',
      stamp: DateTime.parse(json['stamp']),
      description: json['description'] ?? 'test'
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
  static List<Map<String, dynamic>>? cachedRankings;

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
    final fromStr = formatDateTime(from);
    final toStr = formatDateTime(to);



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

  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final String formattedDate = formatter.format(dateTime.toLocal()); // Convert to local timezone
    final String offset = dateTime.timeZoneOffset.isNegative
        ? '-${dateTime.timeZoneOffset.abs().inHours.toString().padLeft(2, '0')}:${(dateTime.timeZoneOffset.abs().inMinutes % 60).toString().padLeft(2, '0')}'
        : '%2b${dateTime.timeZoneOffset.inHours.toString().padLeft(2, '0')}:${(dateTime.timeZoneOffset.inMinutes % 60).toString().padLeft(2, '0')}';

    return '$formattedDate$offset';
  }

  // Get daily average data for the last week
  static Future<Map<String, double>> getWeeklyData(City city, String type) async {
    DateTime now = DateTime.now();
    DateTime weekAgo = now.subtract(const Duration(days: 7));

    final data = await getHistoricalData(
        city,
        type,
        weekAgo, // Passing DateTime, not String
        now      // Passing DateTime, not String
    );
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

//ranking
  static Future<List<Map<String, dynamic>>> fetchPollutionRanking() async {
    // If rankings have already been fetched, return the cached result
    if (cachedRankings != null) {
      print("Returning cached rankings");
      return cachedRankings!;
    }

    List<Map<String, dynamic>> rankings = [];

    for (var city in cities) {
      try {
        // Fetch weekly data for the city
        final weeklyData = await getWeeklyData(city, "pm10");

        // If weekly data is available, calculate the weekly average
        if (weeklyData.isNotEmpty) {
          final values = weeklyData.values.where((value) => value > 0).toList();

          // Only calculate and add to rankings if valid values are present
          if (values.isNotEmpty) {
            final avgPM10 = values.reduce((a, b) => a + b) / values.length;

            rankings.add({
              'rank': 0, // Temporary rank placeholder
              'country': city.name,
              'value': avgPM10.toStringAsFixed(2),
            });

          }
        } else {
          // Log if no data was available for the city
          print('No data available for ${city.name}');
        }
      } catch (e) {
        // Log error for debugging purposes
        print('Error for ${city.name}: $e');
      }
    }

    rankings.sort((a, b) => double.parse(b['value']).compareTo(double.parse(a['value'])));
    for (int i = 0; i < rankings.length; i++) {
      rankings[i]['rank'] = i + 1;
    }

    // Store the fetched rankings for future use
    cachedRankings = rankings;

    return rankings;
  }


}


