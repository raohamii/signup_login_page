import 'package:flutter/material.dart';
import 'package:signup_login_page/Authentication/Login_page.dart';
import 'package:signup_login_page/Authentication/DatabaseHandler/DbHelper.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key, required this.username}) : super(key: key);

  final String username;

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
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Update the UI based on the item selected
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Setting'),
              onTap: () {
                // Update the UI based on the item selected
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Update the UI based on the item selected
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              "Home Screen",
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
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
