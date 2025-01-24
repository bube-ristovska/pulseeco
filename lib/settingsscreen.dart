import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'yourdevicescreen.dart';
//hi
// These constants help us maintain consistent keys for storing settings
const String kNotificationsKey = 'notifications_enabled';
const String kLocationKey = 'location_enabled';
const String kNearestStationKey = 'nearest_station_only';
const String kLanguageKey = 'current_language';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  // State variables to track user preferences
  bool notificationsEnabled = false;
  bool locationEnabled = false;
  bool nearestStationOnly = false;
  String currentLanguage = 'EN';
  final List<String> languages = ['EN', 'MK', 'ES'];

  // Reference to SharedPreferences for persistent storage
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    // Initialize settings when the screen is created
    _loadSavedSettings();
    _checkCurrentPermissions();
  }

  Future<void> _loadSavedSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool(kNotificationsKey) ?? false;
      locationEnabled = prefs.getBool(kLocationKey) ?? false;
      nearestStationOnly = prefs.getBool(kNearestStationKey) ?? false;
      currentLanguage = prefs.getString(kLanguageKey) ?? 'EN';
    });
  }

  Future<void> _checkCurrentPermissions() async {
    final notificationStatus = await Permission.notification.status;
    final locationStatus = await Permission.location.status;

    setState(() {
      notificationsEnabled = notificationStatus.isGranted;
      locationEnabled = locationStatus.isGranted;
    });
  }

  Future<void> _handleNotificationChange(bool value) async {
    if (value) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        setState(() => notificationsEnabled = true);
        await prefs.setBool(kNotificationsKey, true);
      } else {
        _showPermissionSettingsDialog('Notification');
      }
    } else {
      setState(() => notificationsEnabled = false);
      await prefs.setBool(kNotificationsKey, false);
    }
  }

  Future<void> _handleLocationChange(bool value) async {
    if (value) {
      final status = await Permission.location.request();
      if (status.isGranted) {
        setState(() => locationEnabled = true);
        await prefs.setBool(kLocationKey, true);
      } else {
        _showPermissionSettingsDialog('Location');
      }
    } else {
      setState(() => locationEnabled = false);
      await prefs.setBool(kLocationKey, false);
    }
  }

  Future<void> _handleNearestStationChange(bool value) async {
    setState(() => nearestStationOnly = value);
    await prefs.setBool(kNearestStationKey, value);
  }

  Future<void> _handleLanguageChange(String? newValue) async {
    if (newValue != null) {
      setState(() => currentLanguage = newValue);
      await prefs.setString(kLanguageKey, newValue);
    }
  }

  Future<void> _showPermissionSettingsDialog(String permissionType) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('$permissionType Permission Required'),
        content: Text(
          'To use this feature, you need to enable $permissionType permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('OPEN SETTINGS'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetToDefault() async {
    setState(() {
      notificationsEnabled = false;
      locationEnabled = false;
      nearestStationOnly = false;
      currentLanguage = 'EN';
    });
    await prefs.clear();
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _navigateToYourDevice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const YourDeviceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Modified AppBar without the back button
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back button
        title: const Text('Settings'),
        centerTitle: true, // Centers the title for better appearance
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Notifications'),
                      subtitle: const Text('Receive updates and alerts'),
                      value: notificationsEnabled,
                      activeColor: const Color(0xFF1A237E),
                      onChanged: _handleNotificationChange,
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Current Location'),
                      subtitle: const Text('Allow access to your location'),
                      value: locationEnabled,
                      activeColor: const Color(0xFF1A237E),
                      onChanged: _handleLocationChange,
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Only nearest station'),
                      subtitle: const Text('Show data only from closest station'),
                      value: nearestStationOnly,
                      activeColor: const Color(0xFF1A237E),
                      onChanged: _handleNearestStationChange,
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Language'),
                      subtitle: const Text('Choose your preferred language'),
                      trailing: DropdownButton<String>(
                        value: currentLanguage,
                        items: languages.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: _handleLanguageChange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('About us'),
                subtitle: const Text('Learn more about our mission'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _launchUrl('https://pulse.eco/#about'),
              ),
              ListTile(
                title: const Text('FAQ'),
                subtitle: const Text('Get answers to common questions'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _launchUrl('https://pulse.eco/#howitworks'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  padding: const EdgeInsets.all(16),

                ),
                onPressed: _navigateToYourDevice,
                child: const Text(
                  'ADD YOUR DEVICE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: _resetToDefault,
                child: const Text('RESET TO DEFAULT SETTINGS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}