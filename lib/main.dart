import 'package:flutter/material.dart';
import 'screens/dev_team.dart';
import 'screens/home.dart';
import 'screens/chat_bot.dart';
import 'screens/logo_animation.dart';
import 'screens/qr_scanner.dart'; // Importa la nueva vista QRScannerView

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogoAnimation(),
      routes: {
        '/main': (context) => MainScreen(),
        '/contact': (context) => DevTeam(),
        '/home': (context) => HomeView(),
        '/chat_bot': (context) => ChatBotView(),
        '/qr_scanner': (context) => QRScannerView(), // Nueva ruta para el escáner QR
      },
      debugShowCheckedModeBanner: false,
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
    DevTeam(),
    ChatBotView(),
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
      case 'chat_bot':
        Navigator.pushNamed(context, '/chat_bot');
        break;
      case 'dev_team':
        Navigator.pushNamed(context, '/dev_team');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {
              Navigator.pushNamed(context, '/qr_scanner');
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Dev Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'Chat Bot',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF67358E), 
        unselectedItemColor: Colors.grey, 
        onTap: _onItemTapped,
      ),
    );
  }
}
