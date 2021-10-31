import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AddressData extends ChangeNotifier {
  String? buildingNumber;
  String? streetAddress;
  String? city;
  String? region;
  String? postal;
  String? landmark;
  File? addressDocument;
  String? imgString;
  double? latitude;
  double? longitude;
  bool? done;
  String? name;

  Map toJSON() => {
        'final c/o': name,
        'final street address': streetAddress,
        'final locality': region,
        'final city': city,
        'final landmark': landmark,
        'final documents': imgString,
      };

  void reset() {
    buildingNumber = null;
    streetAddress = null;
    city = null;
    region = null;
    postal = null;
    landmark = null;
    addressDocument = null;
    imgString = null;
    latitude = null;
    longitude = null;
    done = null;
    name = null;
  }
}

class FinalAddress {
  String name;
  String streetAddress;
  String locality;
  String city;
  String landmark;
  String document;

  FinalAddress({
    required this.name,
    required this.streetAddress,
    required this.locality,
    required this.city,
    required this.landmark,
    required this.document,
  });
  Map toJSON() => {
        'final c/o': name,
        'final street address': streetAddress,
        'final locality': locality,
        'final city': city,
        'final landmark': landmark,
        'final documents': document,
      };
}
