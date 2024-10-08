import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Importar paquete de conectividad

const String apiKey = "AIzaSyC8k6REIl0KhGzggzwRX4TXVBJjOfvGbmk"; // Reemplaza con tu API key de Google Generative AI

class ChatBotView extends StatefulWidget {
  @override
  _ChatBotViewState createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  late StreamSubscription _connectivitySubscription; // Para escuchar cambios de conectividad
  bool _isListening = false;
  bool _isConnected = true; // Variable para almacenar estado de conexión
  String _speechText = '';
  String _selectedLanguage = "en-US";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    _chatSession = _model.startChat();
    requestMicrophonePermission();
    checkInternetConnection(); // Verificar la conexión al iniciar
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus); // Escuchar cambios en la conexión
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel(); // Cancelar la suscripción cuando el widget se destruye
    super.dispose();
  }

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  Future<void> checkInternetConnection() async {
    // Verifica el estado de la conexión
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });

    if (!_isConnected) {
      // Si no hay conexión, muestra un mensaje
      setState(() {
        _messages.add(ChatMessage(
            text: "No hay conexión a Internet. Conéctate a una red para enviar mensajes.",
            isUser: false));
      });
    } else {
      // Cuando se recupere la conexión
      setState(() {
        _messages.add(ChatMessage(
            text: "Conexión a Internet restaurada. Ya puedes enviar mensajes.",
            isUser: false));
      });
    }
  }

  void _startListening() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done') {
            _stopListening();
          }
        },
        onError: (val) => print('Error: $val'),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _speechText = val.recognizedWords;
              _controller.text = _speechText; // Actualiza el input
            });
          },
          localeId: _selectedLanguage,
        );
      }
    } else {
      print("Permisos de micrófono denegados");
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  void _sendMessage() async {
    await checkInternetConnection(); // Verificar la conexión antes de enviar un mensaje

    if (!_isConnected) {
      // Si no hay conexión, no permitir enviar mensajes
      setState(() {
        _messages.add(ChatMessage(
            text: "No se puede enviar el mensaje. Conéctate a Internet.",
            isUser: false));
      });
      return;
    }

    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: _controller.text, isUser: true));
      });
      String userMessage = _controller.text;
      _controller.clear();

      setState(() {
        _messages.add(ChatMessage(text: "Analizando...", isUser: false));
      });

      try {
        final response = await _chatSession.sendMessage(Content.text(userMessage));
        final botResponse = response.text ?? "No se recibió respuesta";

        setState(() {
          _messages.removeLast();
          _messages.add(ChatMessage(text: botResponse, isUser: false));
        });

        await _speak(botResponse);
      } catch (e) {
        setState(() {
          _messages.removeLast();
          _messages.add(ChatMessage(text: "Error: $e", isUser: false));
        });
      }
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage(_selectedLanguage);
    await _flutterTts.speak(text);
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('COEPES-BOT || $formattedDate'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic_off : Icons.mic,
                    color: const Color.fromARGB(255, 111, 60, 149),
                    size: 32,
                  ),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    enabled: _isConnected, // Deshabilitar si no hay conexión
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: const Color(0xFF67358E),
                  iconSize: 35,
                  onPressed: _isConnected ? _sendMessage : null, // Deshabilitar el botón si no hay conexión
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _changeLanguage("en-US"),
                child: Text("Inglés (EE.UU.)"),
              ),
              ElevatedButton(
                onPressed: () => _changeLanguage("es-MX"),
                child: Text("Español (México)"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/imgsinfondo.jpg'),
              radius: 20,
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF8857A7) : const Color(0xFF531377),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white),
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
          if (message.isUser)
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/userIcon.png'),
              radius: 20,
            ),
        ],
      ),
    );
  }
}
