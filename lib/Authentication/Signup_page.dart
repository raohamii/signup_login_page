import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signup_login_page/Authentication/Home_Page.dart';
import 'package:signup_login_page/Authentication/Login_page.dart';


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
  bool isVisiblePassword = false;
  bool isVisibleConfirmPassword = false;

  void toggleVisibilityPassword() {
    setState(() {
      isVisiblePassword = !isVisiblePassword;
    });
  }

  void toggleVisibilityConfirmPassword() {
    setState(() {
      isVisibleConfirmPassword = !isVisibleConfirmPassword;
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
    try {
      if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(Email.text)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid email format.'),
        ));
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email.text,
        password: Password.text,
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Email.text,
        password: Password.text,
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': Username.text,
        'email': Email.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User signed up successfully'),
      ));


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home_Page(username: "Hamayoun"),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The password provided is too weak.'),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('The account already exists for that email.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign up. Please try again later.'),
      ));
    }
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
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.indigo.withOpacity(0.3),
                  ),
                  child: TextFormField(
                    controller: ConfirmPassword,
                    obscureText: !isVisibleConfirmPassword,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      border: InputBorder.none,
                      icon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: toggleVisibilityConfirmPassword,
                        child: Icon(isVisibleConfirmPassword ? Icons.visibility : Icons.visibility_off),
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
                  onPressed: () async {
                    if (Username.text.isEmpty || Email.text.isEmpty || Password.text.isEmpty || ConfirmPassword.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please fill in all fields.'),
                      ));
                    } else if (Password.text.toLowerCase() != ConfirmPassword.text.toLowerCase()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Passwords do not match.'),
                      ));
                    } else {
                      signup();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.withOpacity(0.3),
                  ),
                  child: Text(
                    'Signup',
                    style: TextStyle(color: Colors.black),
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
