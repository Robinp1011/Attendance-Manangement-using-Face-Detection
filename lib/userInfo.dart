import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UserInfo {
  String name;
  String imageUrl;
  String longitude;
  String latitude;
  DateTime date;
  String mode;

  DocumentReference reference;


  UserInfo(String name, String imageUrl, String longitude, String latitude, DateTime date, String mode) {
    this.name = name;
    this.imageUrl = imageUrl;
    this.longitude = longitude;
    this.latitude = latitude;
    this.date =date;
    this.mode = mode;
  }


  UserInfo.fromMap(Map<String, dynamic> map, {this.reference}) {
    name = map["name"];
    imageUrl= map["imageUrl"];
    longitude = map["longitude"];
    latitude = map["latitude"];
    date = map["date"];
    mode = map["mode"];
  }

  UserInfo.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'longitude':longitude,
      'latitude':latitude,
       'date':date,
      'mode':mode
    };
  }

}