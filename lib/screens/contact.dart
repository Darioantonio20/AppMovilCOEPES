import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/imgNanio.png'),
            ),
            title: Text('Darío Antonio Gutiérrez Álvarez'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/imgUligami.png'),
            ),
            title: Text('Ulises Galvez Miranda'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/imgLuis.png'),
            ),
            title: Text('Luis Alejandro Martinez Montoya'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/imgDarinel.png'),
            ),
            title: Text('Christian Darinel Escobar Guillen'),
          ),
        ],
      ),
    );
  }
}