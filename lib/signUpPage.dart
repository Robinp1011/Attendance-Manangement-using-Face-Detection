import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  bool isShow = true;
  bool isEmailExist = false;
  bool isRed = false;

  void navigationPage() {
    setState(() {
      isRed = false;
    });
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }


  addUserLate() async{

    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('attendance').document("8GEy6WQ0UlAtoMF6A4x1").collection("loginDetails").getDocuments();

    if(qn.documents.length != 0) {
      for (int i = 0; i < qn.documents.length; i++) {
        if (qn.documents[i].data['email'] == emailController.text) {
          isEmailExist = true;
          break;
        }
      }
    }

    if(isEmailExist)
    {
      setState(() {
        isRed = true;
      });
      startTime();
      isEmailExist = false;
    }
    else
    {


      User user = new User(emailController.text, passController.text);


      try {
        print("employee ky ander");
        Firestore.instance.runTransaction(
              (Transaction transaction) async {
            await Firestore.instance
                .collection("attendance")
                .document("8GEy6WQ0UlAtoMF6A4x1").collection("loginDetails").document()
                .setData(user.toJson());

          },
        );
      } catch (e) {
        print(e.toString());
      }

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginPage()));

    }


  }



  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        //  crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ? \n',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            child: Text(
              'Login',
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            onTap: () {
              print("gya");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      ),
    );
  }

  Widget emailPassWidget()
  {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
            child: Column(
              children: <Widget>[
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(

                    controller: emailController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      enabledBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      fillColor: Colors.lightBlueAccent,
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val.length == 0)
                        return "Please enter email";
                      else if (!val.contains("@blp.co.in"))
                        return "Please enter valid email";
                      else
                        return null;
                    },



                  ),


                ),

                if(isRed)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Email already exist',
                        style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.red)),
                  ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                controller: passController,

                obscureText: isShow ? true : false,

                style: TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(
                  // border: InputBorder.none,

                  suffixIcon: GestureDetector(
                    child: isShow
                        ? Icon(Icons.remove_red_eye, color: Colors.white,)
                        : Icon(Icons.visibility_off, color: Colors.white,),
                    onTap: () {
                      setState(() {
                        isShow = !isShow;
                      });
                    },
                  ),

                  enabledBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),

                //  obscureText: true,
                validator: (val) {
                  if (val.length == 0)
                    return "Please enter password";
                  else if (val.length <= 5)
                    return "Your password should be more then 6 char long";
                  else
                    return null;
                },
              ),
            ),
          ),

        ],
      ),
    );


  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(

        onWillPop: ()
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.black87, Colors.black]),
          ),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 10),
                      child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                      child: Container(
                        //color: Colors.green,
                        height: 200,
                        width: 200,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 60,
                            ),
                            Center(
                              child: Text(
                                'Attendance app',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),

                  emailPassWidget(),


                  Padding(
                    padding: const EdgeInsets.only(top: 40, right: 50, left: 200),
                    child: GestureDetector(
                      child: Container(
                        // alignment: Alignment.bottomRight,
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
                              'Register',
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

                      onTap: ()  async
                      {
                        var connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

                          if(_formKey.currentState.validate())
                          {
                            print("registrer complete");
                            addUserLate();
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





                      },

                    ),
                  ),
                  new SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _createAccountLabel(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
