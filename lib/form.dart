import 'dart:io';

import 'package:aadhar/address_data.dart';
import 'package:aadhar/location.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AddressForm extends StatefulWidget {
  static const routeName = '/address-form';

  const AddressForm({Key? key}) : super(key: key);

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  String _add = '';
  String _streetAddress = '';
  String _name = '';
  String _area = '';
  String _pincode = '';
  String _city = '';
  String _buildingNo = '';
  bool error = false;
  Coordinates? _x;
  double lat = 0;
  double long = 0;
  String _landmark = '';
  String _warn = '';
  bool try1 = false;
  @override
  Widget build(BuildContext context) {
    final _addressData = Provider.of<AddressData>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                    'Please be patient it may take upto one minute to verify your details'),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'C/O S/O',
                  ),
                  onChanged: (value) {
                    _name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Building Number/ Flat number',
                  ),
                  onChanged: (value) {
                    _buildingNo = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText:
                        'First enter Street Number & then Street Address',
                  ),
                  onChanged: (value) {
                    _streetAddress = value;
                  },
                  initialValue: _addressData.streetAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Landmark',
                  ),
                  onChanged: (value) {
                    _streetAddress = value;
                  },
                  initialValue: _addressData.landmark,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Locality',
                  ),
                  initialValue: _addressData.region,
                  onChanged: (value) {
                    _area = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'City',
                  ),
                  initialValue: _addressData.city,
                  onChanged: (value) {
                    _city = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Postal',
                  ),
                  //initialValue: _addressData.city,
                  onChanged: (value) {
                    _pincode = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _warn = 'Loading';
                      });
                      //if (try1 == false) {
                      _add = _streetAddress + ' ' + _area + ' ';

                      try {
                        _x = await _forGeo(_add);
                      } catch (e) {
                        _warn = 'Not found'
                            'To check the address/location details click here';
                      }
                      double distance = Geolocator.distanceBetween(
                        _x!.latitude!,
                        _x!.longitude!,
                        _addressData.latitude!,
                        _addressData.longitude!,
                      );
                      debugPrint(distance.toString());
                      if (distance <= 1000 && _x != null) {
                        _addressData.buildingNumber = _buildingNo;
                        _addressData.postal = _pincode;
                        _addressData.done = true;
                        _addressData.landmark = _landmark;
                        _addressData.name = _name;
                        _addressData.region = _area;
                        _addressData.city = _city;
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          error = true;
                          _warn =
                              'You have entered incorrect details/documents.'
                              'Or the document provided does not have sufficient address.'
                              'To check the address/location details click below';
                        });
                      }
                    }
                  },
                  child: const Text('Verify'),
                ),
                if (error)
                  Column(
                    children: [
                      Text(_warn),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Location.routeName);
                        },
                        child: const Text('Current Address'),
                      ),
                    ],
                  ),
                const Card(
                  child: Text('Current Location Address through GPS'),
                ),
                //It shows the current street address obtained by geocoding.
                // To help the user put out the street number street address city region properly.
                const Location(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Converts the current street address to latitude longitude for distance measurement.
  Future<Coordinates> _forGeo(String addr) async {
    GeoCode geoCode = GeoCode();
    Coordinates x;
    try {
      x = await geoCode.forwardGeocoding(address: addr);
    } catch (e) {
      rethrow;
    }
    return x;
  }
}
