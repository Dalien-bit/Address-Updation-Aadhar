import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

Future pickImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  return image as File;
}

class Ocr extends StatefulWidget {
  const Ocr({Key? key}) : super(key: key);
  static const routeName = '/ocr';

  @override
  _OcrState createState() => _OcrState();
}

class _OcrState extends State<Ocr> {
  File? imageFile;
  String? textRecognised;
  List<String> words = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload adress documents'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: TextButton(
              //color: Colors.greenAccent,
              onPressed: () {
                _getFromGallery();
              },
              child: const Text("PICK FROM GALLERY"),
            ),
          ),
          Container(
            height: 40.0,
          ),
          TextButton(
            //color: Colors.lightGreenAccent,
            onPressed: () async {
              await _getFromCamera();
            },
            child: const Text("PICK FROM CAMERA"),
          ),
          if (imageFile != null)
            Image.file(
              imageFile!,
              fit: BoxFit.cover,
            ),
          if (imageFile != null)
            TextButton(
              onPressed: () async {
                await textRecognition();
                setState(() {});
              },
              child: const Text('Done'),
            ),
          if (textRecognised != null) Text(textRecognised!),
          if (textRecognised != null) Text(words[2]),
        ],
      ),
    );
  }

  Future textRecognition() async {
    final inputImage = InputImage.fromFile(imageFile!);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);
    String text = recognisedText.text;
    for (TextBlock block in recognisedText.blocks) {
      final Rect rect = block.rect;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          words.add(element.text);
        }
      }
    }
    setState(() {
      textRecognised = text;
    });
  }

  Future _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
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
}
