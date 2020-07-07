import 'package:flutter_se/src/GoogleMapPage/User.dart';
import 'package:flutter_se/src/Splash_Page/AppManager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../FirebasDatabaseHolder.dart';
import '../UserMarker.dart';

class Repo {
  final int GRANTED_CODE = 0;
  final int DENIED_CODE = 1;
  final int RESTRICTED_CODE = -1;
  final int PERMANENTLY_DENIED_CODE = 2;
  final AppManager appManager = new AppManager();
  Future<bool> checkPermission() async {
    print("Asking user for the permissions");
    PermissionStatus status = await Permission.location.status;
    print("Status is $status");
    if (status.isGranted) {
      return true;
    } else {
      //request permission
      int code = await requestPermission();
      if (code == 0) {
        return true;
      }
      return false;
    }
  }

  Future<int> requestPermission() async {
    print("Request permision");
    final request = await Permission.location.request();

    if (request.isGranted) {
      return GRANTED_CODE;
    } else if (request.isDenied) {
      return DENIED_CODE;
    } else if (request.isPermanentlyDenied) {
      return PERMANENTLY_DENIED_CODE;
    } else if (request.isRestricted) {
      return RESTRICTED_CODE;
    }
    return null;
  }

  Future<bool> saveDataToFirebase(User user) async {
    try {
      final listIdentifier =
          user.markers.first.locationData.time.toInt().toString();

      for (UserMarker userMarker in user.markers) {
        appManager.firebaseApp
            .child(user.id)
            .child(listIdentifier)
            .push()
            .update(getMap(userMarker));
      }
      return true;
    } catch (e) {
      print("Save data to firebase database failed - ${e.toString()}");
      return false;
    }
  }

  Future<FirebaseDatabaseHolder> getDataFromFirebase() async {
    // if(appManager.transitionsHistory!=null){}
    Map<dynamic, dynamic> values;

    print("Firebase app is ${appManager.firebaseApp}");
    values =
        (await appManager.firebaseApp.child(appManager.userId).once()).value;

    return new FirebaseDatabaseHolder.fromMap(values);
  }

  Map<String, dynamic> getMap(UserMarker userMarker) {
    Map<String, dynamic> map = new Map<String, dynamic>()
      ..["lat"] = userMarker.locationData.latitude.toString()
      ..["lng"] = userMarker.locationData.longitude.toString();
    print(map);
    return map;
  }
}
