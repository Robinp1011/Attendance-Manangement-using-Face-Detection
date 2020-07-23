import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class User {
    String email;
    String password;

  DocumentReference reference;


  User(String email, String password) {
    this.email = email;
    this.password = password;
  }


  User.fromMap(Map<String, dynamic> map, {this.reference}) {
    email = map["email"];
    password = map["password"];
  }

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

}

