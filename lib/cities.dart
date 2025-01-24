import 'dart:convert';

import 'package:latlong2/latlong.dart';
//hi
class City {
  final String name;
  final String country;
  final LatLng coordinates;
  final String baseUrl;

  City({required this.name, required this.country, required this.coordinates, required this.baseUrl});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'country': country,
      'baseUrl': baseUrl,
      'lat': coordinates.latitude,
      'lng': coordinates.longitude,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      name: map['name'],
      country: map['country'],
      baseUrl: map['baseUrl'],
      coordinates: LatLng(map['lat'], map['lng']),
    );
  }
  // Converts a City instance to a JSON string
  String toJson() => json.encode(toMap());

  // Converts a JSON string to a City instance
  factory City.fromJson(String source) => City.fromMap(json.decode(source));
}
// class City {
//   final String name;
//   final String country;
//   final String baseUrl;
//   final LatLng coordinates;
//
//   City({
//     required this.name,
//     required this.country,
//     required this.baseUrl,
//     required this.coordinates,
//   });
// }

final List<City> cities = [
  // Macedonia Cities
  City(
    name: 'Skopje',
    country: 'Macedonia',
    baseUrl: 'https://skopje.pulse.eco',
    coordinates: const LatLng(41.9981, 21.4254),
  ),
  City(
    name: 'Novo Selo',
    country: 'Macedonia',
    baseUrl: 'https://novoselo.pulse.eco',
    coordinates: const LatLng(41.635, 22.350),
  ),
  City(
    name: 'Struga',
    country: 'Macedonia',
    baseUrl: 'https://struga.pulse.eco',
    coordinates: const LatLng(41.182, 20.678),
  ),
  City(
    name: 'Bitola',
    country: 'Macedonia',
    baseUrl: 'https://bitola.pulse.eco',
    coordinates: const LatLng(41.031, 21.331),
  ),
  City(
    name: 'Star Dojran',
    country: 'Macedonia',
    baseUrl: 'https://stardojran.pulse.eco',
    coordinates: const LatLng(41.153, 22.684),
  ),
  City(
    name: 'Shtip',
    country: 'Macedonia',
    baseUrl: 'https://shtip.pulse.eco',
    coordinates: const LatLng(41.733, 22.200),
  ),
  City(
    name: 'Tetovo',
    country: 'Macedonia',
    baseUrl: 'https://tetovo.pulse.eco',
    coordinates: const LatLng(42.004, 20.964),
  ),
  City(
    name: 'Gostivar',
    country: 'Macedonia',
    baseUrl: 'https://gostivar.pulse.eco',
    coordinates: const LatLng(41.780, 20.899),
  ),
  City(
    name: 'Ohrid',
    country: 'Macedonia',
    baseUrl: 'https://ohrid.pulse.eco',
    coordinates: LatLng(41.118, 20.801),
  ),
  City(
    name: 'Resen',
    country: 'Macedonia',
    baseUrl: 'https://resen.pulse.eco',
    coordinates: LatLng(41.000, 21.400),
  ),
  City(
    name: 'Kumanovo',
    country: 'Macedonia',
    baseUrl: 'https://kumanovo.pulse.eco',
    coordinates: LatLng(42.134, 21.711),
  ),
  City(
    name: 'Strumica',
    country: 'Macedonia',
    baseUrl: 'https://strumica.pulse.eco',
    coordinates: LatLng(41.440, 22.640),
  ),
  City(
    name: 'Radovish',
    country: 'Macedonia',
    baseUrl: 'https://radovis.pulse.eco',
    coordinates: LatLng(41.438, 22.577),
  ),
  City(
    name: 'Bogdanci',
    country: 'Macedonia',
    baseUrl: 'https://bogdanci.pulse.eco',
    coordinates: LatLng(41.260, 22.690),
  ),
  City(
    name: 'Kichevo',
    country: 'Macedonia',
    baseUrl: 'https://kichevo.pulse.eco',
    coordinates: LatLng(41.508, 20.955),
  ),
  // Albania City
  City(
    name: 'Tirana',
    country: 'Albania',
    baseUrl: 'https://tirana.pulse.eco',
    coordinates: LatLng(41.3275, 19.8189),
  ),
  // Bulgaria Cities
  City(
    name: 'Sofia',
    country: 'Bulgaria',
    baseUrl: 'https://sofia.pulse.eco',
    coordinates: LatLng(42.6977, 23.3219),
  ),
  City(
    name: 'Yambol',
    country: 'Bulgaria',
    baseUrl: 'https://yambol.pulse.eco',
    coordinates: LatLng(42.500, 26.510),
  ),
  // Croatia City
  City(
    name: 'Zagreb',
    country: 'Croatia',
    baseUrl: 'https://zagreb.pulse.eco/',
    coordinates: LatLng(45.8150, 15.978),
  ),
  // Cyprus City
  City(
    name: 'Nicosia',
    country: 'Cyprus',
    baseUrl: 'https://nicosia.pulse.eco',
    coordinates: LatLng(35.185, 33.382),
  ),
  // Denmark City
  City(
    name: 'Copenhagen',
    country: 'Denmark',
    baseUrl: 'https://copenhagen.pulse.eco/',
    coordinates: LatLng(55.6761, 12.5683),
  ),
  // Germany Cities
  City(
    name: 'Berlin',
    country: 'Germany',
    baseUrl: 'https://berlin.pulse.eco',
    coordinates: LatLng(52.5200, 13.4050),
  ),
  City(
    name: 'Magdeburg',
    country: 'Germany',
    baseUrl: 'https://magdeburg.pulse.eco',
    coordinates: LatLng(52.120, 11.627),
  ),
  // Greece Cities
  City(
    name: 'Syros',
    country: 'Greece',
    baseUrl: 'https://syros.pulse.eco/',
    coordinates: LatLng(37.436, 24.922),
  ),
  City(
    name: 'Thessaloniki',
    country: 'Greece',
    baseUrl: 'https://thessaloniki.pulse.eco',
    coordinates: LatLng(40.6401, 22.9444),
  ),
  // Ireland City
  City(
    name: 'Cork',
    country: 'Ireland',
    baseUrl: 'https://cork.pulse.eco',
    coordinates: LatLng(51.897, -8.470),
  ),
  // Moldova City
  City(
    name: 'Chișinău',
    country: 'Moldova',
    baseUrl: 'https://chisinau.pulse.eco/',
    coordinates: LatLng(47.0105, 28.8638),
  ),
  // Netherlands Cities
  City(
    name: 'Delft',
    country: 'Netherlands',
    baseUrl: 'https://delft.pulse.eco/',
    coordinates: LatLng(52.0116, 4.3573),
  ),
  City(
    name: 'Amsterdam',
    country: 'Netherlands',
    baseUrl: 'https://amsterdam.pulse.eco/',
    coordinates: LatLng(52.3676, 4.9041),
  ),
  // Romania Cities
  City(
    name: 'Bucharest',
    country: 'Romania',
    baseUrl: 'https://bucharest.pulse.eco/',
    coordinates: LatLng(44.4268, 26.1025),
  ),
  City(
    name: 'Targu Mures',
    country: 'Romania',
    baseUrl: 'https://targumures.pulse.eco/',
    coordinates: LatLng(46.5415, 24.5859),
  ),
  City(
    name: 'Sacele',
    country: 'Romania',
    baseUrl: 'https://sacele.pulse.eco/',
    coordinates: LatLng(45.6064, 25.6619),
  ),
  City(
    name: 'Codlea',
    country: 'Romania',
    baseUrl: 'https://codlea.pulse.eco/',
    coordinates: LatLng(45.6361, 25.5375),
  ),
  City(
    name: 'Roman',
    country: 'Romania',
    baseUrl: 'https://roman.pulse.eco/',
    coordinates: LatLng(45.899, 26.925),
  ),
  City(
    name: 'Cluj-Napoca',
    country: 'Romania',
    baseUrl: 'https://cluj-napoca.pulse.eco',
    coordinates: LatLng(46.7705, 23.5897),
  ),
  City(
    name: 'Oradea',
    country: 'Romania',
    baseUrl: 'https://oradea.pulse.eco/',
    coordinates: LatLng(47.0722, 21.9268),
  ),
  City(
    name: 'Iasi',
    country: 'Romania',
    baseUrl: 'https://iasi.pulse.eco/',
    coordinates: LatLng(47.1595, 27.601),
  ),
  City(
    name: 'Ramnicu-Valcea',
    country: 'Romania',
    baseUrl: 'https://ramnicu-valcea.pulse.eco',
    coordinates: LatLng(45.0999, 24.3683),
  ),
  City(
    name: 'Brasov',
    country: 'Romania',
    baseUrl: 'https://brasov.pulse.eco/',
    coordinates: LatLng(45.659, 25.610),
  ),
  // Serbia City
  City(
    name: 'Nis',
    country: 'Serbia',
    baseUrl: 'https://nis.pulse.eco',
    coordinates: LatLng(43.3206, 21.8954),
  ),
  // Switzerland Cities
  City(
    name: 'Lausanne',
    country: 'Switzerland',
    baseUrl: 'https://lausanne.pulse.eco/',
    coordinates: LatLng(46.5197, 6.6323),
  ),
  City(
    name: 'Zuchwil',
    country: 'Switzerland',
    baseUrl: 'https://zuchwil.pulse.eco/',
    coordinates: LatLng(47.199, 7.565),
  ),
  City(
    name: 'Bern',
    country: 'Switzerland',
    baseUrl: 'https://bern.pulse.eco/',
    coordinates: LatLng(46.948, 7.447),
  ),
  City(
    name: 'Luzern',
    country: 'Switzerland',
    baseUrl: 'https://luzern.pulse.eco/',
    coordinates: LatLng(47.0502, 8.3093),
  ),
  City(
    name: 'Grenchen',
    country: 'Switzerland',
    baseUrl: 'https://grenchen.pulse.eco',
    coordinates: LatLng(47.189, 7.401),
  ),
  City(
    name: 'Zurich',
    country: 'Switzerland',
    baseUrl: 'https://zurich.pulse.eco/',
    coordinates: LatLng(47.3769, 8.5417),
  ),
  // USA Cities
  City(
    name: 'Grand Rapids',
    country: 'USA',
    baseUrl: 'https://grand-rapids.pulse.eco/',
    coordinates: LatLng(42.9634, -85.6681),
  ),
  City(
    name: 'Portland',
    country: 'USA',
    baseUrl: 'https://portland.pulse.eco/',
    coordinates: LatLng(45.5122, -122.6587),
  ),
];
