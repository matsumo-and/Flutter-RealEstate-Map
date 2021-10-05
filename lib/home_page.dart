import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import './Utility/config.dart';

class HomeScreen extends StatelessWidget {
  final startLocation = LatLng(35.15362, 136.96964);

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
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
            final Position _currentPosition = await _determinePosition();
            final LatLng _currentLatLng =
                LatLng(_currentPosition.latitude, _currentPosition.longitude);

            await controller.addCircle(
              CircleOptions(
                circleRadius: 8.0,
                circleColor: '#006992',
                circleOpacity: 0.8,
                geometry: _currentLatLng,
                draggable: false,
              ),
            );

            await controller.animateCamera(
              CameraUpdate.newLatLng(_currentLatLng),
            );
          }),
    );
  }
}
