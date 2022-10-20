import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proapp/auth.dart';

import 'logpage.dart';
import 'styles.dart';
import 'package:google_fonts/google_fonts.dart';

class reg extends StatefulWidget {
  @override
  State<reg> createState() => _regState();
}

class _regState extends State<reg> {
  String value = 'Gender';
  var items = ['Gender', 'Male', 'Female', 'Others'];
  String date = "";
  DateTime selectedDate = DateTime.now();

  final TextEditingController emailcontroll = TextEditingController();
  final TextEditingController passcontroll = TextEditingController();
  final TextEditingController namecontroll = TextEditingController();
  final TextEditingController specialcontroll = TextEditingController();
  final TextEditingController idcontroll = TextEditingController();
  final TextEditingController phonecontroll = TextEditingController();

  final formkey = GlobalKey<FormState>();

  void dispose() {
    emailcontroll.dispose();
    passcontroll.dispose();
    namecontroll.dispose();
    specialcontroll.dispose();
    idcontroll.dispose();
    phonecontroll.dispose();
    super.dispose();
  }

  loading() async {
    showDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 5,
          ),
        );
      },
      context: context,
    );
  }

  validateForm() async {
    //loading();

    isEmailvalid();
    ispassvalid();
    isnamevalid();
    isspecialvalid();
    isidvalid();
    isPhoneValid();

    var response;
    if (!formkey.currentState!.validate()) {
      return;
    }
    loading();
    response = await Authmethods.emailSignUp(
        emailcontroll.text.trim(),
        passcontroll.text.trim(),
        namecontroll.text.trim(),
        specialcontroll.text.trim(),
        idcontroll.text.trim(),
        phonecontroll.text.trim(),
        date);
    Navigator.pop(context);

    if (response == "An error occured") {
      //show error message =>snackbar etc..
    } else {
      //next step after successful sign up

      Navigator.of(context).pop();
    }
  }

  var passvalid;
  var emailvalid;
  var namevalid;
  var specialvalid;
  var idvalid;
  var phonevalid;

  isEmailvalid() {
    emailvalid = null;
    var email = emailcontroll.text.trim();
    if (email.isEmpty) {
      emailvalid = "Enter your email";
      // return null;
    }

    if (!email.contains("@")) {
      emailvalid = "invalid email";
      // return null;
    }
  }

  isPhoneValid() {
    phonevalid = null;
    var phone = emailcontroll.text.trim();
    if (phone.isEmpty) {
      emailvalid = "Enter your Phone number";
    }

    if (phone.length <= 10) {
      emailvalid = "Enter 10 digit phone number";
    }
  }

  ispassvalid() {
    passvalid = null;
    var password = passcontroll.text.trim();
    if (password.isEmpty) {
      passvalid = "Enter a password";
      // return null;
    }

    if (password.length < 5) {
      passvalid = "invalid email";
      // return null;
    }
  }

  isnamevalid() {
    namevalid = null;
    var name = namecontroll.text.trim();
    if (name.isEmpty) {
      namevalid = "Enter your name";
      // return null;
    }
  }

  isspecialvalid() {
    specialvalid = null;
    var special = specialcontroll.text.trim();
    if (special.isEmpty) {
      specialvalid = "Enter your specialization";
      // return null;
    }
  }

  isidvalid() {
    idvalid = null;
    var id = idcontroll.text.trim();
    if (id.isEmpty) {
      idvalid = "Enter your tmtc id";
      // return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Color.fromARGB(248, 32, 42, 68),
              leading: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => log()));
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white))),
          body: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Container(
                //height: 630,
                width: 400.w,
                color: Color.fromARGB(192, 213, 225, 255),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    children: [
                      Container(
                          height: 250.h,
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 37, bottom: 10),
                                child: Image.asset("images/p3.png"),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "REGISTER",
                                  style: GoogleFonts.habibi(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(248, 32, 42, 68)),
                                ),
                              ),
                            ],
                          )),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 2, 4, 0),
                          ),
                          Container(
                              height: 50,
                              width: 250,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: TextFormField(
                                      controller: namecontroll,
                                      decoration: InputDecoration(
                                          hintText: "Full Name"),
                                      validator: (val) {
                                        return namevalid;
                                      }))),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.date_range_sharp),
                          Container(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              child: Text("DOB"),
                            ),
                          ),
                          Text(
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}")
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 2, 4, 0),
                          ),
                          Container(
                              height: 50,
                              width: 250,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: TextFormField(
                                      controller: phonecontroll,
                                      decoration: InputDecoration(
                                          hintText: "Phone Number"),
                                      validator: (val) {
                                        return phonevalid;
                                      }))),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Row(
                          children: [
                            Icon(Icons.medical_information),
                            Container(
                              height: 50,
                              width: 250,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextFormField(
                                    controller: specialcontroll,
                                    decoration: InputDecoration(
                                        hintText: "Specialization"),
                                    validator: (val) {
                                      return specialvalid;
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            Icon(Icons.card_membership),
                            Container(
                              height: 50,
                              width: 250,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextFormField(
                                    controller: idcontroll,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(hintText: "ID"),
                                    validator: (val) {
                                      return idvalid;
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.mail),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                                width: 235,
                                child: TextFormField(
                                    controller: emailcontroll,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        hintText: "Email address"),
                                    validator: (val) {
                                      return emailvalid;
                                    })),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.lock),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                                width: 235,
                                child: TextFormField(
                                    controller: passcontroll,
                                    textInputAction: TextInputAction.done,
                                    obscureText: true,
                                    decoration:
                                        InputDecoration(hintText: "Password"),
                                    validator: (val) {
                                      return passvalid;
                                    })),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                            height: 40.h,
                            width: 200.w,
                            child: ElevatedButton(
                              onPressed: () {
                                validateForm();
                              },
                              child: Text(
                                "Register",
                                style: buttonTextStyle,
                              ),
                              style: regb,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1995),
      lastDate: DateTime(2025),
      helpText: "SELECT DATE OF BIRTH",
      cancelText: "Cancel",
      confirmText: "Ok",
      fieldHintText: "dd/mm/yyyy",
      fieldLabelText: "DOB",
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        date = selectedDate.toIso8601String();
      });
  }
}
