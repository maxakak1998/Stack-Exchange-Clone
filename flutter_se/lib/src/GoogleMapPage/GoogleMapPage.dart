import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_se/src/Feed/FeedPage.dart';
import 'package:flutter_se/src/GoogleMapPage/GoogleMapBloc/Bloc.dart';
import 'package:flutter_se/src/GoogleMapPage/GoogleMapBloc/Events.dart';
import 'file:///E:/Source_Tree/flutter/flutter_se/lib/src/GoogleMapPage/GoogleMapDrawer.dart';
import 'package:flutter_se/src/GoogleMapPage/GoogleMapBloc/State.dart';
import 'package:flutter_se/src/Splash_Page/AppManager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:location/location.dart';
import 'package:google_directions_api/google_directions_api.dart';

import 'User.dart';

class GoogleMapPage extends StatefulWidget {
  static String routeName = "/GoogleMapPage";
  static WidgetBuilder routeBuilder = (BuildContext context) {
    return GoogleMapPage();
  };
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapPage> {
  Location _location;
  GoogleMapController mapController;
  bool isLocationPermissionEnable;
  GoogleMapBloc _googleMapBloc;
  DirectionsService directionsService;
  GlobalKey<ScaffoldState> globalKey;
  int activeIndexDrawer;
  AppManager _appManager;
  final LatLng _vn = const LatLng(10.762622, 106.660172);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    activeIndexDrawer = -1;
    globalKey = new GlobalKey<ScaffoldState>();
    DirectionsService.init("AIzaSyCtZLm9u2YD9zGNQBFdDh32CAY73ute6xs");
    directionsService = new DirectionsService();
    isLocationPermissionEnable = false;
    _googleMapBloc = context.bloc<GoogleMapBloc>();
    _location = new Location();
    _appManager = new AppManager();
    if (_appManager.userId != null) {
      _googleMapBloc.onLoadHistoryData();
    }
  }

  Widget createArriveWidget(GoogleMapState state) {
    return FlatButton(
      disabledTextColor: Colors.grey,
      textColor: Colors.yellow,
      color: Colors.blue[600],
      child: Row(
        children: <Widget>[
          Text(
            "Arrive",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      ),
      onPressed: state.isLocationPermissionEnable
          ? () async {
              bool isLocationEnabled = await _location.requestService();
              if (isLocationEnabled) {
                activeIndexDrawer = -1;

                _onStartArriving();
              }
            }
          : null,
    );
  }

  Widget createCompletedWidget(User user) {
    return InkWell(
      onTap: () {
        _onCompleted(user);
      },
      child: Container(
        margin: EdgeInsets.only(right: 16.0),
        child: Icon(
          Icons.done_all,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil(ModalRoute.withName(FeedPage.routeName));
        return true;
      },
      child: BlocConsumer<GoogleMapBloc, GoogleMapState>(
        listener: (BuildContext context, state) {
//        test(state);
          if (state.isCompleted) {
            SnackBar snackBar;
            if (state.error.isEmpty) {
              snackBar = SnackBar(content: Text('Saved successfully'));
              globalKey.currentState.showSnackBar(snackBar);
            } else {
              snackBar = SnackBar(content: Text(state.error));
              globalKey.currentState.showSnackBar(snackBar);
            }
          }
          if (state is GoogleMapState) {
            LocationData locationData;
            CameraUpdate cameraUpdate;
            double zoom;

            if (state.isArriving) {
              print("IS arrving");
              locationData = state.user.markers.last.locationData;
              zoom = 12;
              print("Zoom is $zoom");
              cameraUpdate = CameraUpdate.newLatLngZoom(
                  new LatLng(locationData.latitude, locationData.longitude),
                  zoom);
              mapController.animateCamera(cameraUpdate);
            } else {
              if (state.user.markers.isNotEmpty) {
                locationData = state.user.markers.first.locationData;
                zoom = 15;
                cameraUpdate = CameraUpdate.newLatLngZoom(
                    new LatLng(locationData.latitude, locationData.longitude),
                    zoom);
                mapController.animateCamera(cameraUpdate);
              }
            }
          }
        },
        builder: (BuildContext context, state) {
          return Scaffold(
              drawer: GoogleMapDrawer(_googleMapBloc, activeIndexDrawer,
                  saveCurrentIndexDrawer, state?.firebaseDatabaseHolderData),
              key: globalKey,
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: state.isArriving ? Colors.blue : Colors.grey,
                onPressed: state.isArriving
                    ? () async {
                        activeIndexDrawer = -1;

                        await _checkIn();
                      }
                    : null,
                label: Text(
                  "Check in",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              appBar: AppBar(
                actions: <Widget>[
                  state.isArriving
                      ? createCompletedWidget(state.user)
                      : createArriveWidget(state)
                ],
                title: Text("Google map"),
              ),
              body: GoogleMap(
                polylines: {
                  Polyline(
                    geodesic: true,
                    color: Colors.blue,
                    width: 2,
                    polylineId: PolylineId("Line 1"),
                    visible: true,
                    endCap: Cap.roundCap,
                    startCap: Cap.roundCap,
                    points: getLangLngList(state),
                  )
                },
                markers: getMarkerSet(state),
                myLocationEnabled: state.isLocationPermissionEnable,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(target: _vn, zoom: 8),
              ));
        },
      ),
    );
  }

  saveCurrentIndexDrawer(int index) {
    setState(() {
      activeIndexDrawer = index;
    });
  }

  Future<void> _checkIn() async {
    print("Check in");
    LocationData data = await _location.getLocation();
    _googleMapBloc.onCheckIn(data);
  }

  void _onStartArriving() async {
    print("Start arriving");
    LocationData data = await _location.getLocation();

    print("Current location is $data");

    _googleMapBloc.onStartArriving(data);
  }

  void _onCompleted(User user) {
    _googleMapBloc.onCompleted(user);
  }

  void test(GoogleMapState state) {
    List<DirectionsWaypoint> _wayPoints = new List<DirectionsWaypoint>();
    if (state.user.markers.length <= 2) {
      _wayPoints = [];
    } else {
      _wayPoints = state.user.markers
          .getRange(1, state.user.markers.length - 1)
          .toList()
          .map((marker) => DirectionsWaypoint(
              location:
                  "${marker.locationData.latitude},${marker.locationData.longitude}"));
    }

    DirectionsRequest request = DirectionsRequest(
        origin:
            "${state.user.markers.first.locationData.latitude},${state.user.markers.first.locationData.longitude}",
        destination:
            "${state.user.markers.last.locationData.latitude},${state.user.markers.last.locationData.longitude}",
        waypoints: _wayPoints);

    directionsService.route(request,
        (DirectionsResult response, DirectionsStatus status) {
      if (status == DirectionsStatus.ok) {
        print("Success ");
      } else {
        print("Failed");
        // do something with error response
      }
    });
  }

  List<LatLng> getLangLngList(GoogleMapState state) {
    return state.user.markers.map((marker) {
      return LatLng(
          marker.locationData.latitude, marker.locationData.longitude);
    }).toList();
  }

  Set<Marker> getMarkerSet(GoogleMapState state) {
    return state.user.markers
        .map((marker) => Marker(
              markerId: MarkerId(state.user.markers.indexOf(marker).toString()),
              position: LatLng(
                  marker.locationData.latitude, marker.locationData.longitude),
            ))
        .toSet();
  }
}
