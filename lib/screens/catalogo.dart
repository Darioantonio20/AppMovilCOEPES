import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CatalogoView extends StatefulWidget {
  @override
  _CatalogoViewState createState() => _CatalogoViewState();
}

class _CatalogoViewState extends State<CatalogoView> {
  List<dynamic> _instituciones = [];
  List<dynamic> _institucioneSedes = [];
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchInstituciones();
    _fetchSedes();
  }

  Future<void> _fetchInstituciones() async {
    try {
      final response = await http.get(Uri.parse('http://54.159.106.240:3000/api/instituciones'));
      if (response.statusCode == 200) {
        setState(() {
          _instituciones = json.decode(response.body);
        });
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (_) {
      setState(() {
        _hasError = true;
      });
    }
  }

  Future<void> _fetchSedes() async {
    try {
      final response = await http.get(Uri.parse('http://54.159.106.240:3000/api/instituciones_sede'));
      if (response.statusCode == 200) {
        setState(() {
          _institucioneSedes = json.decode(response.body);
        });
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (_) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _hasError
          ? Center(
              child: Text(
                'Proximamente habrá convocatorias',
                style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 118, 114, 113)),
                textAlign: TextAlign.center,
              ),
            )
          : (_instituciones.isEmpty && _institucioneSedes.isEmpty)
              ? Center(
                  child: Text(
                    'Aún no se han sacado convocatorias, próximamente saldrán.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView(
                  children: [
                    ..._instituciones.map((institucion) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.school, color: Color(0xFF67358E)),
                          title: Text(
                            institucion['si_nombre'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF67358E),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CCT: ${institucion['si_cct']}'),
                              Text('Ubicación: ${institucion['si_ubicacion']}'),
                              Text('Régimen: ${institucion['si_regimen']}'),
                              Text('Sostenimiento: ${institucion['si_sostenimiento']}'),
                              Text('Acreditación: ${institucion['si_acreditacion']}'),
                              Container(
                                margin: EdgeInsets.only(right: 40.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(17.0),
                                  child: Center(
                                    child: Text(
                                      'Institución',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 147, 133, 176),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    ..._institucioneSedes.map((sede) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.location_pin, color: Color(0xFF67358E)),
                          title: Text(
                            sede['ssi_nombre'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF67358E),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ubicación sede: ${sede['ssi_ubicacion']}'),
                              Container(
                                margin: EdgeInsets.only(right: 40.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(17.0),
                                  child: Center(
                                    child: Text(
                                      'Sede',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 124, 96, 180),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
    );
  }
}
