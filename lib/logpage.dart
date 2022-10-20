import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proapp/auth.dart';
import 'package:proapp/register.dart';
import 'package:proapp/styles.dart';
import 'package:proapp/main.dart';
import 'package:proapp/currentDoc.dart';

class log extends StatefulWidget {
  @override
  State<log> createState() => _logState();
}

class _logState extends State<log> {
  final TextEditingController usercontroller = TextEditingController();

  final TextEditingController passcontroller = TextEditingController();

  final formKey = GlobalKey<FormState>();
  //bool isSignin = false;

  void dispose() {
    usercontroller.dispose();
    passcontroller.dispose();
    super.dispose();
  }

  loading() {
    print('inside log page');
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
    loading();

    await isEmailvalid();
    await isPassvalid();

    Navigator.pop(context);

    formKey.currentState!.validate();
  }

  var passvalid;
  var emailvalid;

  isEmailvalid() async {
    var email = usercontroller.text.trim();
    if (email.isEmpty) {
      emailvalid = "Enter your email";
      return null;
    }
    var response = await Authmethods.checkmail(email);

    if (response == "error") {
      emailvalid = "invalid email";
      return null;
    }
    emailvalid = null;
  }

  isPassvalid() async {
    var email = usercontroller.text.trim();
    var password = passcontroller.text.trim();

    if (password.isEmpty) {
      passvalid = "Enter your password";
      return null;
    }
    var response = await Authmethods.emailSignIn(email, password);

    if (response == "ok") {
      passvalid = null;

      return null;
    } else {
      passvalid = "Incorrect password";
    }
    // usercontroller.clear();
    //passcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            body: SingleChildScrollView(
          child: Stack(children: [
            Container(
                alignment: Alignment.topCenter,
                height: 600.h,
                width: 600.w,
                child: Image.asset("images/p3.png")),
            loginContainer()
          ]),
        )),
      ),
    );
  }

  Widget loginContainer() {
    return Padding(
      padding: EdgeInsets.only(top: 300.h),
      child: Container(
        height: 365.h,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
            color: Color.fromARGB(255, 32, 42, 68),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(175.r))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.h, bottom: 8.h, left: 25),
                child: Text(
                  "Login",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.roboto(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: Icon(
                                Icons.mail_outlined,
                                color: Color.fromARGB(255, 210, 213, 221),
                              ),
                            ),
                            Container(
                                width: 160.w,
                                child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    controller: usercontroller,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: "Email address",
                                      hintStyle: GoogleFonts.aBeeZee(
                                        fontWeight: FontWeight.w100,
                                        color:
                                            Color.fromARGB(255, 159, 155, 155),
                                      ),
                                    ),
                                    validator: (val) {
                                      return emailvalid;
                                    }))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: Icon(Icons.lock,
                                color: Color.fromARGB(255, 235, 236, 240)),
                          ),
                          Container(
                              width: 160.w,
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: passcontroller,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: GoogleFonts.aBeeZee(
                                        fontWeight: FontWeight.w100,
                                        color: Color.fromARGB(
                                            255, 159, 155, 155))),
                                validator: (val) {
                                  return passvalid;
                                },
                              ))
                        ],
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(left: 120.w),
                child: TextButton(
                    onPressed: null,
                    child: Text(
                      "Forgot Password ?",
                      style:
                          TextStyle(color: Color.fromARGB(255, 236, 195, 145)),
                    )),
              ),
              SizedBox(
                  height: 40.h,
                  width: 200.w,
                  child: ElevatedButton(
                      onPressed: () => validateForm(),
                      child: Text(
                        "Login",
                        style: buttonTextStyle,
                      ),
                      style: logbutton)),
              Padding(
                padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    height: 1.h,
                    width: 70.w,
                    color: Color.fromARGB(255, 159, 155, 155),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 10.w, right: 10.w, top: 4.h, bottom: 4.h),
                    child: Text(
                      "OR",
                      style: TextStyle(
                          color: Color.fromARGB(255, 159, 155, 155),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 1.h,
                    width: 70.w,
                    color: Color.fromARGB(255, 159, 155, 155),
                  ),
                ]),
              ),
              SizedBox(
                  height: 40.h,
                  width: 200.w,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => reg()));
                    },
                    child: Text(
                      "Register",
                      style: buttonTextStyle,
                    ),
                    style: regbutton,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
