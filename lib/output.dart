import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homePage.dart';
import 'package:intl/intl.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class outputPage extends StatefulWidget {
  @override
  _outputPageState createState() => _outputPageState();
}

class _outputPageState extends State<outputPage> {
  @override


  DateTime _selectedValue = DateTime.now();

  Future  getPosts()  async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('attendance').document("8GEy6WQ0UlAtoMF6A4x1").collection("info").where("date" ,isEqualTo: _selectedValue).getDocuments();
    print(qn.documents.length);
    return qn.documents;
  }


  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: new Text("Attendance List", style: new TextStyle(color: Colors.white),),
      ),

      body: WillPopScope(
        onWillPop: ()
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GeoListenPage()));
        },

        child: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: <Widget>[

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DatePicker(
                        DateTime.now().add(Duration(days: -6)),
                        width: 60,
                        height: 80,
                        //   controller: _controller,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Colors.black,
                        selectedTextColor: Colors.lightGreenAccent,
                        monthTextStyle: new TextStyle(color:Colors.white),
                        dayTextStyle: new TextStyle(color:Colors.white),
                        dateTextStyle: new TextStyle(color:Colors.white),
                        daysCount:7,
                        onDateChange: (date) {
                          // New date selected
                          setState(() {
                            _selectedValue = date;
                            print(_selectedValue);
                          });
                        },
                      ),
                    ],
                  ),

                  new SizedBox(height: 20,),


                  new FutureBuilder(
                      future: getPosts(),
                      builder: (_,snapshot){

                        if(snapshot.connectionState == ConnectionState.waiting)
                        {
                          return Center(child: new CircularProgressIndicator());
                        }
                        else
                        {
                          return Container(

                            height:MediaQuery.of(context).size.height/1.40,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,

                                itemBuilder: (_, index)
                                {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom:2.0, left: 3, right: 3),
                                    child: Card(
                                      color: Colors.grey[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3.0),),
                                      child: GestureDetector(
                                        child: new ListTile(
                                          contentPadding: EdgeInsets.all(10.0),


                                          subtitle: Row(
                                            children: <Widget>[

                                              new Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: new DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: new NetworkImage(
                                                            snapshot.data[index].data['imageUrl'], ),
                                                      )
                                                  )),
                                            //  Image.network(snapshot.data[index].data['imageUrl'], height: 60,width: 60,),
                                              new SizedBox(
                                                width: 5,
                                              ),

                                              Container(height: 60, child: VerticalDivider(color: Colors.white)),
                                              new SizedBox(
                                                width: 10,
                                              ),

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Text(snapshot.data[index].data['name'], style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),),

                                                  new SizedBox(
                                                    height: 12,
                                                  ),
                                                  new Text(DateFormat('dd-MMM-yyyy').format(snapshot.data[index].data['date'].toDate()).toString(), style: new TextStyle( color:Colors.white,fontWeight: FontWeight.bold, fontSize: 14),),
                                                ],
                                              ),
                                            ],
                                          ),


                                        ),


                                      ),
                                    ),
                                  );

                                }
                            ),
                          );

                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
