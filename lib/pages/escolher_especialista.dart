import 'package:flutter/material.dart';

class EscolherEspecialista extends StatefulWidget {
  var text = "";
  var perguntar;
  var textoFalado;
  var isListening = false;
  var listen;
  var setName;
  var name;
  var startListening;
  EscolherEspecialista(
      {this.text,
      this.perguntar,
      this.textoFalado,
      this.isListening,
      this.listen,
      this.setName,
      this.name,
      this.startListening});
  @override
  _EscolherEspecialistaState createState() => _EscolherEspecialistaState();
}

class _EscolherEspecialistaState extends State<EscolherEspecialista> {
  var pergunta = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        pergunta = 'Agora ' + widget.name + ', selecione o seu especialista';
      });
      try {
        await widget.perguntar(pergunta);
      } catch (ex) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                pergunta,
                style: TextStyle(fontSize: 35, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
