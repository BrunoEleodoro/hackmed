import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackmed_app/pages/aguardar.dart';
import 'package:hackmed_app/pages/codigo.dart';
import 'package:hackmed_app/pages/escolher_especialista.dart';
import 'package:hackmed_app/pages/especialista.dart';
import 'package:hackmed_app/pages/idade.dart';
import 'package:hackmed_app/pages/localizacao.dart';
import 'package:hackmed_app/pages/name.dart';
import 'package:hackmed_app/pages/sentimentos.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.blue and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterTts flutterTts = FlutterTts();
  bool isListening = false;
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var currentIndex = 0;
  var nome = "";
  Map respostas = new Map();
  var result = "";
  var text = "";
  var codigo = "";
  var startListening = false;
  bool escolherEspecialista = false;
  bool lastStep = false;
  Future<bool> _speak(msg, lastStep2) async {
    lastStep = lastStep2;
    Completer completer = new Completer<bool>();
    await flutterTts.setLanguage("pt-BR");
    print('call speak');
    var result = await flutterTts.speak(msg);

    print('finished');
    completer.complete(true);
    // print(result);
    return completer.future;
    // if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    // if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  // void start() => );
  void listen() {
    _speech.listen(locale: "pt_BR").then((speaking) {
      // setState(() {
      //    = speaking;
      // });
    });
  }

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
        setState(() => _isListening = result);
      });

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String t) {
    print('onRecognitionResult');
    setState(() {
      text = t;
    });
  }

  void setName(str) {
    setState(() {
      nome = str;
    });
  }

  void onRecognitionComplete() {
    print('onRecognitionComplete');
    print('text=' + text);
    if (text.length > 0) {
      setState(() {
        _isListening = false;
        startListening = false;
      });
      print('text RECEIVED!');
      print(text.toString().length);
      if (!isListening) {
        if (currentIndex == 0) {
          setName(text);
        } else if (currentIndex == 2) {
          if (text == "sim") {
            escolherEspecialista = true;
          }
        }
        setState(() {
          isListening = false;
          respostas[currentIndex] = text;
          currentIndex++;
        });
        activateSpeechRecognizer();
      }
    }
  }

// Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    // print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   await _speak("Olá, poderia me dizer seu nome:");
    // });
    activateSpeechRecognizer();
    flutterTts.completionHandler = whenComplete;
  }

  void whenComplete() async {
    print('whenComplete');
    // setState(() {
    //   startListening = true;
    // });
    if (lastStep) {
      print('lastStep');
      await Geolocator().checkGeolocationPermissionStatus();
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      var data = {
        "nome": respostas[0],
        "idade": respostas[1],
        "especialista": respostas[2],
        "sentimentos": respostas[3],
        // "location": respostas[4]
        "location":
            position.latitude.toString() + "," + position.longitude.toString()
      };
      Response response = await Dio()
          .post("http://brunoeleodoro.com:4000/atendimento/novo", data: data);
      print(response.data);

      setState(() {
        codigo = response.data['codigo'].toString();
        currentIndex++;
      });
    } else {
      listen();
    }
  }

  Future<bool> perguntar(msg) async {
    return await _speak(msg, false);
  }

  @override
  Widget build(BuildContext context) {
    print('index');
    print(currentIndex);
    Widget content;
    if (currentIndex == 0) {
      content = NamePage(
        text: text,
        perguntar: _speak,
        isListening: isListening,
        listen: listen,
        setName: setName,
      );
    } else if (currentIndex == 1) {
      content = IdadePage(
        text: text,
        perguntar: _speak,
        isListening: isListening,
        listen: listen,
        setName: setName,
        name: nome,
      );
    } else if (currentIndex == 2) {
      content = EspecialistaPage(
        text: text,
        perguntar: _speak,
        isListening: isListening,
        listen: listen,
        setName: setName,
        name: nome,
      );
    } else if (currentIndex == 3) {
      if (escolherEspecialista) {
        content = EscolherEspecialista(
          text: text,
          perguntar: _speak,
          isListening: isListening,
          listen: listen,
          setName: setName,
          name: nome,
        );
      } else {
        content = SentimentosPage(
          text: text,
          perguntar: _speak,
          isListening: isListening,
          listen: listen,
          setName: setName,
          name: nome,
        );
      }
    } else if (currentIndex == 4) {
      content = SentimentosPage(
        text: text,
        perguntar: _speak,
        isListening: isListening,
        listen: listen,
        setName: setName,
        name: nome,
      );
    } else if (currentIndex == 5) {
      content = LocalizacaoPage(
        text: text,
        perguntar: _speak,
        isListening: isListening,
        listen: listen,
        setName: setName,
        name: nome,
      );
    } else if (currentIndex == 6) {
      content = AguardarPage(
        text: text,
        perguntar: _speak,
        isListening: isListening,
        listen: listen,
        setName: setName,
        name: nome,
      );
    } else if (currentIndex == 7) {
      content = CodigoPage(
        text: text,
        perguntar: _speak,
        isListening: isListening,
        listen: listen,
        setName: setName,
        name: nome,
        codigo: codigo,
      );
    }
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(isListening ? 'Ouvindo...' : 'Falando...'),
      // ),
      body: content,
    );
  }
}
