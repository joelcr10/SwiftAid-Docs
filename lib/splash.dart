import 'package:flutter/material.dart';
import 'package:proapp/screen.dart';
import 'package:google_fonts/google_fonts.dart';

class splash extends StatefulWidget {
  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  initState() {
    super.initState();
    navigateTo();
  }

  void navigateTo() async {
    print('inside splash');
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromARGB(248, 32, 42, 68),
      body: Center(
        child: Text(
          "SwiftAid",
          style: GoogleFonts.aladin(fontSize: 60, color: Colors.white),
        ),
      ),
    ));
  }
}
