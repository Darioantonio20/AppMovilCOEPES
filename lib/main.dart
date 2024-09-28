import 'package:flutter/material.dart';
import 'screens/contact.dart';
import 'screens/home.dart';
import 'screens/about.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      routes: {
        '/contact': (context) => ContactScreen(),
        '/home': (context) => HomeView(),
        '/about': (context) => AboutView(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    ContactScreen(),
    AboutView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'home':
        Navigator.pushNamed(context, '/home');
        break;
      case 'contact':
        Navigator.pushNamed(context, '/contact');
        break;
      case 'about':
        Navigator.pushNamed(context, '/about');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Navigation'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (BuildContext context) {
              return {'home', 'contact', 'about'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice == 'home' ? 'Home' : choice == 'contact' ? 'Contact' : 'About'),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}