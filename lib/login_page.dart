import 'package:aadhar/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber = '';
  String aadharCard = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width * 1 / 2,
                  height: 40,
                  child: const Center(
                    child: Text('Adress Update'),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                  ),
                  //height: MediaQuery.of(context).size.height * 0.50,
                  width: MediaQuery.of(context).size.width * 9 / 10,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            const Text(
                              'Enter your Mobile Operator ID',
                            ),
                            TextFormField(
                              //Write the validator code
                              validator: (val) => val!.length < 4
                                  ? 'Enter a valid phone no.'
                                  : null,
                              onChanged: (val) {
                                setState(() {
                                  _phoneNumber = val;
                                });
                              },
                              keyboardType: TextInputType.phone,
                            ),
                            TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context)
                                      .pushReplacementNamed(HomePage.routeName);
                                }
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
