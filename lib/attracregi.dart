import 'package:flutter/material.dart';
import 'package:icon_forest/icon_forest.dart';
import 'package:flutter/cupertino.dart';
import 'package:origi/attraclogi.dart';
import 'dart:convert';
import 'config.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
class Attracregi extends StatefulWidget {
  const Attracregi({super.key});

  @override
  State<Attracregi> createState() => _AttracregiState();
}

class _AttracregiState extends State<Attracregi> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isNotValidate = false;
  void _logo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ALoginPage()),
    );
  }

  void _gologin() async {
    if (_userIdController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var regBody = {
        "userId": _userIdController.text,
        "password": _passwordController.text,
      };

      try {
        var response = await http.post(
          Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        var jsonResponse = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration successful! Please log in.")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ALoginPage()),
          );
        } else {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? 'Registration failed')),
          );
        }
      } catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }


  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE53935), Color(0xFFE57373)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 8,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 32, horizontal: 24),
                            child: Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(CupertinoIcons.paperplane,
                                      size: 60, color: Colors.redAccent),
                                  SizedBox(height: 16),
                                  Text(
                                    'Register User',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  TextFormField(
                                    controller: _userIdController,
                                    decoration: InputDecoration(
                                      labelText: 'User ID',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Enter User ID'
                                        : null,
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.lock),
                                    ),
                                    validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Enter Password'
                                        : null,
                                  ),
                                  SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _gologin,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                      ),
                                      child: Text(
                                          'Register and return to Login'),
                                    ),

                                  ),
                                  SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _logo,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                      ),
                                      child: Text(
                                          'Return to Login'),
                                    ),),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}