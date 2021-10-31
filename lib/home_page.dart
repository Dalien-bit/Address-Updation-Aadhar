import 'dart:convert';
import 'dart:io';

import 'package:aadhar/form.dart';

import 'package:aadhar/ocr.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast_io.dart';

import 'address_data.dart';

Future pickImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  return image as File;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<bool> ls = [false, false, false, false, false];
  File? imageFile;
  String? textRecognised;
  List<String> _words = [];
  bool isLoading = false;
  Position? _currPosition;
  //String _address = '';
  Address? _ad;
  bool stepOne = false;
  String subtitle = '';

  final picker = ImagePicker();
  @override
  @override
  Widget build(BuildContext context) {
    final _addressData = Provider.of<AddressData>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aadhar Address Update'),
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       const DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.deepOrangeAccent,
      //         ),
      //         child: Text('Options'),
      //       ),
      //       ListTile(
      //         title: const Text('Upload documents'),
      //         onTap: () {
      //           Navigator.of(context).pushNamed(Ocr.routeName);
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Request Adress update'),
      //         onTap: () {},
      //       ),
      //       ListTile(
      //         title: const Text('Location Access'),
      //         onTap: () {
      //           //Navigator.of(context).pushNamed(Location.routeName);
      //         },
      //       ),
      //       ListTile(
      //         title: const Text('Address Form'),
      //         onTap: () {
      //           Navigator.of(context).pushNamed(AddressForm.routeName);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: ListView(
        children: <Widget>[
          const ListTile(
            title: Text('Steps to add a documnt'),
            minVerticalPadding: 3,
          ),
          Card(
            child: ListTile(
              leading: const Text('1'),
              title: const Text('Scan Documents'),
              minVerticalPadding: 3,
              minLeadingWidth: 0.5,
              trailing: stepOne == true
                  ? const Icon(Icons.done)
                  : const Icon(Icons.circle_outlined),
              subtitle: isLoading == true
                  ? const Text('Please wait loading')
                  : const Text(''),
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await _getFromCamera();
                await textRecognition();
                _addressData.addressDocument = imageFile;
                setState(() {
                  isLoading = false;
                  stepOne = true;
                });
              },
            ),
            elevation: 5,
          ),
          if (_words.length > 2)
            Column(
              children: [
                const Text('Recognised Text'),
                Card(
                  child: Text(_words.toString()),
                )
              ],
            ),
          if (_words.length <= 2)
            const Text('Text Not recognised yet. Click above to take picture'),
          Card(
            child: ListTile(
              leading: const Text('2'),
              title: const Text('Generate Address'),
              minVerticalPadding: 3,
              minLeadingWidth: 0.5,
              trailing: stepOne && ls[1] == true
                  ? const Icon(Icons.done)
                  : const Icon(Icons.circle_outlined),
              subtitle: Text(subtitle),
              onTap: () async {
                if (stepOne == true) {
                  setState(() {
                    isLoading == true;
                    subtitle = 'Please wait loading';
                  });
                  _currPosition = await _determinePosition();
                  _addressData.latitude = _currPosition!.latitude;
                  _addressData.longitude = _currPosition!.longitude;
                  await Future.delayed(const Duration(seconds: 2), () {});
                  await getAddress().then((value) {
                    //_address = value.toString();
                    _ad = value;
                  });
                  String sta =
                      _ad!.streetAddress.toString().toLowerCase() + ' ';
                  List<String> sa = [];
                  int i = 0;
                  String currWord = '';
                  while (i < sta.length) {
                    if (sta[i] == ' ') {
                      sa.add(currWord);
                      currWord = '';
                    } else {
                      currWord += sta[i];
                    }
                    i++;
                  }
                  debugPrint(sa.toString());
                  debugPrint(_words.toString());
                  String fsa = '';
                  String fl = '';

                  //Address extraction starts
                  //Tries to match the current location address with the text recognised
                  for (var i = 0; i < _words.length; i++) {
                    if (_ad!.city.toString().toLowerCase() ==
                        _words[i].toLowerCase()) {
                      _addressData.city = _words[i];
                    }
                    if (_ad!.region.toString().toLowerCase() ==
                        _words[i].toLowerCase()) {
                      _addressData.region = _words[i];
                    }
                    if (_ad!.postal.toString().toLowerCase() ==
                        _words[i].toLowerCase()) {
                      _addressData.postal = _ad!.postal.toString();
                    }
                    //if found some words resembling 'Address' capture it.
                    if (_words[i].toLowerCase() == 'address' ||
                        _words[i] == 'Address' ||
                        _words[i] == 'ADDRESS') {
                      debugPrint(_words[i]);
                      //Captures Potential Address.
                      fl = _words[i + 2] +
                          ' ' +
                          _words[i + 3] +
                          ' ' +
                          _words[i + 4] +
                          ' ' +
                          _words[i + 5] +
                          ' ' +
                          _words[i + 6] +
                          ' ' +
                          _words[i + 7] +
                          ' ' +
                          _words[i + 8] +
                          ' ' +
                          _words[i + 9] +
                          ' ' +
                          _words[i + 10] +
                          ' ' +
                          _words[i + 11] +
                          ' ' +
                          _words[i + 12] +
                          ' ' +
                          _words[i + 13];
                    }
                    for (var j = 0; j < sa.length; j++) {
                      if (sa[j] == _words[i].toLowerCase()) {
                        fsa = fsa + ' ' + _words[i];
                      }
                    }
                  }
                  for (var i = 0; i < _words.length; i++) {}
                  debugPrint(fl);
                  debugPrint(fsa);
                  _addressData.streetAddress = fsa;
                  _addressData.landmark = fl;
                  debugPrint(_addressData.city);
                  debugPrint(_addressData.streetAddress);
                  setState(() {
                    isLoading = false;
                    subtitle = '';
                    ls[1] = true;
                  });
                } else {
                  setState(() {
                    subtitle = 'Perform Step one first';
                  });
                }
              },
            ),
            elevation: 5,
          ),
          Card(
            child: ListTile(
              leading: const Text('3'),
              title: const Text('Make the viable changes and verify'),
              minVerticalPadding: 3,
              minLeadingWidth: 0.5,
              trailing: _addressData.done == true
                  ? const Icon(Icons.done)
                  : const Icon(Icons.circle_outlined),
              onTap: () {
                //Check if address form is filled
                if (_addressData.done == true) {
                  setState(() {});
                } else {
                  // Fill the address form
                  Navigator.pushNamed(context, AddressForm.routeName);
                }
              },
            ),
            elevation: 5,
          ),
          TextButton(
            onPressed: () async {
              //AddressData fadd = AddressData();
              //Convert the document captured into a base64 image.
              String imgText = base64Encode(imageFile!.readAsBytesSync());
              _addressData.imgString = imgText;
              FinalAddress fd = FinalAddress(
                name: _addressData.name!,
                streetAddress: _addressData.streetAddress!,
                locality: _addressData.region!,
                city: _addressData.city!,
                landmark: _addressData.landmark!,
                document: imgText,
              );
              //Strore the final address into a json Object to be uploaded to the servers
              String jsonObj = jsonEncode(fd);
              //Upload the data to UIDAI servers
            },
            child: const Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              _addressData.reset();
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            },
            child: const Text('Add New'),
          )
        ],
      ),
    );
  }

  //Text recognition algorithm
  Future textRecognition() async {
    final inputImage = InputImage.fromFile(imageFile!);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);
    String text = recognisedText.text;
    List<String> wd = [];

    for (TextBlock block in recognisedText.blocks) {
      final Rect rect = block.rect;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;
      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          wd.add(element.text);
        }
      }
      wd.add('');
    }
    setState(() {
      textRecognised = text;
      _words = wd;
    });
  }

  //Function to get the image from the camera
  Future _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  //Gets the current location
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission = await Geolocator.requestPermission();

    // Test if location services are enabled.
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
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return pos;
  }

  //Return the address from the current latitude and longitude
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
