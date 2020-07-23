
/*
import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'homePage.dart';

class FacePage extends StatefulWidget {
  @override
  _FacePageState createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  File _imageFile;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;

  _getImageAndDetectFaces() async {
    final imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera
    );
    setState(() {
      isLoading = true;
    });
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
        FaceDetectorOptions(
          mode: FaceDetectorMode.fast,
          enableLandmarks: true,
          //  enableClassification: true,
          // enableContours: true,
          // enableTracking: true



        )
    );
    List<Face> faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
        _loadImage(imageFile);
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
          (value) => setState(() {
        _image = value;
        isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: ()
        {
         // Navigator.push(context,
          //    MaterialPageRoute(builder: (context) => middlePage()));
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : (_imageFile == null)
            ? Center(child: Text('No image selected'))
            : Center(
          child: FittedBox(
            child: SizedBox(
              width: _image.width.toDouble(),
              height: _image.height.toDouble(),
              child: CustomPaint(
                painter: FacePainter(_image, _faces),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImageAndDetectFaces,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..color = Colors.blue;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}


 */





import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'homePage.dart';
//import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'userInfo.dart';
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';





class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool resultSent = false;
 // BarcodeDetector detector = FirebaseVision.instance.barcodeDetector();
  FaceDetector detector = FirebaseVision.instance.faceDetector();
  File _imageFile ;
  List<Face> _faces;
  bool isLoading = false;
  ui.Image _image;
 // CameraController controller;
  CameraController _cameraController;
  Key _visibilityKey = UniqueKey();

  final _scanKey = GlobalKey<CameraMlVisionState>();
  CameraLensDirection direction = CameraLensDirection.front;
  @override
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool flag = true;




  void takePic() async {

    try {

      final path = join(

        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

     await _scanKey.currentState.stop();

      await _scanKey.currentState.takePicture(path);


      flag = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: path),
        ),
      );
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, takePic);
  }

  Widget build(BuildContext context) {
    return


      WillPopScope(
        onWillPop: ()
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GeoListenPage()));
        },

        child:Scaffold(
      body: ListView(
        children: <Widget>[
          SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child:  CameraMlVision<List<Face>>(

               key: _scanKey,


                detector: detector.processImage,
                cameraLensDirection: direction,
                onResult: (List<Face> faces) async{

                  print(faces.length);
                  if (!mounted || faces.length>0) {

                      print(faces);
                      if(flag) {
                        startTime();
                      }
                      flag = false;


                  }

                },
                onDispose: ()
                {
                  detector.close();
                },

              ),
            ),
          ),


        ],
      ),
    ), );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  @override
  final String imagePath;


  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  File image;


  Geolocator geolocator = Geolocator();
  TextEditingController  nameController = new TextEditingController();
  Position userLocation;
 // File sampleImage;
  String downloadUrl;
  String myimage;
  Random rando = new Random();
  DateTime _dateTime = DateTime.parse("${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()} 00:00:00");

  Future addImage()  async
  {
    getLatLong();
    myimage = rando.nextInt(10000).toString();
    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(myimage);

    downloadUrl="https://firebasestorage.googleapis.com/v0/b/las-prod-1.appspot.com/o/${myimage}?alt=media";
    final StorageUploadTask task =
    firebaseStorageRef.putFile(image);



    setData();

  }



  setData()
  {

    print(userLocation);
    print("aaya");
    UserInfo user = new UserInfo(nameController.text, downloadUrl, userLocation.latitude.toString(), userLocation.longitude.toString(), _dateTime, "auto");


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


  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  startTime2() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration,addImage);
  }

  void navigationPage()
  {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ScanPage()));
  }

  showAlert()
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Marked Successfully"),
        //  content: new Text("Marked Successfully"),



        );
      },
    );
    print("chala re apun");

   startTime();
  }



  getLatLong()
  {
    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });

  }




  void initState()
  {
    super.initState();
    image = File(widget.imagePath);
    startTime2();

    getLatLong();
  }
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.black,
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
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

            child: Center(
              child: Column(
                children: <Widget>[
                  new SizedBox(
                    height: MediaQuery.of(context).size.height/7,
                  ),
                  Image.file(image, width:MediaQuery.of(context).size.width/1.12, height: MediaQuery.of(context).size.height/1.5, ),



                ],
              ),
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


