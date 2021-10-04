import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

Future<LatLng> acquireCurrentLocation() async {
  Location location = Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return LatLng(0, 0);
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return LatLng(0, 0);
    }
  }

  final locationData = await location.getLocation();
  return LatLng(
      locationData.latitude!.toDouble(), locationData.longitude!.toDouble());
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String token =
        'pk.eyJ1IjoicG9ueWFvIiwiYSI6ImNrdHo3bGZpMDA3MzUyb25wbHRlYW8zZjcifQ.zJp2XScgvelBiKISsrs5hQ';
    final String style = 'mapbox://styles/ponyao/cktznbqp322fe17pcoozkalaj';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: MapboxMap(
          accessToken: token,
          styleString: style,
          initialCameraPosition: CameraPosition(
            zoom: 15.0,
            target: LatLng(35.15362, 136.96964),
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
