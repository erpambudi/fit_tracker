import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignUpFormValidatorProvider extends ChangeNotifier {
  bool _isValidName = false;
  bool get isValidName => _isValidName;

  bool _isValidEmail = false;
  bool get isValidEmail => _isValidEmail;

  bool _isPasswordEightCharacters = false;
  bool get isPasswordEightCharacters => _isPasswordEightCharacters;

  bool _hasPasswordOneNumber = false;
  bool get hasPasswordOneNumber => _hasPasswordOneNumber;

  bool _isSamePassword = false;
  bool get isSamePassword => _isSamePassword;

  bool _isVisiblePassword = true;
  bool get isVisiblePassword => _isVisiblePassword;

  onNameChanged(String name) {
    _isValidName = name.length > 3;
    notifyListeners();
  }

  onEmailChanged(String email) {
    _isValidEmail = EmailValidator.validate(email);
    notifyListeners();
  }

  onPasswordChanged(String password1, String password2) {
    final numericRegex = RegExp(r'[0-9]');

    _isPasswordEightCharacters = false;
    if (password1.length >= 8) _isPasswordEightCharacters = true;

    _hasPasswordOneNumber = false;
    if (numericRegex.hasMatch(password1)) _hasPasswordOneNumber = true;

    _isSamePassword = false;
    if (password1 == password2) _isSamePassword = true;
    notifyListeners();
  }

  onPasswordDifferent(String password1, String password2) {
    _isSamePassword = false;
    if (password1 == password2) _isSamePassword = true;
    notifyListeners();
  }

  onChangeVisiblePassword() {
    _isVisiblePassword = !_isVisiblePassword;
    notifyListeners();
  }

  onReset() {
    _isValidName = false;
    _isValidEmail = false;
    _isPasswordEightCharacters = false;
    _hasPasswordOneNumber = false;
    _isSamePassword = false;
    _isVisiblePassword = true;
    notifyListeners();
  }
}

class SignInFormValidatorProvider extends ChangeNotifier {
  bool _isValidEmail = false;
  bool get isValidEmail => _isValidEmail;

  bool _isVisiblePassword = true;
  bool get isVisiblePassword => _isVisiblePassword;

  bool _isNotEmptyPassword = false;
  bool get isNotEmptyPassword => _isNotEmptyPassword;

  onEmailChanged(String email) {
    _isValidEmail = EmailValidator.validate(email);
    notifyListeners();
  }

  onChangeVisiblePassword() {
    _isVisiblePassword = !_isVisiblePassword;
    notifyListeners();
  }

  onPasswordChanged(String password) {
    _isNotEmptyPassword = false;
    if (password.isNotEmpty) _isNotEmptyPassword = true;
    notifyListeners();
  }

  onReset() {
    _isValidEmail = false;
    _isVisiblePassword = true;
    _isNotEmptyPassword = false;
    notifyListeners();
  }
}
