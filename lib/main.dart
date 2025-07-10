import 'package:flutter/material.dart';
import 'package:origi/attraclogi.dart';

import 'package:http/http.dart' as http;
import 'package:origi/attracregi.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      home: ALoginPage(),
    );
  }
}
