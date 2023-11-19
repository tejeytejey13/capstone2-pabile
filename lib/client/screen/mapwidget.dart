import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  LatLng? _customerLocation;
  final LatLng _staticDeliveryLocation =
      const LatLng(7.065925638538641, 125.59614686153728);
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  StreamSubscription<LocationData>? locationSubscription;

  static const double minMovingSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    fetchLocationUpdate();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _customerLocation != null
            ? GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
                initialCameraPosition:
                    CameraPosition(target: _customerLocation!, zoom: 25),
                markers: markers,
                polylines: polylines,
              )
            : Center(
                child:
                    CircularProgressIndicator()), // Show the CircularProgressIndicator when _customerLocation is null
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 17.5);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  LocationData? currentLocation;

  Future<void> fetchLocationUpdate() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get the current location of the user
    currentLocation = await _locationController.getLocation();

    if (currentLocation != null) {
      _customerLocation =
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      _updateCustomerMarker(_customerLocation!);
      drawRoute(_customerLocation!, _staticDeliveryLocation);
      _cameraToPosition(_customerLocation!);
    }

    locationSubscription = _locationController.onLocationChanged
        .listen((LocationData newLocation) {
      if (mounted) {
        if (newLocation.latitude != null &&
            newLocation.longitude != null &&
            newLocation.speed != null) {
          if (newLocation.speed! >= minMovingSpeed) {
            _customerLocation =
                LatLng(newLocation.latitude!, newLocation.longitude!);
            _updateCustomerMarker(_customerLocation!);
            drawRoute(_customerLocation!, _staticDeliveryLocation);
            _cameraToPosition(_customerLocation!);
          }
        }
      }
    });
  }

  void _updateCustomerMarker(LatLng location) {
    markers
        .removeWhere((marker) => marker.markerId.value == "customerLocation");
    final customerMarker = Marker(
      markerId: const MarkerId("customerLocation"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: location,
    );
    markers.add(customerMarker);
  }

  void _updateDeliveryMarker(LatLng location) {
    markers
        .removeWhere((marker) => marker.markerId.value == "deliveryLocation");
    final deliveryMarker = Marker(
      markerId: const MarkerId("deliveryLocation"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: location,
    );
    markers.add(deliveryMarker);
  }

  Future<void> drawRoute(LatLng from, LatLng to) async {
    final Polyline polyline = Polyline(
      polylineId: const PolylineId("route_line"),
      color: Colors.blue,
      width: 5,
      points: [from, to],
    );

    setState(() {
      polylines = {polyline};
    });
  }
}
