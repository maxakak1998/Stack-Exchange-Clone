import 'dart:developer';

import 'package:flutter/cupertino.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_se/src/AppBloc/Bloc.dart';
import 'package:flutter_se/src/Splash_Page/AppManager.dart';
import 'package:flutter_se/src/common/Site.dart';

import 'Events.dart';
import 'State.dart';
import "Repo.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final storage = new FlutterSecureStorage();
  final AppManager appManager = new AppManager();
  SplashBloc(this._appBloc);
  AppBloc _appBloc;
  Repo repo;
  List<Site> sites;
  @override
  get initialState => InitializeState();

  void onLoadingForGuest({int page, int pageSize}) {
    add(new PrepareForFeedPageEvent(page: page, pageSize: pageSize));
  }

  void onSingInWithFacebook() {
    add(LoginWithFacebookEvent());
  }

  void onSingInWithGoogle() {
    add(LoginWithGoogleEvent());
  }

  void onSingInWithStackExchange(BuildContext context) {
    add(LoginWithStackExchangeEvent(context));
  }

  void onAddingIdToFBDatabase() async {
    String userId = await repo.getUserIdFromFb();
    assert(userId != null,
        "Can't get user id from facebook. It may lead to fail registerd on firebase database");
    appManager.userId = userId;
    print("User id from fb is ${appManager.userId}");
  }

  void onAddingIdToGoogleDatabase() async {
    String userId = await repo.getUserIdFromGoogle();
    assert(userId != null,
        "Can't get user id from facebook. It may lead to fail registerd on firebase database");
    appManager.userId = userId;
    print("User id from fb is ${appManager.userId}");
  }

  void onAddingIdToSEDatabase() async {
    String userId = await repo.getUserIdFromSE();
    assert(userId != null,
        "Can't get user id from facebook. It may lead to fail registerd on firebase database");
    appManager.userId = userId;
    print("User id from fb is ${appManager.userId}");
  }

  @override
  Stream<SplashState> mapEventToState(event) async* {
    repo = new Repo(_appBloc);

    if (event is LoginWithFacebookEvent) {
      print("Log in with Facebok");
      try {
        FirebaseUser user = await repo.signInWithFacebook();
        if (user != null) {
          print("User is not null");
          saveData(user, "fb");
          await onAddingIdToFBDatabase();
          yield LoggedSuccess();
        }
      } catch (e) {
        yield LoggedFail("Login failed: ${e.toString()}");
      }
    }
    if (event is LoginWithGoogleEvent) {
      print("Log in with Google ");
      try {
        FirebaseUser user = await repo.signInWithGoogle();
        if (user != null) {
          saveData(user, "google");
          onAddingIdToGoogleDatabase();
          yield LoggedSuccess();
        }
      } catch (e) {
        print("Logged fail ${e.toString()}");
        yield LoggedFail("Login failed: ${e.toString()}");
      }
    }
    if (event is LoginWithStackExchangeEvent) {
      print("Log in with SE");
      Map<String, String> token =
          await repo.signInWithStackExchange(event.context);
      if (token != null) {
        saveAccessToken(token, "se");
        String name = await repo.fetchUserInfoSE();
        log("User name is $name");
        if (name != null) {
          _appBloc.userName = name;
          saveData(null, "se", name: name);
          onAddingIdToSEDatabase();
          yield LoggedSuccess();
        } else {
          yield LoggedFail("Login failed:  Cant get user information");
        }
      } else {
        yield LoggedFail("Login failed:  Token is null");
      }
    }
  }

  saveData(FirebaseUser user, String type, {String name}) async {
    _appBloc.userName = user == null ? name : user.displayName;
    await storage.write(
        key: "userName", value: user == null ? name : user.displayName);
    await storage.write(key: "type", value: type);
  }

  void saveAccessToken(Map<String, String> token, String loginType) {
    if (token != null) {
      String access_token = token[AppBloc.ACCESS_TOKEN];
      log("token[AppBloc.ACCESS_TOKEN_EXPIRATION] ${token[AppBloc.ACCESS_TOKEN_EXPIRATION]}");
      int tokenExpire = int.parse(token[AppBloc.ACCESS_TOKEN_EXPIRATION]);
      int now = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
      int expire = now + tokenExpire;
      //save to bloc
      _appBloc.access_token = access_token;

      //save to storage
      storage.write(key: AppBloc.ACCESS_TOKEN, value: access_token);

      storage.write(
          key: AppBloc.ACCESS_TOKEN_EXPIRATION, value: expire.toString());
    }
  }
}
