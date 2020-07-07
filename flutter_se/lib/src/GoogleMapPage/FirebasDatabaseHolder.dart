import 'Location.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";

class FirebaseDatabaseHolder {
  List<Location> transitionsHistory = new List<Location>();
  FirebaseDatabaseHolder();
  FirebaseDatabaseHolder.fromMap(Map values) {
    print("From map constructor");
    values?.forEach((key, value) {
      int timeStamp = int.parse(key);
      List<LatLng> latLngList = new List<LatLng>();
      Map<dynamic, dynamic> latLngValues = value;
      latLngValues.forEach((key, latLngValue) {
        double lat = double.tryParse(latLngValue["lat"]);
        double lng = double.tryParse(latLngValue["lng"]);
        latLngList.add(new LatLng(lat, lng));
      });

      Location location = new Location(timeStamp, latLngList);
      transitionsHistory.add(location);
    });
  }
//  FirebaseDatabaseHolder(this.timeStamp, this.latLngList);
}
