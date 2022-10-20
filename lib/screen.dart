import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proapp/auth.dart';
import 'package:proapp/logpage.dart';
import 'package:proapp/reqlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proapp/currentDoc.dart';

class screen extends StatefulWidget {
  @override
  State<screen> createState() => _screenState();
}

DoctorsDoc doctorsDoc =
    DoctorsDoc(); //use this object (doctorsDoc) where you want to fetch data of doctor
String currentUserId = '';

class _screenState extends State<screen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Authmethods.authStateChanges,
        builder: (context, snapshot) {
          print("snap data : ${snapshot.data}");
          String doctorId = snapshot.data.toString();
          currentUserId = doctorId;

          doctorsDoc.setCurrentDocId = doctorId;

          if (currentUserId != '') {
            print("fetching $currentUserId data");
            FirebaseFirestore.instance
                .collection('Doctors')
                .doc(doctorId)
                .get()
                .then((document) {
              print(document["email"]);
              doctorsDoc.name = document["name"];
              doctorsDoc.dob = document["dob"];
              doctorsDoc.specialization = document["specilization"];
              doctorsDoc.email = document["email"];
              doctorsDoc.id = document["id"];
              doctorsDoc.phone = document["phone"];
            });
          }

          return snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData
              ? reqlist()
              : log();
        });
  }
}
