import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import "package:http/http.dart" as http;
import "dart:convert" as convert;

abstract class SplashEvent {}

class PrepareForFeedPageEvent extends SplashEvent {
  int page, pageSize;
  PrepareForFeedPageEvent({this.page, this.pageSize});
}

class LoginWithFacebookEvent extends SplashEvent {}

class LoginWithGoogleEvent extends SplashEvent {}

class LoginWithStackExchangeEvent extends SplashEvent {
  BuildContext context;

  LoginWithStackExchangeEvent(this.context);
}
