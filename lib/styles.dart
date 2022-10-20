import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:google_fonts/google_fonts.dart';

ButtonStyle regbutton = ButtonStyle(
    //textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
    backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 76, 116, 209)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w))));

ButtonStyle regb = ButtonStyle(
    //textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
    backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 27, 50, 104)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w))));

ButtonStyle logbutton = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(232, 247, 161, 32)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w))));
TextStyle buttonTextStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
ButtonStyle accept = ButtonStyle(
    //textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
    backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 2, 126, 47)));
ButtonStyle decline = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 185, 10, 22)));
