// File: settingsscreen.dart

import 'package:flutter/material.dart';
import 'yourdevicescreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;
  bool locationEnabled = false;
  bool nearestStationOnly = false;
  String currentLanguage = 'EN';

  final List<String> languages = ['EN', 'MK', 'ES'];

  void _handleNotificationChange(bool value) {
    setState(() {
      notificationsEnabled = value;
    });
  }

  void _handleLocationChange(bool value) {
    setState(() {
      locationEnabled = value;
    });
  }

  void _resetToDefault() {
    setState(() {
      notificationsEnabled = false;
      locationEnabled = false;
      nearestStationOnly = false;
      currentLanguage = 'EN';
    });
  }

  void _navigateToYourDevice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const YourDeviceScreen(),
      ),
    );
  }

  void _openWebPage(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $type page...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
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
                      value: notificationsEnabled,
                      onChanged: _handleNotificationChange,
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Current Location'),
                      value: locationEnabled,
                      onChanged: _handleLocationChange,
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Only nearest station'),
                      value: nearestStationOnly,
                      onChanged: (value) {
                        setState(() => nearestStationOnly = value);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Language'),
                      trailing: DropdownButton<String>(
                        value: currentLanguage,
                        items: languages.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => currentLanguage = newValue);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('About us'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _openWebPage('About'),
              ),
              ListTile(
                title: const Text('FAQ'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _openWebPage('FAQ'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
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