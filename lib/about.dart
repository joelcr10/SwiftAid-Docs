import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:proapp/accept.dart';
import 'package:proapp/reqlist.dart';

class about extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(248, 32, 42, 68),
          leading: TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => reqlist()));
              },
              child: Icon(Icons.arrow_back, color: Colors.white)),
        ),
        body: Container(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              height: 60.h,
              alignment: Alignment.topCenter,
              child: Text(
                "SwiftAid",
                style: GoogleFonts.aladin(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(248, 32, 42, 68)),
              ),
            ),
          ),
          Container(
            height: 200.h,
            width: 300.w,
            alignment: Alignment.center,
            child: Text(
              "SwiftAid attempts to connect a healthcare professional to the scene of a medical emergency as they could provide proper and adequate treatment to the patient.\n\n Thank you.",
              textAlign: TextAlign.center,
              style: GoogleFonts.radley(fontSize: 20),
            ),
          ),
          Container(
            child: Image.asset(
              "images/p1.jpg",
              color: Color.fromARGB(121, 255, 255, 255),
              colorBlendMode: BlendMode.modulate,
              height: 300.h,
              width: 500.w,
              alignment: Alignment.bottomCenter,
            ),
          )
        ])));
  }
}
