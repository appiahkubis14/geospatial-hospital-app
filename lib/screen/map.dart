// // ignore_for_file: must_be_immutable, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// class WebViewMap extends StatefulWidget {
//   final String url;
//   const WebViewMap({super.key, required this.url});

//   @override
//   _WebViewMapState createState() => _WebViewMapState();
// }

// class _WebViewMapState extends State<WebViewMap> {
//   final FlutterWebviewPlugin _webviewPlugin = FlutterWebviewPlugin();

//   @override
//   void initState() {
//     super.initState();

//     _webviewPlugin.onStateChanged.listen(
//       (state) {
//         if (state.type == WebViewState.finishLoad) {
//           _webviewPlugin.evalJavascript('''
          
//           if (window.document) {
//             window.document.documentElement.style.webkitTouchCallout='none';
//             window.document.documentElement.style.webkitUserSelect='none';
//             window.document.documentElement.style.webkitTextSizeAdjust='none';
//           }
//         ''');
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _webviewPlugin.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 25.0),
//       child: WebviewScaffold(
//         url: widget.url,
//       ),
//     );
//   }
// }
