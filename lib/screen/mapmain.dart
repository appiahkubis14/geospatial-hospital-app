// import 'package:flutter/material.dart';
// import 'package:hospital_locator/screen/map.dart';

// class MapView extends StatelessWidget {
//   const MapView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const String mapUrl =
//         "https://experience.arcgis.com/experience/971701bbb3114da8a12d56fa635da5d8/?draft=true#data_s=id%3A2a597782a55b4850a733aee88a6be807-191083b26d3-layer-2-191083b2b69-layer-9%3A204";

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Hospital Locator')),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const WebViewMap(url: mapUrl),
//                 ),
//               );
//             },
//             child: const Text('Discover More'),
//           ),
//         ),
//       ),
//     );
//   }
// }
