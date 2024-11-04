// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncherScreen extends StatefulWidget {
  const URLLauncherScreen({super.key});

  @override
  _URLLauncherScreenState createState() => _URLLauncherScreenState();
}

class _URLLauncherScreenState extends State<URLLauncherScreen> {
  // final TextEditingController _urlController = TextEditingController();

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.externalApplication,
          browserConfiguration: const BrowserConfiguration(),
          webViewConfiguration: const WebViewConfiguration());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open URL Launcher'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                const url = 'https://experience.arcgis.com/experience/971701bbb3114da8a12d56fa635da5d8/';
                if (url.isNotEmpty) {
                  _launchURL(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide a valid URL')),
                  );
                }
              },
              child: const Text('Open URL'),
            ),
          ],
        ),
      ),
    );
  }
}
