import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4dev',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
