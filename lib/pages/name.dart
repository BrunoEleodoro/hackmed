import 'package:flutter/material.dart';

class NamePage extends StatefulWidget {
  var text = "";
  var perguntar;
  var textoFalado;
  var isListening = false;
  var listen;
  NamePage(
      {this.text,
      this.perguntar,
      this.textoFalado,
      this.isListening,
      this.listen});
  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  var pergunta = 'Olá, tudo bem? Qual seu primeiro nome?';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await widget.perguntar(pergunta);
      await widget.listen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            pergunta,
            style: TextStyle(fontSize: 55, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
