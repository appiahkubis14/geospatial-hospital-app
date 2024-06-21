import 'package:flutter/material.dart';
import 'package:hospitalmap/screens/map.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    const String mapUrl =
        "https://accugeo.maps.arcgis.com/apps/webappviewer/index.html?id=863e254d0ce0497d93f696c57d28daf9";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('ArcGIS Map')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebViewMap(url: mapUrl),
                ),
              );
            },
            child: const Text('Open Map'),
          ),
        ),
      ),
    );
  }
}
