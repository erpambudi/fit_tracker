import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? gender;
  final DateTime? birthdate;
  final double? height;

  UserModel({
    this.uid,
    this.email,
    this.displayName,
    this.gender,
    this.birthdate,
    this.height,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'gender': gender,
      'birthdate': birthdate != null ? birthdate!.millisecondsSinceEpoch : null,
      'height': height,
    };
  }

  Map<String, dynamic> completedProfileToJson() {
    return {
      'gender': gender,
      'birthdate': birthdate != null ? birthdate!.millisecondsSinceEpoch : null,
      'height': height,
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return UserModel(
      uid: documentSnapshot['uid'],
      email: documentSnapshot['email'],
      displayName: documentSnapshot['displayName'],
      gender: documentSnapshot['gender'],
      birthdate:
          DateTime.fromMillisecondsSinceEpoch(documentSnapshot['birthdate']),
      height: documentSnapshot['height'],
    );
  }
}
