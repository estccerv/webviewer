// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<int> topSafeAreaHeight(BuildContext context) async {
  // return a height of top Safe Area

  // Get the top padding of the SafeArea
  double topPadding = MediaQuery.of(context).padding.top;

  // Return the height of the top SafeArea
  return topPadding.toInt();
}
