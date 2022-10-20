import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proapp/assistance.dart';
import 'package:proapp/currentDoc.dart';
import 'package:proapp/menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:proapp/testing.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proapp/screen.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:proapp/configMap.dart';

//importing database packages//

//

//String? currentUser;
String requestId = '';
String noRequest = "None";
double userLatitude = 0.0; //user's latitude postion
double userLongitude = 0.0; //user's longitude position
bool status = true; //
double distanceInMeters =
    0.0; //the distance between user and doctor actually in km
double reqCardHeight = 0;
bool reqCardVisibility = false;
bool noRequestVisibility = true;
bool newRequest =
    true; //used in streamBuilder to denote new request in Doctors' helpRequest field
late Position currentPosition;

class reqlist extends StatefulWidget {
  @override
  State<reqlist> createState() => _reqlistState();
}

// resetReq() {
//   newRequest = false;
// }

class _reqlistState extends State<reqlist> {
  //creating a init state to initialize
  void initState() {
    super.initState();
    print('inside reqlist initstate');
    WidgetsBinding.instance.addPostFrameCallback((_) => checkForRequest());

    //WidgetsBinding.instance.addPostFrameCallback((_) => locateposition());
  }

  void locateposition() async {
    /// GETS THE CURRENT POSITION USING GEOLOCATOR

    //setUserLocation();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    //currentUser = FirebaseAuth.instance.currentUser!.uid;
    //print("${currentPosition.latitude} ${currentPosition.longitude}");
    //print(currentUserId);

    //LatLng latLngposition = LatLng(position.latitude, position.longitude);
    Geofire.initialize("availableDoctors");
    Geofire.setLocation(
            currentUserId, currentPosition.latitude, currentPosition.longitude)
        .then((value) => print(value));

    //requestRef.onValue.listen((event) {});
    getLocationLiveUpdates();
  }

  void getLocationLiveUpdates() {
    //print('inside get live location updates');

    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      Geofire.setLocation(currentUserId, position.latitude, position.longitude);
      //LatLng latLng = LatLng(position.latitude, position.longitude);
      //newmap.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void getDistanceBetween() {
    //get current location from realtime database
    // distanceInMeters = (Geolocator.distanceBetween(
    //         9.528764, 76.822757, userLatitude, userLongitude)) /
    //     1000;
    distanceInMeters = (Geolocator.distanceBetween(currentPosition.latitude,
            currentPosition.longitude, userLatitude, userLongitude)) /
        1000;
    distanceInMeters = double.parse((distanceInMeters).toStringAsFixed(2));
    //print('the distance: $distanceInMeters');
    newRequest = true;
    setState(() {});
  }

  Future helpRequestLocation() async {
    await FirebaseFirestore.instance
        .collection('UserRequest')
        .doc(requestId)
        .get()
        .then((docs) {
      userLatitude = double.parse(docs["position"][0]);
      userLongitude = double.parse(docs["position"][1]);
      locateposition();
      getDistanceBetween();
    });
  }

//listening for help request in firestore
  Future checkForRequest() async {
    //fetching the Document snapshot from currentUserId

    // final ConnectivityResult result = await Connectivity().checkConnectivity();

    // if (result == ConnectivityResult.wifi) {
    //   print('Connected to a Wi-Fi network');
    // } else if (result == ConnectivityResult.mobile) {
    //   print('Connected to a mobile network');
    // } else {
    //   print('Not connected to any network');
    // }

    var document = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(currentUserId);

    document.get().then((document) {
      if (document["helpRequest"] == noRequest) {
        //if helpRequest is set to None
        resetReq();
        setState(() {});
      } else {
        //when helpRequest is not None...fetch the requestId from the helpRequest field
        requestId = document["helpRequest"];
        newRequest =
            true; //setting the newRequest to true to replace "no new request" with requist block
        helpRequestLocation();
        setState(() {}); //get longitude and latitude of requestId
      }
    });
  }

  resetReq() {
    newRequest = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(248, 32, 42, 68),
              title: Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Text(
                  "SwiftAid",
                  style: GoogleFonts.aladin(fontSize: 30),
                ),
              ),
            ),
            drawer: Menubar(),
            body: SingleChildScrollView(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Image.asset(
                    "images/p1.jpg",
                    color: Color.fromARGB(121, 255, 255, 255),
                    colorBlendMode: BlendMode.modulate,
                    height: 500.h,
                    width: 500.w,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              "New Requests",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.alegreya(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(248, 32, 42, 68)),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Doctors")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            try {
                              checkForRequest();
                              locateposition();
                            } catch (e) {
                              print('inside cactch');
                            } finally {
                              //print('inside stream builder ${newRequest}');
                              if (newRequest) {
                                //print('inside card function ${newRequest}');
                                return Card(
                                  //color: Color.fromARGB(31, 83, 82, 82),
                                  color: Color.fromARGB(31, 83, 82, 82),
                                  child: ListTile(
                                    title: Text(
                                      "Assistence required :${distanceInMeters} away",
                                      style: GoogleFonts.adamina(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //trailing: Text("7:02 pm"),
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Assistance()))
                                    },
                                  ),
                                );
                              } else {
                                //print('inside no new req ${newRequest}');

                                try {
                                  setState(() {});
                                } catch (e) {
                                } finally {
                                  return Text("No new request");
                                }
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
