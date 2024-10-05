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
        title: Text('Catálogo de universidades'),
      ),
      body: _instituciones.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _instituciones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_instituciones[index]['ssi_nombre']),
                );
              },
            ),
    );
  }
}