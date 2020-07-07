import 'package:flutter_se/src/common/Site.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SplashState {}

class InitializeState extends SplashState {}

class Loading extends SplashState {}

class LoggedSuccess extends SplashState {
//  FirebaseUser user;
//
//  LoggedSuccess(this.user);
}

class LoggedFail extends SplashState {
  String error;

  LoggedFail(this.error);
}
