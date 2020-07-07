import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_se/src/Splash_Page/AppManager.dart';
import 'package:flutter_se/src/common/Site.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_se/src/common/Service.dart';
import 'Bloc.dart';
import "package:http/http.dart" as http;
import "dart:convert" as convert;
import "package:flutter_se/src/Splash_Page/SplashBloc/Repo.dart" as SplashRepo;
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Repo {
  final storage = new FlutterSecureStorage();
  Future<String> getClientIDKey(String CLIENT_ID) async {
    String client_id = await storage.read(key: CLIENT_ID);
    return client_id;
  }

  Future<Map<String, String>> getAccessToken(
      String ACCESS_TOKEN, String ACCESS_TOKEN_EXPIRATION) async {
    String access_token = await storage.read(key: ACCESS_TOKEN);
    String expire = await storage.read(key: ACCESS_TOKEN_EXPIRATION);

    return new Map<String, String>()
      ..[AppBloc.ACCESS_TOKEN] = access_token
      ..[AppBloc.ACCESS_TOKEN_EXPIRATION] = expire;
  }

  Future<String> getLoginType() async {
    String type = await storage.read(key: "type");
    return type;
  }

  Future<String> getClientKey(String CLIENT_KEY) async {
    String client_secret = await storage.read(key: CLIENT_KEY);
    return client_secret;
  }

  Future<bool> preLoad(String CLIENT_ID, String CLIENT_KEY) async {
    if (await storage.read(key: CLIENT_ID) == null) {
      await storage.write(key: CLIENT_ID, value: "17798");
    }
    if (await storage.read(key: CLIENT_KEY) == null) {
      await storage.write(key: CLIENT_KEY, value: "HWQjCKh8dOflvnkEa5TUrg\(\(");
    }
  }

  Future<String> getUserName() async {
    final userName = await storage.read(key: "userName");
    return userName;
  }

  Future<void> clearStorage() async {
    await storage.deleteAll();
  }

  Future<List<Site>> onLoadingAllSites(SplashRepo.Repo splashRepo) async {
    List<Site> allSites = await splashRepo.getSites(null, 999);
    return allSites;
  }

  Future<bool> invalidateSEToken(String token) async {
    String api = Service.getInvalidateSETokenAPi(token);
    final response = await http.get(api);
    if (response.statusCode == 200) {
      List<dynamic> body = convert.jsonDecode(response.body)["items"];
      if (body.length > 0) {
        return true;
      }
    }
    return false;
  }

  Future<bool> invalidateFbToken(String token) async {
    String api = Service.getInvalidateFBTokenAPi(token);
    final response = await http.delete(api);
    if (response.statusCode == 200) {
      bool success = convert.jsonDecode(response.body)["success"];
      if (success) {
        return true;
      }
    }
    return false;
  }

  Future<void> firebaseDatabaseConfig() async {
    WidgetsFlutterBinding.ensureInitialized();
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'se-app-278202',
      options: Platform.isIOS
          ? const FirebaseOptions(
              googleAppID: '1:261503602966:ios:5538de2c462230a3554037',
              gcmSenderID: '261503602966',
              databaseURL: 'https://se-app-278202.firebaseio.com',
            )
          : const FirebaseOptions(
              googleAppID: '1:261503602966:android:a530baa0b62b7a14554037',
              apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
              databaseURL: 'https://se-app-278202.firebaseio.com',
            ),
    );

    AppManager().firebaseApp = FirebaseDatabase(app: app).reference();
    print("App bloc firebase database is ${AppManager().firebaseApp}");
  }
}
