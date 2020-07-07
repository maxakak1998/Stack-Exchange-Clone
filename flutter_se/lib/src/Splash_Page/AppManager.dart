import 'package:flutter_se/src/GoogleMapPage/Location.dart';
import 'package:flutter_se/src/common/Site.dart';
import 'package:firebase_database/firebase_database.dart';

class AppManager {
  List<Site> allSites;
  DatabaseReference firebaseApp;
  String userId;
  List<Location> transitionsHistory;

  void clear() {
    allSites = null;
    userId = null;
    transitionsHistory = null;
  }

  static AppManager _instance = new AppManager._internal();

  factory AppManager() {
    return _instance;
  }
  AppManager._internal();
}
