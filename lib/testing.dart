import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:proapp/currentDoc.dart';
import 'package:proapp/main.dart';
import 'package:proapp/reqlist.dart';
// import 'package:proapp/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import 'package:firebase_database/firebase_database.dart';

String? currentUser;
String requestId = '';
String noRequest = "None";
double userLatitude = 0.0;
double userLongitude = 0.0;

final functions = FirebaseFunctions.instance;

DatabaseReference userRef = FirebaseDatabase.instance.reference().child("user");
DatabaseReference doctorsRef =
    FirebaseDatabase.instance.reference().child("doctors");
DatabaseReference requestRef = FirebaseDatabase.instance
    .reference()
    .child("doctors")
    .child('2jbPkKDgl5Lk5u3aUb63')
    .child("newRequest");

bool status = true;

class Assistance extends StatefulWidget {
  @override
  State<Assistance> createState() => _AssistanceState();
}

void getDistanceBetween() {
  double distanceInMeters =
      Geolocator.distanceBetween(9.528764, 76.822757, userLatitude, userLongitude);
  print('the distance');
  print(distanceInMeters);

}

Future helpRequestLocation() async {
  await FirebaseFirestore.instance
      .collection('UserRequest')
      .doc(requestId)
      .get()
      .then((docs) {
    print(docs.get('position'));
    print(docs["position"][0]);
    userLatitude = double.parse(docs["position"][0]);
    userLongitude = double.parse(docs["position"][1]);

    print("${userLatitude} and ${userLongitude}");
    getDistanceBetween();
  });


}

//listening for help request in firestore
void checkForRequest() async {
  var document = await FirebaseFirestore.instance
      .collection('Doctors')
      .doc('G9yoYiAB5RXRO3ziETGwhiVrRT53');
  document.get().then((document) {
    if (document["helpRequest"] == noRequest) {
      print('No help request');
    } else {
      print('request help has been published');
      print(document["helpRequest"]);
      requestId = document["helpRequest"];
      helpRequestLocation();
    }
  });
}

class _AssistanceState extends State<Assistance> {
  void initState() {
    super.initState();

    //WidgetsBinding.instance.addPostFrameCallback((_) => checkForRequest());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Flutter StreamBuilder Demo'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("Doctors").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else {
                print('no error');
                checkForRequest();
                return const Text('it has data');
              }
            },
          ),
        ),
      ),
    );
  }
}
