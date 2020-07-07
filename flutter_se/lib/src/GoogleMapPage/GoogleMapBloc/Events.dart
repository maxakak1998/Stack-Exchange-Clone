import 'package:location/location.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";

import '../User.dart';

abstract class GoogleMapEvent {}

class RequirePermissionEvent extends GoogleMapEvent {}

class StartArrivingEvent extends GoogleMapEvent {
  LocationData locationData;

  StartArrivingEvent(this.locationData);
}

class CompletedEvent extends GoogleMapEvent {
  User user;

  CompletedEvent(this.user);
}

class CheckInEvent extends GoogleMapEvent {
  LocationData locationData;

  CheckInEvent(this.locationData);
}

class ShowHistoryEvent extends GoogleMapEvent {
  List<LatLng> latLngList;
  ShowHistoryEvent(this.latLngList);
}

class LoadHistoryDataEvent extends GoogleMapEvent {}
