import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_signup/src/chat.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homePage.dart';
import 'profilePage.dart';
import 'Components/customAppBar.dart';
import 'Components/customProfileAppBar.dart';
class NavigationWrapper extends StatefulWidget {
  NavigationWrapper({Key key}) : super(key: key);

  @override
  _NavigationWrapperState createState() => _NavigationWrapperState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _NavigationWrapperState extends State<NavigationWrapper> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ChatPage(),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex!=2?
      CustomAppBar():
      CustomProfileAppBar(route: 'profile'),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffD15573),
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}