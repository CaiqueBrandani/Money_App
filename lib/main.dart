// ignore_for_file: import_of_legacy_library_into_null_safe, unused_import, avoid_print, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance";

void main() async {

  runApp(MaterialApp(
  home: Home(),
  theme: ThemeData (
    hintColor: Colors.cyan[900],
    primaryColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 0, 96, 100))),
      hintStyle: TextStyle(color: Colors.cyan[900]),
    ),
  ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double? dolar;
  double? euro;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real / dolar!).toStringAsFixed(2);
    euroController.text = (real / euro!).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar!).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar! / euro!).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro!).toStringAsFixed(2);
    dolarController.text = (euro * this.euro! / dolar!).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('\$ Conversor \$'),
        backgroundColor: Colors.cyan[900],
        centerTitle: true,
      ),
      body: FutureBuilder<Map?>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text('Carregando Dados...',
                textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.cyan[900],
                    fontSize: 25.0
                  ),
                ),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text('Erro ao carregar dados!',
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontSize: 25.0
                    ),
                  ),
                );
              } else {
                dolar = snapshot.data!['results']['currencies']['USD']['buy'];
                euro = snapshot.data!['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.monetization_on_outlined, 
                          size: 150, 
                          color: Colors.cyan[900]
                        ),
                      ),
                      Divider(),
                      buildTextField('Reais', 'R\$', realController, _realChanged),
                      Divider(),
                      buildTextField('Dolares', 'US\$', dolarController, _dolarChanged),
                      Divider(),
                      buildTextField('Euros', '€', euroController, _euroChanged),
                    ],
                  )
                );
              }
          }
        }
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController moneyInpunt, Function(String) textChanged){
  return TextField(
    controller: moneyInpunt,
    onChanged: textChanged,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration (
      labelText: label,
      labelStyle: TextStyle(color: Colors.cyan[900]),
      border: OutlineInputBorder (),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.cyan[900],
      fontSize: 25,
    ),
  );
}



