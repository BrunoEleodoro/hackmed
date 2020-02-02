import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CodigoPage extends StatefulWidget {
  var text = "";
  var perguntar;
  var textoFalado;
  var isListening = false;
  var listen;
  var setName;
  var name;
  var codigo;
  var startListening;
  CodigoPage(
      {this.text,
      this.perguntar,
      this.textoFalado,
      this.isListening,
      this.listen,
      this.setName,
      this.name,
      this.startListening,
      this.codigo});
  @override
  _CodigoPageState createState() => _CodigoPageState();
}

class _CodigoPageState extends State<CodigoPage> {
  var pergunta = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        pergunta = 'Atenção ' +
            widget.name +
            ', Aqui está o código para confirmar seu atendimento com o médico, ele vai pedir assim que finalizar a consulta.';
      });
      try {
        await widget.perguntar(pergunta, true);
      } catch (ex) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                pergunta,
                style: TextStyle(fontSize: 30, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                widget.codigo,
                style: TextStyle(fontSize: 30, color: Colors.white),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
