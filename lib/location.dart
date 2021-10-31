import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);
  static const routeName = '/location';

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  Position? _currPosition;
  String _address = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            _currPosition = await _determinePosition();
            setState(() {});
          },
          child: const Text('Find current location'),
        ),
        Text(_currPosition.toString()),
        if (_currPosition != null)
          Column(
            children: [
              TextButton(
                onPressed: () async {
                  await Future.delayed(const Duration(seconds: 2), () {});
                  await getAddress().then((value) {
                    setState(() {
                      _address = value.toString();
                    });
                  });
                },
                child: const Text('Find current address'),
              ),
              Text(_address),
            ],
          ),
      ],
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission = await Geolocator.requestPermission();

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    return pos;
  }

  Future<Address> getAddress() async {
    GeoCode geoCode = GeoCode();
    try {
      return await geoCode.reverseGeocoding(
        latitude: _currPosition!.latitude,
        longitude: _currPosition!.longitude,
      );
    } catch (e) {
      rethrow;
    }
  }
}
