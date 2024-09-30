import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Bienvenido a COEPES',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                   color: Color(0xFF67358E),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'La solución para combatir el rezago educativo en Chiapas',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              
              // Information Section
              Text(
                '¿Te gustaría estudiar en una universidad, pero no encuentras la información adecuada?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                   color: Color(0xFF67358E),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Con COEPES, tendrás acceso directo y actualizado a la oferta educativa de las universidades de Chiapas, en un solo lugar.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              
              // Features Section
              Text(
                '¿Qué puedes hacer con COEPES?',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                   color: Color(0xFF67358E),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildFeatureItem('Explorar programas académicos', 'Descubre las ofertas educativas de las universidades, desde carreras hasta maestrías y especializaciones.'),
              _buildFeatureItem('Filtrar opciones según tus intereses', 'Utiliza nuestro buscador para encontrar la carrera que te apasiona o explora opciones según tu área de interés.'),
              _buildFeatureItem('Verificar la disponibilidad de cupos', 'Mantente al tanto de los cupos disponibles para inscripciones, evitando largos tiempos de espera.'),
              _buildFeatureItem('Obtener información actualizada', 'Accede a detalles sobre costos, ubicaciones, requisitos de ingreso y mucho más.'),
              _buildFeatureItem('Contacto directo con universidades', 'Consulta y comunícate con las universidades para resolver tus dudas sobre programas o procesos de inscripción.'),
              
              SizedBox(height: 30),
              
              // Universities Section
              Text(
                'Para las Universidades',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF67358E),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'COEPES también permite a las universidades actualizar su oferta educativa en tiempo real, asegurando que los estudiantes obtengan siempre información precisa y actualizada.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Image.asset(
                  'assets/images/bannercoepescatalogo.jpg',
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 20),
              Text(
                '¡Únete a COEPES y comienza tu camino hacia la educación superior hoy mismo!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                   color: Color(0xFF67358E),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: _launchURL,
                child: Text(
                  'Empezar Ahora',
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
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL() async {
    const url = 'https://drive.google.com/file/d/1CU5aue68TE7lqILmxUtkDkBh7101u4Pv/view?usp=sharing';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo lanzar $url';
    }
  }

  Widget _buildFeatureItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
             color: Color.fromARGB(255, 111, 77, 136),
          ),
        ),
        SizedBox(height: 5),
        Text(
          description,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
