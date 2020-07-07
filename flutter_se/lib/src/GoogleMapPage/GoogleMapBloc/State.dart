import 'package:flutter_se/src/GoogleMapPage/FirebasDatabaseHolder.dart';
import 'package:flutter_se/src/GoogleMapPage/User.dart';

class GoogleMapState {
  bool isLocationPermissionEnable;
  bool isArriving;
  User user;
  String error;
  bool isCompleted;
  FirebaseDatabaseHolder firebaseDatabaseHolderData;
  GoogleMapState(
      {this.isCompleted = false,
      this.isLocationPermissionEnable = false,
      this.isArriving = false,
      this.user,
      this.error = "",
      this.firebaseDatabaseHolderData});
}
