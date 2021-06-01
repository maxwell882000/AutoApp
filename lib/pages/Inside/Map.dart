import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';


class Map extends StatefulWidget {
  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng position;
  List markers = [];

  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];

  Set<Polyline> _polyLine = {};

  bool visible = false;
  double meter;
  LatLng previous;
  LatLng tapped;
  // Location location = new Location();
  //
  // Future<void> _location() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return null;
  //     }
  //   }
  //
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return null;
  //     }
  //   }
  //
  // }

  // _createPolylines(LatLng start, LatLng destination) async {
  //   // Initializing PolylinePoints
  //   polylinePoints = PolylinePoints();
  //
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyBPgRiIxr72VmqjP7mixV-ozfn7NUv2f6Y", // Google Maps API Key
  //     PointLatLng(start.latitude, start.longitude),
  //     PointLatLng(destination.latitude, destination.longitude),
  //     travelMode: TravelMode.transit,
  //   );
  //   print(result.points);
  //   // Adding the coordinates to the list
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }
  // }

  Future<void> _determinePosition() async {
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
  }

  static CameraPosition _kGooglePlex =CameraPosition(target: LatLng(41.2995, 69.2401));

  static CameraPosition _point;

  @override
  void initState() {
    super.initState();


    _polyLine.add(Polyline(
      polylineId: PolylineId("route1"),
      color: Colors.blue,
      width: 3,
      points:polylineCoordinates
    ));

    _determinePosition().then((value) =>
        Timer.periodic(Duration(seconds: 3), (timer) {
          if (mounted) {
             gettinLocation();
          }
        }
    ));
  //   _determinePosition().then((value) {
  //     gettinLocation();
  // });
  }
  // void gettinLocation(LocationData event){
  //     // if(previous!=null){
  //     //   // var met = Geolocator.distanceBetween(
  //     //   //     previous.latitude,
  //     //   //     previous.longitude,
  //     //   //     event.latitude,
  //     //   //     event.longitude);
  //     //   // print("DIFFERENCE");
  //     //   // print("SPEED ${event.speed}");
  //     //   // print(met);
  //     //   // if(met<30){
  //     //   //   return;
  //     //   // }
  //     // }
  //     print(event);
  //     setState(() {
  //       position = LatLng(event.latitude, event.longitude);
  //       previous = position;
  //       polylineCoordinates.add(position);
  //       _point = CameraPosition(target: position, zoom: 19.151926040649414);
  //       markers = [];
  //       markers.add(
  //         Marker(
  //             position: position, markerId: MarkerId(position.toString())),
  //       );
  //       _kGooglePlex = CameraPosition(
  //         target: position,
  //         zoom: 14.4746,
  //       );
  //       visible = true;
  //     });
  // }
 void gettinLocation(){
   Geolocator.getCurrentPosition(
     // intervalDuration: Duration(seconds: 10),
     desiredAccuracy: LocationAccuracy.best,
   ).then((event) {
     if(previous!=null){
       var met = Geolocator.distanceBetween(
           previous.latitude,
           previous.longitude,
           event.latitude,
           event.longitude);
       print("DIFFERENCE");
       print("SPEED ${event.speed}");
       print(met);
       if(met<30){
         return;
       }
     }

     setState(() {

       position = LatLng(event.latitude, event.longitude);
       previous = position;
       polylineCoordinates.add(position);
       _point = CameraPosition(target: position, zoom: 19.151926040649414);
       markers = [];
       markers.add(
         Marker(
             position: position, markerId: MarkerId(position.toString())),
       );
       _kGooglePlex = CameraPosition(
         target: position,
         zoom: 14.4746,
       );
       visible = true;
     });
   });
 }
  void _handleTap(LatLng tappedPoint) {
    setState(() {
      //
      // markers.add(
      //   Marker(
      //       position: tappedPoint, markerId: MarkerId(tappedPoint.toString())),
      // );
      // tapped = tappedPoint;
      //
      // // setState(() {
      // //   _createPolylines(polylineCoordinates.last, tapped);
      // //
      // // });
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
          polylines: _polyLine,
          markers: Set.from(markers),
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: _handleTap),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToPoint,
        child: Icon(Icons.add_location_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _goToPoint() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_point));
  }
}

// _createPolylines(LatLng start, LatLng destination) async {
//   // Initializing PolylinePoints
//   polylinePoints = PolylinePoints();
//   final Set<Polyline>_polyline={};
//
//   // Generating the list of coordinates to be used for
//   // drawing the polylines
//   PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
//     "AIzaSyDAyvE5OXmxhZxT6lXHDv507Dvu0-tSAGU", // Google Maps API Key
//     PointLatLng(_originLatitude, _originLongitude),
//     PointLatLng(_destLatitude,_destLongitude),
//     travelMode: TravelMode.transit,
//   );
//   print(result.points);
//   // Adding the coordinates to the list
//   if (result.points.isNotEmpty) {
//     result.points.forEach((PointLatLng point) {
//       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//     });
//   }
//
//   // Defining an ID
//   PolylineId id = PolylineId('poly');
//
//   // Initializing Polyline
//   Polyline polyline = Polyline(
//     polylineId: id,
//     color: Colors.red,
//     points: <LatLng>[LatLng(_originLatitude,_originLongitude ),LatLng(_destLatitude,_destLongitude )],
//     width: 3,
//   );
//
//   // Adding the polyline to the map
//
// }
