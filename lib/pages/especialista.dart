import 'package:flutter/material.dart';

class EspecialistaPage extends StatefulWidget {
  var text = "";
  var perguntar;
  var textoFalado;
  var isListening = false;
  var listen;
  var setName;
  var name;
  var startListening;
  EspecialistaPage(
      {this.text,
      this.perguntar,
      this.textoFalado,
      this.isListening,
      this.listen,
      this.setName,
      this.name,
      this.startListening});
  @override
  _EspecialistaPageState createState() => _EspecialistaPageState();
}

class _EspecialistaPageState extends State<EspecialistaPage> {
  var pergunta = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        pergunta = 'Então ' +
            widget.name +
            ', você já sabe o especialista que precisa?';
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
