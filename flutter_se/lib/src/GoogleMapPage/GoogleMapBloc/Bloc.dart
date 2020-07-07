import 'package:flutter/material.dart';
import 'package:flutter_se/src/GoogleMapPage/FirebasDatabaseHolder.dart';
import 'package:flutter_se/src/GoogleMapPage/GoogleMapBloc/Events.dart';
import 'package:flutter_se/src/GoogleMapPage/GoogleMapBloc/State.dart';
import "package:bloc/bloc.dart";
import 'package:flutter_se/src/GoogleMapPage/Location.dart';
import 'package:flutter_se/src/GoogleMapPage/User.dart';
import 'package:flutter_se/src/GoogleMapPage/UserMarker.dart';
import 'package:flutter_se/src/Splash_Page/AppManager.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import "Repo.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

class GoogleMapBloc extends Bloc<GoogleMapEvent, GoogleMapState> {
  @override
  GoogleMapState get initialState => GoogleMapState(
      user: new User()
        ..id = AppManager().userId
        ..markers = new List<UserMarker>(),
      firebaseDatabaseHolderData: new FirebaseDatabaseHolder());
  Repo repo = new Repo();

  @override
  Stream<GoogleMapState> mapEventToState(GoogleMapEvent event) async* {
    User user = state.user;
    if (event is RequirePermissionEvent) {
      print("Reuire permissions");
//      User _user = new User()
//        ..id = AppManager().userId
//        ..markers = new List<UserMarker>();
      bool locationPermissionStatus = await repo.checkPermission();
      yield GoogleMapState(
          isLocationPermissionEnable: locationPermissionStatus,
          user: user,
          firebaseDatabaseHolderData: state.firebaseDatabaseHolderData);
    }
    if (event is StartArrivingEvent) {
      user.markers.clear();
      user.markers.add(new UserMarker(event.locationData));

      yield GoogleMapState(
          isLocationPermissionEnable: state.isLocationPermissionEnable,
          isArriving: true,
          user: user,
          firebaseDatabaseHolderData: state.firebaseDatabaseHolderData);
    }
    if (event is CompletedEvent) {
      //save data to firebase
      bool success = false;
      if (AppManager().userId != null) {
        success = await repo.saveDataToFirebase(event.user);
      }

      if (success)
        yield GoogleMapState(
            isLocationPermissionEnable: state.isLocationPermissionEnable,
            isArriving: false,
            user: user..markers.clear(),
            isCompleted: true,
            firebaseDatabaseHolderData: await repo.getDataFromFirebase());
      else
        yield GoogleMapState(
            isLocationPermissionEnable: state.isLocationPermissionEnable,
            isArriving: false,
            user: user,
            error: AppManager().userId == null
                ? "You need to login to save your history"
                : "Failed to save your history",
            isCompleted: true,
            firebaseDatabaseHolderData: state.firebaseDatabaseHolderData);
    }
    if (event is CheckInEvent) {
      user.markers.add(new UserMarker(event.locationData));
      print("Length is ${user.markers.length}");
      yield GoogleMapState(
          isLocationPermissionEnable: state.isLocationPermissionEnable,
          isArriving: true,
          user: user,
          firebaseDatabaseHolderData: state.firebaseDatabaseHolderData);
    }
    if (event is ShowHistoryEvent) {
      user.markers.clear();

      event.latLngList.forEach((element) {
        Map<String, double> dataMap = new Map<String, double>();
        dataMap['latitude'] = element.latitude;
        dataMap['longitude'] = element.longitude;
        dataMap['accuracy'] = 0;
        dataMap['altitude'] = 0.0;
        dataMap['speed'] = 0;
        dataMap['speed_accuracy'] = 0;
        dataMap['heading'] = 0;
        dataMap['time'] = 0;
        LocationData locationData = LocationData.fromMap(dataMap);
        user.markers.add(new UserMarker(locationData));
      });

      yield GoogleMapState(
          isLocationPermissionEnable: state.isLocationPermissionEnable,
          isArriving: false,
          user: user,
          firebaseDatabaseHolderData: state.firebaseDatabaseHolderData);
    }
    if (event is LoadHistoryDataEvent) {
      print("Load history user data from firebase");
      FirebaseDatabaseHolder firebaseDatabaseHolderData =
          await repo.getDataFromFirebase();

      yield GoogleMapState(
          isLocationPermissionEnable: state.isLocationPermissionEnable,
          isArriving: false,
          user: user,
          firebaseDatabaseHolderData: firebaseDatabaseHolderData);
    }
    yield state;
  }

  void onCompleted(User user) {
    add(CompletedEvent(user));
  }

  void onRequiringPermission() {
    add(RequirePermissionEvent());
  }

  void onStartArriving(LocationData startLocation) {
    add(StartArrivingEvent(startLocation));
  }

  void onCheckIn(LocationData checkInLocation) {
    add(CheckInEvent(checkInLocation));
  }

  void onShowHistory(List<LatLng> latLngList) {
    add(ShowHistoryEvent(latLngList));
  }

  void onLoadHistoryData() {
    add(LoadHistoryDataEvent());
  }
}
