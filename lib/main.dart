import 'package:flutter/material.dart';
import 'package:crud/home_page.dart';

main() {
  runApp(AppClima());
}

class AppClima extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        theme: ThemeData(
          accentColor: Colors.cyan[600],
          primaryColor: Colors.lightBlue[300],
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
