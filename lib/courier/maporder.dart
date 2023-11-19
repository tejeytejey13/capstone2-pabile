// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class MapWidget extends StatefulWidget {
//   final bool
//       isCustomer; // Pass true if the user is a customer, false if a delivery person

//   const MapWidget({Key? key, required this.isCustomer}) : super(key: key);

//   @override
//   State<MapWidget> createState() => _MapWidgetState();
// }

// class _MapWidgetState extends State<MapWidget> {
//   final Location _locationController = Location();
//   final Completer<GoogleMapController> _mapController =
//       Completer<GoogleMapController>();
//   LatLng? _userLocation;
//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};

//   static const double minMovingSpeed = 1.0; // Adjust this threshold as needed

//   @override
//   void initState() {
//     super.initState();
//     fetchLocationUpdate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: (_userLocation == null)
//             ? const Center(child: CircularProgressIndicator())
//             : GoogleMap(
//                 onMapCreated: (GoogleMapController controller) {
//                   _mapController.complete(controller);
//                 },
//                 initialCameraPosition:
//                     CameraPosition(target: _userLocation!, zoom: 22),
//                 markers: markers,
//                 polylines: polylines,
//               ),
//       ),
//     );
//   }

//   Future<void> _cameraToPosition(LatLng pos) async {
//     final GoogleMapController controller = await _mapController.future;
//     CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 22);
//     await controller
//         .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
//   }

//   Future<void> fetchLocationUpdate() async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;

//     serviceEnabled = await _locationController.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _locationController.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }

//     permissionGranted = await _locationController.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await _locationController.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     _locationController.onLocationChanged
//         .listen((LocationData currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null &&
//           currentLocation.speed != null) {
//         if (currentLocation.speed! >= minMovingSpeed) {
//           // Only update the location when the user is moving
//           _updateUserLocation(
//             LatLng(currentLocation.latitude!, currentLocation.longitude!),
//           );
//         }
//       }
//     });
//   }

//   void _updateUserLocation(LatLng location) {
//     markers.removeWhere((marker) => marker.markerId.value == "userLocation");
//     final userMarker = Marker(
//       markerId: const MarkerId("userLocation"),
//       icon: widget.isCustomer
//           ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
//           : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       position: location,
//     );
//     markers.add(userMarker);

//     // Draw the route (polyline) between the customer and user locations
//     if (widget.isCustomer && _userLocation != null) {
//       drawRoute(_userLocation!, location);
//     }

//     _cameraToPosition(location);
//   }

//   Future<void> drawRoute(LatLng from, LatLng to) async {
//     final Polyline polyline = Polyline(
//       polylineId: PolylineId("route_line"),
//       color: Colors.blue,
//       width: 5,
//       points: [from, to],
//     );

//     setState(() {
//       polylines = {polyline};
//     });
//   }
// }
