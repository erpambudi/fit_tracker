import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final collection = FirebaseFirestore.instance.collection('users');

  UserModel? _currentUser(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(
        uid: user.uid, email: user.email!, displayName: user.displayName);
  }

  Future<UserModel?> signIn(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    if (credential.user != null) {
      return _currentUser(credential.user);
    } else {
      throw FirebaseAuthException;
    }
  }

  Future<UserModel?> signUp(String name, String email, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (credential.user != null) {
      late UserModel userModel;

      await credential.user!.updateDisplayName(name).whenComplete(() {
        userModel = UserModel(
          uid: _auth.currentUser!.uid,
          email: _auth.currentUser!.email!,
          displayName: _auth.currentUser!.displayName,
        );
      });

      //add new user to firestore
      await collection.doc(credential.user!.uid).set(userModel.toJson());
      return userModel;
    } else {
      throw FirebaseAuthException;
    }
  }

  Future<UserModel> getDetailUser(String uid) async {
    try {
      final doc = await collection.doc(uid).get();
      return UserModel.fromDocument(doc);
    } catch (e) {
      throw Exception("Error get detail user");
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await collection.doc(user.uid).update(user.completedProfileToJson());
    } catch (e) {
      throw Exception("Error updating user");
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
