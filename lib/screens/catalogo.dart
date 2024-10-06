import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CatalogoView extends StatefulWidget {
  @override
  _CatalogoViewState createState() => _CatalogoViewState();
}

class _CatalogoViewState extends State<CatalogoView> {
  List<dynamic> _instituciones = [];

  @override
  void initState() {
    super.initState();
    _fetchInstituciones();
  }

  Future<void> _fetchInstituciones() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/instituciones'));
    if (response.statusCode == 200) {
      setState(() {
        _instituciones = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load instituciones');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Instituciones'),
      ),
      body: ListView.builder(
        itemCount: _instituciones.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              leading: Icon(Icons.school, color: Color(0xFF67358E)),
              title: Text(
                _instituciones[index]['si_nombre'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF67358E),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CCT: ${_instituciones[index]['si_cct']}'),
                  Text('Ubicación: ${_instituciones[index]['si_ubicacion']}'),
                  Text('Régimen: ${_instituciones[index]['si_regimen']}'),
                  Text('Sostenimiento: ${_instituciones[index]['si_sostenimiento']}'),
                  Text('Acreditación: ${_instituciones[index]['si_acreditacion']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}