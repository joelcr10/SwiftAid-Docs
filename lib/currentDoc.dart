import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proapp/main.dart';

class DoctorsDoc {
  String currentDocId = '';
  String dob = '';
  String name = '';
  String id = '';
  String specialization = '';
  String email = '';
  String phone = '';

  set setCurrentDocId(String doctorId) {
    currentDocId = doctorId;
  }

  String get getCurrentDocId {
    return currentDocId;
  }
}

class Doctor {}
