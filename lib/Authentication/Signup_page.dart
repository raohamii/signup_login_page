import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:signup_login_page/Authentication/Login_page.dart';
import 'package:signup_login_page/Authentication/DatabaseHandler/DbHelper.dart';

class Signup_page extends StatefulWidget {
  const Signup_page({Key? key}) : super(key: key);

  @override
  State<Signup_page> createState() => _Signup_pageState();
}

class _Signup_pageState extends State<Signup_page> {
  final Username = TextEditingController();
  final Email = TextEditingController();
  final Password = TextEditingController();
  final ConfirmPassword = TextEditingController(); // Separate controller for confirm password
  bool isVisible = false;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
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

  Future<void> signup() async {
    final dbHelper = DbHelper.instance;
    await dbHelper.initDatabase(); // Initialize the database
    await dbHelper.insertData('your_table', {
      'username': Username.text,
      'email': Email.text,
      'password': Password.text,
    });
    // Show a success message or navigate to another screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Signup Page"),
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
                  title: const Text("Register New Account",style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
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
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.indigo.withOpacity(0.3),
                  ),
                  child: TextFormField(
                    controller: ConfirmPassword,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
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
                    if (Username.text.isEmpty || Email.text.isEmpty || Password.text.isEmpty || ConfirmPassword.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please fill in all fields.'),
                      ));
                    } else if (Password.text != ConfirmPassword.text) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Passwords do not match.'),
                      ));
                    } else {
                      final dbHelper = DbHelper.instance;
                      await dbHelper.insertData('your_table', {
                        'username': Username.text,
                        'email': Email.text,
                        'password': Password.text,
                      });
                      // Show a success message or navigate to another screen
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('User signed up successfully'),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo.withOpacity(0.3),
                  ),
                  child: Text(
                    'Signup',
                    style: TextStyle(color: Colors.black), // Text color
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("if you have already an account."),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => Login_page()),
                        );
                      },
                      child: Text("Login"),
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
