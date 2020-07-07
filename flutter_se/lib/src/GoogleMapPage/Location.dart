import "package:google_maps_flutter/google_maps_flutter.dart";

class Location {
  int timeStamp;
  List<LatLng> latLngList;
  Location(this.timeStamp, this.latLngList);
}
