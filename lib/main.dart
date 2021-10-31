import 'package:aadhar/address_data.dart';
import 'package:aadhar/form.dart';
import 'package:aadhar/home_page.dart';
import 'package:aadhar/location.dart';
import 'package:aadhar/login_page.dart';
import 'package:aadhar/ocr.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AddressData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: const App(),
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        Ocr.routeName: (context) => const Ocr(),
        //Location.routeName: (context) => const Location(),
        AddressForm.routeName: (context) => const AddressForm(),
      },
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Scaffold(
            body: Text('Something went wrong'),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const LoginPage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Scaffold(
          body: Text('Loading'),
        );
      },
    );
  }
}
