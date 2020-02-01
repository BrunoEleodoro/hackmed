import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hackmed_app/pages/name.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
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

  Future _speak(msg) async {
    await flutterTts.setLanguage("pt-BR");
    var result = await flutterTts.speak(msg);
    print(result);
    return true;
    // if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    // if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  // void start() => );
  void listen() {
    _speech.listen(locale: "pt_BR").then((speaking) {
      setState(() {
        result = speaking;
      });
    });
  }

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
        setState(() => _isListening = result);
      });

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) {
    setState(() {
      isListening = false;
      respostas[currentIndex] = text;
      currentIndex++;
    });
  }

  void setName(str) {
    setState(() {
      nome = str;
    });
  }

  void onRecognitionComplete() => setState(() => _isListening = false);
// Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
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
  }

  Future<bool> perguntar(msg) async {
    return await _speak(msg);
  }

  @override
  Widget build(BuildContext context) {
    var content = NamePage();
    if (currentIndex == 1) {
      content = NamePage();
    } else if (currentIndex == 2) {
      content = NamePage();
    }
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(isListening ? 'Ouvindo...' : 'Falando...'),
      // ),
      body: content,
      floatingActionButton: FloatingActionButton(onPressed: () async {
        // await _speak(
        //     "Olá Reginaldo, tudo bem com você? Sou a Sua atendente, por favor me informe seu problema");
        start();
      }),
    );
  }
}
