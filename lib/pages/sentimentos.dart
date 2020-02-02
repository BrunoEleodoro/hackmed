import 'package:flutter/material.dart';

class SentimentosPage extends StatefulWidget {
  var text = "";
  var perguntar;
  var textoFalado;
  var isListening = false;
  var listen;
  var setName;
  var name;
  var startListening;
  SentimentosPage(
      {this.text,
      this.perguntar,
      this.textoFalado,
      this.isListening,
      this.listen,
      this.setName,
      this.name,
      this.startListening});
  @override
  _SentimentosPageState createState() => _SentimentosPageState();
}

class _SentimentosPageState extends State<SentimentosPage> {
  var pergunta = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        pergunta = 'Ahh está bem, vou registrar aqui ' +
            widget.name +
            ', Agora me diga o que você está sentindo';
      });
      try {
        await widget.perguntar(pergunta, false);
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
