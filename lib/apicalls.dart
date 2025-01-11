import 'dart:convert';
import 'package:http/http.dart' as http;

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
