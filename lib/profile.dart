import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proapp/auth.dart';
import 'package:proapp/reqlist.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proapp/currentDoc.dart';
import 'package:proapp/screen.dart';

class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String? name1 = doctorsDoc.name;
  String? email = doctorsDoc.email;
  String num = doctorsDoc.phone; //doctors.phone
  String? special = doctorsDoc.specialization;
  String? tcmc = doctorsDoc.id;
  //String day = doctorsDoc.dob;
  String number = '00000000'; //doctorsDoc.phone;
  String dob = doctorsDoc.dob.substring(0,10);

  // Future _getDataFromDatabase() async {
  //   await FirebaseFirestore.instance
  //       .collection("Doctors")
  //       .doc(FirebaseAuth.instance.currentUser!.email)
  //       .get()
  //       .then((snapshot) async {
  //     if (snapshot.exists) {
  //       setState(() {
  //         name1 = snapshot.data()!["name"];
  //         email = snapshot.data()!["email"];
  //         num = snapshot.data()!["phone number"];
  //         special = snapshot.data()!["specialization"];
  //         tcmc = snapshot.data()!["id"];
  //         day = snapshot.data()!["dob"];
  //       });
  //     } else {
  //       print("document doest exist");
  //     }
  //   });
  //   for (int i = 0; i < 10; i++) {
  //     dob = dob + day[i];
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("before fetch");
    //_getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
      child: Stack(children: [
        Container(
          alignment: Alignment.topCenter,
          height: 400,
          decoration: BoxDecoration(
            color: Color.fromARGB(248, 32, 42, 68),
            // fit: BoxFit.cover
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Container(
              height: 510.h,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 220, 219, 219),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(52.r),
                      topRight: Radius.circular(50.r))),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Container(
                      height: 40,
                      child: Text(
                        name1!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aleo(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 80, top: 30),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(children: [
                          Icon(Icons.mail, color: Color.fromARGB(255, 6, 43, 74)),
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              email!,
                              style: GoogleFonts.abel(fontSize: 20),
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(children: [
                          Icon(Icons.phone,
                              color: Color.fromARGB(255, 6, 43, 74)),
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child:
                                Text(num, style: GoogleFonts.abel(fontSize: 20)),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(children: [
                          Icon(Icons.date_range_outlined,
                              color: Color.fromARGB(255, 6, 43, 74)),
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child:
                                Text(dob, style: GoogleFonts.abel(fontSize: 20)),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(children: [
                          Icon(Icons.medical_information,
                              color: Color.fromARGB(255, 6, 43, 74)),
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(special!,
                                style: GoogleFonts.abel(fontSize: 20)),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(children: [
                          Text("TCMC",
                              style: GoogleFonts.abel(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 43, 74))),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(tcmc!,
                                style: GoogleFonts.abel(fontSize: 20)),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 110),
          child: Container(
            alignment: Alignment(0.0, 2.5),
            child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsXdimrXDfzdELeOex1FhsA-UsAHIsg3TtWw&usqp=CAU "),
                radius: 80.0),
          ),
        ),
        Container(
          height: 50.h,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => reqlist()));
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 251, 251, 251),
                    )),
              ],
            ),
          ),
        )
      ]),
    )));
  }
}
