import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=76e85f69";

void main() async {
  
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.black,
      primaryColor: Colors.black,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.black),
        enabledBorder: 
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: 
          OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30.7)),
      )
    ),
  ));
  
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return(json.decode(response.body));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final pesoController = TextEditingController();

  double dolar;
  double euro;
  double peso;
  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    pesoController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    pesoController.text = (real/peso).toStringAsFixed(2);

  }
  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    pesoController.text = (dolar * this.dolar / peso).toStringAsFixed(2);
    
  }

  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    pesoController.text = (euro * this.euro / peso).toStringAsFixed(2);
    
  }

  void _pesoChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    
    double peso = double.parse(text);
    realController.text = (peso * this.peso).toStringAsFixed(2);
    dolarController.text = (peso * this.peso / dolar).toStringAsFixed(2);
    euroController.text = (peso * this.peso / euro).toStringAsFixed(2);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:Text("\$ Conversor de Moeda \$", style: TextStyle(color: Colors.black),) ,
        backgroundColor: Colors.amberAccent,
        centerTitle: true,

      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder:(context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            return Center(
              child: Text("Carregando Dados...",
                style: TextStyle(color: Colors.amber, 
                fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
            );
            default:
            if(snapshot.hasError){
               return Center(
                child: Text("Erro ao Carregar Dados :(",
                style: TextStyle(color: Colors.amber, 
                fontSize: 25.0),
                textAlign: TextAlign.center,
                ),
              );
            } else {
              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
              peso = snapshot.data["results"]["currencies"]["ARS"]["buy"];
              return Stack(
                children:[
                  Image.asset(
                  "images/money.jpg",
                  fit: BoxFit.cover,
                  height: 1000.0,
                  width: 1400.0,
              ),
              SingleChildScrollView(
                  padding: EdgeInsets.all(10) ,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on, size: 150,color: Colors.amberAccent),
                      buildTextField("Real", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField("Dolar", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euro", "€", euroController, _euroChanged),
                      Divider(),
                      buildTextField("Peso", "ARS\$", pesoController, _pesoChanged),
                    ],

                  ) ,
                ),
              ] 
              );
            }
          }
        } ,
      ),
    );
  }
}

Widget buildTextField(String moeda, String cifra, TextEditingController controle, Function converte){
  return TextFormField(
    controller: controle,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.amberAccent,
      labelText: moeda,
      labelStyle: TextStyle(color: Colors.black),
      border: OutlineInputBorder(),
      prefixText: cifra,
    ),
    style: TextStyle(
     color: Colors.black, fontSize: 25.0
     
    ),
    onChanged: converte,
    keyboardType: TextInputType.number,
  );

}
