import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_tracker/commons/constants.dart';
import 'package:flutter/material.dart';

import '../commons/state_enum.dart';
import '../models/user_model.dart';
import '../services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthServices services = AuthServices();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  LoginState? _loginstate;
  LoginState? get loginstate => _loginstate;

  bool? _isLoggedIn;
  bool? get isLoggedIn => _isLoggedIn;

  RequestState _updateProfileState = RequestState.empty;
  RequestState get updateProfileState => _updateProfileState;

  RequestState _detailProfileState = RequestState.empty;
  RequestState get detailProfileState => _detailProfileState;

  String _message = '';
  String get message => _message;

  Future<void> statusLogin() async {
    try {
      _loginstate = LoginState.loading;
      notifyListeners();

      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          _isLoggedIn = false;
          _loginstate = LoginState.loggedOut;
          notifyListeners();
        } else {
          _isLoggedIn = true;
          _currentUser = UserModel(
            uid: user.uid,
            email: user.email!,
            displayName: user.displayName,
          );
          _loginstate = LoginState.loggedIn;
          notifyListeners();
        }
      });
    } catch (e) {
      _isLoggedIn = false;
      _loginstate = LoginState.error;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _state = RequestState.loading;
      notifyListeners();

      final credential = await services.signIn(email, password);

      _currentUser = credential;
      _state = RequestState.hasData;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        _message = 'Wrong password provided for that user.';
      }
      _state = RequestState.error;
      notifyListeners();
    } catch (e) {
      _message = MessageConst.error;
      _state = RequestState.error;
      debugPrint(e.toString());
      notifyListeners();
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      _state = RequestState.loading;
      notifyListeners();

      final credential = await services.signUp(name, email, password);

      _currentUser = credential;
      _state = RequestState.hasData;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _message = 'The account already exists for that email.';
      }
      _state = RequestState.error;
      notifyListeners();
    } catch (e) {
      _message = MessageConst.error;
      _state = RequestState.error;
      debugPrint(e.toString());
      notifyListeners();
    }
  }

  Future<void> getDetailProfile(String uid) async {
    try {
      _detailProfileState = RequestState.loading;
      notifyListeners();
      _currentUser = await services.getDetailUser(uid);
      _detailProfileState = RequestState.hasData;
      notifyListeners();
    } catch (e) {
      _detailProfileState = RequestState.error;
      notifyListeners();
      _message = MessageConst.error;
    }
  }

  Future<void> updateProfile(UserModel userModel) async {
    try {
      _updateProfileState = RequestState.loading;
      notifyListeners();
      await services.updateUser(userModel);
      _updateProfileState = RequestState.hasData;
      notifyListeners();
    } catch (e) {
      _updateProfileState = RequestState.error;
      notifyListeners();
      _message = MessageConst.error;
    }
  }

  Future<void> signOut() async {
    _state = RequestState.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    await services.signOut();
    _currentUser = null;
    _state = RequestState.empty;
    notifyListeners();
  }
}
