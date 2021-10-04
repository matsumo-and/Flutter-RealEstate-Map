import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import './Utility/config.dart';

class HomeScreen extends StatelessWidget {
  final startLocation = LatLng(35.15362, 136.96964);

  Future<LatLng> acquireCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return startLocation;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return startLocation;
      }
    }

    final LocationData locationData = await location.getLocation();
    print("a");
    return LatLng(locationData.latitude ?? startLocation.latitude,
        locationData.longitude ?? startLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: MapboxMap(
          accessToken: accessToken,
          styleString: style,
          initialCameraPosition: CameraPosition(
            zoom: 15.0,
            target: startLocation,
          ),
          onMapCreated: (MapboxMapController controller) async {
            final result = await acquireCurrentLocation();

            await controller.animateCamera(
              CameraUpdate.newLatLng(result),
            );
            print("created");
            await controller.addCircle(
              CircleOptions(
                circleRadius: 8.0,
                circleColor: '#006992',
                circleOpacity: 0.8,
                geometry: result,
                draggable: false,
              ),
            );
            print("created");
          }),
    );
  }
}
