import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DevTeam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipo'),
      ),
      body: ListView(
        children: <Widget>[
          _buildDeveloperCard(
            context,
            'Darío Antonio Gutiérrez Álvarez',
            'assets/images/imgNanio.png',
            'Desarrollador Frontend',
            'Up chiapas',
            'Programacion móvil 9°A',
            'Matricula:221245',
            'Especialista en Flutter y diseño de interfaces.',
          ),
          _buildDeveloperCard(
            context,
            'Ulises Galvez Miranda',
            'assets/images/imgUligami.png',
            'Ingeniero de Software',
            'Up chiapas',
            'Programacion móvil 9°A',
            'Matricula:213691',
            'Amplia experiencia en desarrollo móvil y web.',
          ),
          _buildDeveloperCard(
            context,
            'Luis Alejandro Martinez Montoya',
            'assets/images/imgLuis.png',
            'Ingeniero de Software',
            'Up chiapas',
            'Programacion móvil 9°A',
            'Matricula:213021',
            'Amplia experiencia en desarrollo móvil y web.',
          ),
          _buildDeveloperCard(
            context,
            'Christian Darinel Escobar Guillen',
            'assets/images/imgDarinel.png',
            'Desarrollador Full Stack',
            'Up chiapas',
            'Programacion móvil 9°A',
            'Matricula:221192',
            'Conocimientos en desarrollo tanto frontend como backend.',
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard(BuildContext context, String name, String imagePath, String role, String description, String matricula, String materia, String s) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      elevation: 5.0,
      
      child: ListTile(
        
        leading: Hero(
          tag: name,
          child: CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 30.0,
          ),
          
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(role, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 5.0),
            Text(description),
          ],
        ),
        
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeveloperDetailScreen(
                name: name,
                imagePath: imagePath,
                role: role,
                matricula: matricula,
                materia: materia,
                description: description,
                s:s,
              ),
            ),
          );
        },
      ),
    );
  }
}

void _launchURL() async {
    const url = 'https://github.com/Darioantonio20/FlutterChatBot';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo lanzar $url';
    }
  }

class DeveloperDetailScreen extends StatelessWidget {
  final String name;
  final String imagePath;
  final String role;
  final String description;
  final String matricula;
  final String materia;
  final String s;

  DeveloperDetailScreen({required this.name,required this.imagePath,required this.role,required this.description, required this.materia, required this.matricula, required this.s});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
             ElevatedButton(
                onPressed: _launchURL,
                child: Text(
                  'Repositorio',
                  style: TextStyle(
                    color: Colors.white, 
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF67358E),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Hero(
              tag: name,
              child: CircleAvatar(
                backgroundImage: AssetImage(imagePath),
                radius: 80.0,
              ),
              
            ),
            SizedBox(height: 20.0),
            Text(
              name,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              role,
              style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 20.0),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              materia,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              s,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
          
          ],
        ),
      ),
    );
  }
}