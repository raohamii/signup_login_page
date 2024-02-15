import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signup_login_page/Authentication/DatabaseHandler/DbHelper.dart';
import 'package:signup_login_page/Authentication/Home_Page.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'Home_Page.dart';

class Login_page extends StatefulWidget {
  const Login_page({Key? key}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  final Username = TextEditingController();
  final Password = TextEditingController();
  bool isVisible = false;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    // Handle the scanned QR code result
    setState(() {
      // Do something with the scanned QR code result
    });
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
                  title: const Text("Login Your Account",style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.indigo.withOpacity(0.3),
                  ),
                  child: TextFormField(
                    controller: Username,
                    decoration: const InputDecoration(
                      hintText: "Username",
                      border: InputBorder.none,
                      icon: Icon(Icons.person),
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
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                      icon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: toggleVisibility,
                        child: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: scanQR,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo.withOpacity(0.3), // Background color
                  ),
                  child: Text(
                    'Scan QR Code for Login',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final dbHelper = DbHelper.instance;
                    final user = await dbHelper.getUser(Username.text, Password.text);
                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Home_Page(username: user['username'])),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Invalid username or password.'),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo.withOpacity(0.3),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black), // Text color
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Do not have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate to the signup page
                      },
                      child: Text("Signup"),
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
