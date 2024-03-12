import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signup_login_page/Authentication/Signup_page.dart';
import 'home_page.dart';

class Login_page extends StatefulWidget {
  const Login_page({Key? key}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  final Email = TextEditingController();
  final Password = TextEditingController();
  bool isVisiblePassword = false;

  void toggleVisibilityPassword() {
    setState(() {
      isVisiblePassword = !isVisiblePassword;
    });
  }

  Future<void> scanQR() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (barcodeScanRes != '-1') {
        debugPrint(barcodeScanRes);
        // Handle the scanned QR code result
        setState(() {
          // Do something with the scanned QR code result
        });
      }
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
  }

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Email.text,
        password: Password.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home_Page(username: "Hamayoun",)),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid email or password. Please try again.'),
        ));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a valid email address.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to login. Please try again later.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
        backgroundColor: Colors.indigo.withOpacity(0.3),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text("Login to Your Account",style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.indigo.withOpacity(0.3),
                  ),
                  child: TextFormField(
                    controller: Email,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      icon: Icon(Icons.email),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.indigo.withOpacity(0.3),
                  ),
                  child: TextFormField(
                    controller: Password,
                    obscureText: !isVisiblePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                      icon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: toggleVisibilityPassword,
                        child: Icon(isVisiblePassword ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: scanQR,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.withOpacity(0.3), // Background color
                  ),
                  child: Text(
                    'Scan QR Code for Login',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (Email.text.isEmpty || Password.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please fill in all fields.'),
                      ));
                    } else {
                      login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.withOpacity(0.3),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Signup_page()),
                        );
                      },
                      child: Text("Sign Up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
