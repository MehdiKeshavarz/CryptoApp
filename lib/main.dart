import 'package:flutter/material.dart';
import 'package:flutter_application_json/Screen/home_screen.dart';

void main() {
  runApp(Appliction());
}

class Appliction extends StatelessWidget {
  const Appliction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
