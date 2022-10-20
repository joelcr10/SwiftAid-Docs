import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:proapp/currentDoc.dart';
import 'package:proapp/main.dart';
import 'package:proapp/reqlist.dart';
import 'package:proapp/screen.dart';
import 'package:proapp/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_functions/cloud_functions.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
//mport 'package:geoflutterfire/geoflutterfire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proapp/configMap.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_database/firebase_database.dart';

String currentUser = currentUserId;
//String? currentUser;
double? userLat;
double? userLog;
double dismissRequestHeight = 0.0;
double responseContainerHeight = 90.0;
String responseAccept = "accepted";
String responseDecline = "declined";

final functions = FirebaseFunctions.instance;

//PolylinePoints polylinePoints = PolylinePoints();
LatLng _center = LatLng(currentPosition.latitude, currentPosition.longitude);

Set<Polyline> _polylines = Set<Polyline>();
List<LatLng> polylineCoordinates = [];
PolylinePoints polylinePoints = PolylinePoints();
//add your lat and lng where you wants to draw polyline

DatabaseReference userRef = FirebaseDatabase.instance.reference().child("user");
DatabaseReference doctorsRef =
    FirebaseDatabase.instance.reference().child("doctors");
DatabaseReference requestRef = FirebaseDatabase.instance
    .reference()
    .child("doctors")
    .child('2jbPkKDgl5Lk5u3aUb63')
    .child("newRequest");

class Assistance extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.528546, 76.822137),
    zoom: 15,
  );

  @override
  State<Assistance> createState() => _AssistanceState();
}

class _AssistanceState extends State<Assistance> {
  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification!;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             //channel.description,
    //             color: Colors.blue,
    //             playSound: true,
    //             //icon: '@mipmap/ic_launcher',
    //           ),
    //         ));
    //   }
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   RemoteNotification notification = message.notification!;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //             title: Text(notification.title!),
    //             content: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [Text(notification.body!)],
    //               ),
    //             ),
    //           );
    //         });
    //   }
    // });

    print('inside init function');
    WidgetsBinding.instance.addPostFrameCallback((_) => setUserLocation());
    //WidgetsBinding.instance.addPostFrameCallback((_) => locateposition());
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getLocationLiveUpdates());
  }

  // void showNotification() {
  //   setState(() {
  //     //_counter++;
  //   });
  //   // flutterLocalNotificationsPlugin.show(
  //   //     0,
  //   //     "Testing",
  //   //     "How you doin ?",
  //   //     NotificationDetails(
  //   //         android: AndroidNotificationDetails(
  //   //       channel.id, channel.name, //channel.description,
  //   //       importance: Importance.high,
  //   //       color: Colors.blue,
  //   //       playSound: true,
  //   //     )));
  //   //icon: '@mipmap/ic_launcher')));
  // }

  Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController newmap;
  //late Position currentPosition;
  var geolocator = Geolocator();
  final Set<Marker> userMarkerSet = new Set();

  void setPolyLines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyCDPlYA4H8lCKusaDOhoU8Iw1pgYueVkXU",
        PointLatLng(currentPosition.latitude, currentPosition.longitude),
        PointLatLng(userLat!, userLog!));

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    print(result);
    print(result.status);
    print('polyline coordinates');
    print(polylineCoordinates);
    setState(() {
      _polylines.add(Polyline(
          width: 10,
          polylineId: PolylineId('polyLine'),
          color: Color(0xFF08A5CB),
          points: polylineCoordinates));
    });
  }

  void setUserLocation() async {
    userLat = userLatitude;
    userLog = userLongitude;
    //('setUserLocation');
    //print(userLat);
    //print(userLog);

    Marker userMarker = Marker(
        markerId: MarkerId("user"),
        position: LatLng(userLat!, userLog!),
        infoWindow: InfoWindow(title: "User Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

    userMarkerSet.add(userMarker);

    //PolylinePoints polylinePoints = PolylinePoints();
    // static const LatLng _center = const LatLng(33.738045, 73.084488);

    setState(() {});
  }

  // void locateposition() async {
  //   /// GETS THE CURRENT POSITION USING GEOLOCATOR

  //   setUserLocation();

  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   currentPosition = position;

  //   //currentUser = FirebaseAuth.instance.currentUser!.uid;
  //   print(currentUser);

  //   LatLng latLngposition = LatLng(position.latitude, position.longitude);
  //   Geofire.initialize("availableDoctors");
  //   Geofire.setLocation(
  //           currentUser, currentPosition.latitude, currentPosition.longitude)
  //       .then((value) => print(value));

  //   requestRef.onValue.listen((event) {});
  //   print('location updated');

  //   getLocationLiveUpdates();
  // }

  void getLocationLiveUpdates() {
    //print('inside get live location updates');

    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      Geofire.setLocation(currentUser, position.latitude, position.longitude);
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newmap.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  ///Gets the current location of doctor when the screen loads

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(248, 32, 42, 68),
            leading: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => reqlist()));
                },
                child: Icon(Icons.arrow_back, color: Colors.white))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Assistance",
                style: GoogleFonts.alegreya(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(169, 32, 42, 40)),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 1),
                child: Container(
                  height: 450.h,
                  width: 345.w,
                  child: Column(
                    children: [
                      Row(children: [
                        Container(
                            height: 50.h,
                            width: 245.w,
                            color: Color.fromARGB(255, 173, 173, 173),
                            child: Padding(
                              padding: EdgeInsets.only(top: 14.h),
                              child: Text("Assistance Requested",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            )),
                        Container(
                            height: 50.h,
                            width: 100.w,
                            color: Color.fromARGB(247, 180, 183, 182),
                            child: Padding(
                              padding: EdgeInsets.only(top: 14.h),
                              child: Text("${distanceInMeters} km away",
                                  textAlign: TextAlign.center),
                            ))
                      ]),
                      Container(
                          height: 400.h,
                          alignment: Alignment.center,
                          color: Color.fromARGB(255, 210, 208, 208),
                          child: Stack(children: [
                            GoogleMap(
                              polylines: _polylines,
                              mapType: MapType.normal,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: true,
                              zoomGesturesEnabled: true,
                              scrollGesturesEnabled: true,
                              initialCameraPosition: Assistance._kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                                newmap = controller;
                                setPolyLines();
                              },
                              markers: userMarkerSet,
                            ),
                          ]))
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 10.0,
                child: Container(
                  height: responseContainerHeight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                        height: 45.h,
                        width: 500.w,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: Container(
                                    height: 45.h,
                                    width: 150.w,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('Doctors')
                                            .doc(currentUser)
                                            .update({
                                          "response": responseAccept,
                                        });

                                        FirebaseFirestore.instance
                                            .collection('UserRequest')
                                            .doc(requestId)
                                            .get()
                                            .then((docs) {
                                          // print(docs["status"]);
                                          if (docs["status"] == "waiting") {
                                            FirebaseFirestore.instance
                                                .collection("UserRequest")
                                                .doc(requestId)
                                                .update({
                                              "response": currentUser,
                                              "status": responseAccept
                                            });
                                          }
                                        });

                                        dismissRequestHeight = 90.0;
                                        responseContainerHeight = 0.0;
                                        setState(() {});

                                        //print("the help request has been accepted");
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 15.w),
                                            child: Icon(
                                              Icons.thumb_up,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Accept!",
                                            style: buttonTextStyle,
                                          )
                                        ],
                                      ),
                                      style: accept,
                                    )),
                              ),
                              Container(
                                  height: 45.h,
                                  width: 150.w,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      newRequest = false;
                                      FirebaseFirestore.instance
                                          .collection('Doctors')
                                          .doc(currentUser)
                                          .update({
                                        "response": responseDecline,
                                        "helpRequest": noRequest
                                      });
                                      // Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => reqlist()));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 15.w),
                                          child: Icon(
                                            Icons.thumb_down,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "Decline",
                                          style: buttonTextStyle,
                                        )
                                      ],
                                    ),
                                    style: decline,
                                  )),
                            ])),
                  ),
                ),
              ),

              //Dismiss request
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 10.0,
                child: Container(
                  height: dismissRequestHeight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                        height: 45.h,
                        width: 500.w,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: Container(
                                    height: 45.h,
                                    width: 300.w,
                                    child: RaisedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('Doctors')
                                            .doc(currentUser)
                                            .update({
                                          "response": "waiting",
                                          "helpRequest": noRequest
                                        });

                                        // FirebaseFirestore.instance
                                        //       .collection('UserRequest')
                                        //       .doc(requestId)
                                        //       .get()
                                        //       .then((docs) {
                                        //     print(docs["status"]);
                                        //     if (docs["status"] == "accepted") {
                                        //       FirebaseFirestore.instance
                                        //           .collection("UserRequest")
                                        //           .doc(requestId)
                                        //           .update({
                                        //         "response": noRequest,
                                        //         "status": "dismissed"
                                        //       });
                                        //     }
                                        //   });

                                        FirebaseFirestore.instance
                                            .collection("UserRequest")
                                            .doc(requestId)
                                            .update({
                                          "response": noRequest,
                                          "status": "dismissed"
                                        });
                                        dismissRequestHeight = 0.0;
                                        responseContainerHeight = 90.0;

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    reqlist()));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Padding(
                                          //   padding:
                                          //       EdgeInsets.only(right: 15.w),
                                          //   // child: Icon(
                                          //   //   Icons.thumb_up,
                                          //   //   color: Colors.white,
                                          //   // ),
                                          // ),
                                          Text(
                                            "Dismiss Request",
                                            style: TextStyle(fontSize: 18.0),
                                          )
                                        ],
                                      ),
                                      //style: accept,
                                      textColor: Colors.white,
                                      color: Color.fromARGB(209, 17, 29, 66),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(24.0)),
                                    )),
                              ),
                            ])),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Container(
                    height: 25,
                    child: Text(
                      "Amal jyothi college of engineering ,kuvappalli",
                      //currentUser,
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
