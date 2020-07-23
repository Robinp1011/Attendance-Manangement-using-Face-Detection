import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:math';
import 'userInfo.dart';
import 'output.dart';
import 'face.dart';
import 'package:intl/intl.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeoListenPage extends StatefulWidget {
  @override
  _GeoListenPageState createState() => _GeoListenPageState();
}

class _GeoListenPageState extends State<GeoListenPage> {
  Geolocator geolocator = Geolocator();
  TextEditingController  nameController = new TextEditingController();
  Position userLocation;
  File sampleImage;
  String downloadUrl;
  String myimage;
  Random rando = new Random();

 DateTime _dateTime = DateTime.parse("${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()} 00:00:00");
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 60);

    setState(() {
      sampleImage = tempImage;
    });

    getLatLong();
  }

  Future addImage()  async
  {
    getLatLong();
    myimage = rando.nextInt(10000).toString();
    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(myimage);

    downloadUrl="https://firebasestorage.googleapis.com/v0/b/las-prod-1.appspot.com/o/${myimage}?alt=media";
    final StorageUploadTask task =
    firebaseStorageRef.putFile(sampleImage);



    setData();

  }

  setData()
  {

    print(userLocation);
    print("aaya");
    UserInfo user = new UserInfo(nameController.text, downloadUrl, userLocation.latitude.toString(), userLocation.longitude.toString(), _dateTime, "manual");


    try {
      print("employee ky ander");
              Firestore.instance
              .collection("attendance")
              .document("8GEy6WQ0UlAtoMF6A4x1").collection("info").document()
              .setData(user.toJson());


    } catch (e) {
      print(e.toString());
    }

        showAlert();
  }


  showAlert()
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Warning: "),
          content: new Text("Marked Successfully"),

          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GeoListenPage()));
              },
            ),
          ],

        );
      },
    );
  }


  getLatLong()
  {
    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });

  }
  printLocation()
  {
    print(userLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: WillPopScope(
        onWillPop: ()
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GeoListenPage()));
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),

                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.black87, Colors.black])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                new SizedBox(
                  height: MediaQuery.of(context).size.height/25,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            //  alignment: Alignment.bottomRight,
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(

                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Auto Mode',

                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                              ],
                            ),
                          ),

                          onTap: ()
                          {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ScanPage()));
                          },

                        ),
                      ),

                      new SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            //  alignment: Alignment.bottomRight,
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(

                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'List Page',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                new SizedBox(
                                  width: 2,
                                ),

                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.lightBlueAccent,
                                ),
                              ],
                            ),
                          ),

                          onTap: () async
                          {

                            var connectivityResult = await (Connectivity().checkConnectivity());
                            if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                              // I am connected to a mobile network.


                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => outputPage()));

                            }

                            else
                            {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    //title: new Text("Warning: "),
                                    content: new Text("You are not connected to Internet."),

                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text("OK"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],

                                  );
                                },
                              );
                            }


                          },
                        ),
                      ),



                    ],
                  ),
                ),

                new SizedBox(
                  height: MediaQuery.of(context).size.height/30,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Container(


                      decoration: sampleImage == null ?BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                      )   :   BoxDecoration(
                        color: Colors.black,
                      ),
                      // alignment: Alignment.bottomCenter,

                      //  height: 40,
                      //   width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          if(sampleImage!= null)
                            FittedBox(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(sampleImage, width: MediaQuery.of(context).size.width/1.18, height: MediaQuery.of(context).size.height/3),
                            ),
                              fit: BoxFit.cover,
                            )
                          else
                            FittedBox(child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Image.asset("assets/images/camera.png", width: MediaQuery.of(context).size.width/1.18, height: MediaQuery.of(context).size.height/3
                                ,),
                            ),
                              fit: BoxFit.contain,
                            ),
                        ],
                      ),
                    ),

                    onTap: ()
                    {
                      getImage();
                    },

                  ),
                ),



                new SizedBox(
                  height: MediaQuery.of(context).size.height/20,
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: <Widget>[
                      Expanded(

                        child: new TextField(
                          controller: nameController,

                          style: TextStyle(
                            color: Colors.white,
                          ),

                          decoration: new InputDecoration(
                              border: new UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white
                                  )
                              ),
                              enabledBorder: new UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              //  hintText: "Enter name",
                              //   hintStyle: TextStyle(color: Colors.white),
                              labelText: "Enter name",
                              labelStyle: TextStyle(color: Colors.white)
                          ),

                        ),
                      ),

                      new SizedBox(
                        width: 25,
                      ),


                      Expanded
                        (
                        child: GestureDetector(
                          child: Container(

                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),

                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Colors.lightBlue[300], Colors.lightBlue[700]])),
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          onTap: () async
                          {

                            if(sampleImage == null)
                            {

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    //title: new Text("Warning: "),
                                    content: new Text("Photo is not present"),

                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text("OK"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],

                                  );
                                },
                              );
                            }
                            else
                            {

                              if(nameController.text.trim() == "")
                              {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      //title: new Text("Warning: "),
                                      content: new Text("Please fill name"),

                                      actions: <Widget>[
                                        new FlatButton(
                                          child: new Text("OK"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],

                                    );
                                  },
                                );
                              }
                              else
                              {
                                addImage();
                              }

                            }

                            /*


                            var connectivityResult = await (Connectivity().checkConnectivity());
                            if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                              // I am connected to a mobile network.


                              if(sampleImage == null)
                              {

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      //title: new Text("Warning: "),
                                      content: new Text("Photo is not present"),

                                      actions: <Widget>[
                                        new FlatButton(
                                          child: new Text("OK"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],

                                    );
                                  },
                                );
                              }
                              else
                              {

                                if(nameController.text.trim() == "")
                                {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        //title: new Text("Warning: "),
                                        content: new Text("Please fill name"),

                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text("OK"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],

                                      );
                                    },
                                  );
                                }
                                else
                                {
                                  addImage();
                                }

                              }

                            }

                            else
                            {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    //title: new Text("Warning: "),
                                    content: new Text("You are not connected to Internet."),

                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text("OK"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],

                                  );
                                },
                              );
                            }

                                  */

                          },
                        ),
                      ),

                    ],
                  ),
                ),

                new SizedBox(
                  height: MediaQuery.of(context).size.height/10,
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:40 ),
                  child: GestureDetector(
                    child: Container(

                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),

                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.lightBlue[300], Colors.lightBlue[700]])),
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    onTap: ()
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            //title: new Text("Warning: "),
                            content: new Text("Are you sure you want to logout ?"),

                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("No"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),

                              new FlatButton(
                                child: new Text("Yes"),
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('email',null);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => LoginPage()));
                                },
                              ),
                            ],

                          );
                        },
                      );
                    },

                  ),
                ),



                new SizedBox(
                  height: 60,
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}


