import 'dart:async';



import 'package:flutter/material.dart';

import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/Buttons.dart';
import 'package:flutter_projects/helper_clesses/Dialog/CustomDialog.dart';
import 'package:flutter_projects/helper_clesses/LoadingScreen.dart';
import 'package:flutter_projects/helper_clesses/TextInput/TextFieldHelper.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:provider/provider.dart';

class PointerLocation extends StatefulWidget {
  @override
  State<PointerLocation> createState() => PointerLocationState();
}

class PointerLocationState extends State<PointerLocation> {
  Completer<GoogleMapController> _controller = Completer();
  List markers = [];

  bool visible = false;
  LatLng tapped;
  String comments;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  static CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(41.2995, 69.2401), zoom: 10.151926040649414);

  static CameraPosition _point;

  @override
  void initState() {
    super.initState();

    SingletonConnection().getLocation().then((value) {
      print(value);
      if (value) {
        Location location = SingletonUserInformation().newCard.attach.location;
        double latitude = location.latitude;
        double longitude = location.longitude;
        String comments = location.comment;
        print("ACCEPT ${location.toJson()}");
        LatLng position = new LatLng(latitude, longitude);
        gettinLocation(position);
        _addMarker(comments, position);
      }
      setState(() {
        visible = true;
      });
    });
  }

  void gettinLocation(LatLng event) {
    setState(() {
      LatLng position = event;

      _kGooglePlex = CameraPosition(
        target: position,
        zoom: 14.4746,
      );
    });
  }

  void _addMarker(String value, LatLng tappedPoint) {
    comments = value;
    markers.add(
      Marker(
        position: tappedPoint,
        markerId: MarkerId(tappedPoint.toString()),
        infoWindow: InfoWindow(title: value),
      ),
    );
    tapped = tappedPoint;
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      markers.clear();
      final double width = MediaQuery.of(context).size.width;
      final result = CustomDialog.dialog(
          width: width,
          context: context,
          barrierDismissible: false,
          child: Comments());
      result.then((value) {
        print(value);
        setState(() {
          _addMarker(value, tappedPoint);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor("#F0F8FF"),
      body: Stack(
        children: [
          Center(
            child: LoadingScreen(
              visible: !visible,
            ),
          ),
          Visibility(
            visible: visible,
            child: GoogleMap(
                markers: Set.from(markers),
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onLongPress: _handleTap),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToPoint,
        child: Icon(Icons.save_alt_outlined),
      ),
    );
  }

  Future<void> _goToPoint() async {
    Location location = SingletonUserInformation().newCard.attach.location;
    location.setComments(comments);
    location.setLatitude(tapped.latitude);
    location.setLongitude(tapped.longitude);
    print("Exit pointer ${location.toJson()}");
    Navigator.of(context).pop();
  }
}

class Comments extends StatelessWidget {
  final ErrorMessageProvider text = ErrorMessageProvider("");

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider.value(
      value: text,
      child: Container(
        width: width * 0.8,
        height: width * 0.4,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(width * 0.2)),
            margin: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Комментарий",
                        style: TextStyle(
                            color: HexColor("#42424A"),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.03,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Expanded(child: TextFieldHelper()),
                  ],
                ),
                Buttons(
                  onPressed: (context) =>
                      Navigator.of(context).pop(text.inputData),
                  hexValueOFColor: "#7FA5C9",
                  nameOfTheButton: "Ок",
                  height: width * 0.8,
                  width: width * 0.4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
