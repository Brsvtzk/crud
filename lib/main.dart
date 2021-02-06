import 'package:flutter/material.dart';
import 'package:crud/home_page.dart';

main() {
  runApp(AppCrudPessoa());
}

class AppCrudPessoa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
