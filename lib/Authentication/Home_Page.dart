import 'package:flutter/material.dart';
import 'package:signup_login_page/Authentication/Login_page.dart';
import 'package:signup_login_page/Authentication/DatabaseHandler/DbHelper.dart';
class Home_Page extends StatefulWidget {
  const Home_Page({super.key, required username});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: const Text("Home Page "),
        backgroundColor: Colors.indigo.withOpacity(0.3),
        centerTitle: true,
      ),
      body:
      Column(
        children: [
          Center(
            child: Text("Home Screen",style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),),

          ),
          Center(
            // add TextFormField
            child: TextFormField(
              controller: search,
              decoration: const InputDecoration(
                hintText: 'search',

                icon: Icon(Icons.search),
              ),

            ),
          )
        ],
      ),

    );
  }
}
