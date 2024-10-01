import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

Future<void> requestCameraPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    await Permission.camera.request();
  }
}

Future<void> requestMicrophonePermission() async {
  var status = await Permission.microphone.status;
  if (!status.isGranted) {
    await Permission.microphone.request();
  }
}

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
  late final GenerativeModel _model; // Generative AI model
  late final ChatSession _chatSession; // Chat session
  bool _isListening = false;
  String _speechText = '';
  String _selectedLanguage = "en-US"; // Valor por defecto

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey); // Inicializa el modelo
    _chatSession = _model.startChat(); // Inicia la sesión de chat
    requestCameraPermission(); // Solicitar permisos de cámara al inicio si es necesario
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: _controller.text, isUser: true));
      });
      String userMessage = _controller.text;
      _controller.clear();

      // Mensaje temporal mientras se obtiene la respuesta del bot
      setState(() {
        _messages.add(ChatMessage(text: "Analizando...", isUser: false));
      });

      try {
        // Envía el mensaje del usuario al chatbot y obtiene la respuesta
        final response = await _chatSession.sendMessage(Content.text(userMessage));
        final botResponse = response.text ?? "No se recibió respuesta";

        // Remueve el mensaje temporal y agrega la respuesta del bot
        setState(() {
          _messages.removeLast(); // Remueve el mensaje temporal
          _messages.add(ChatMessage(text: botResponse, isUser: false));
        });

        // Habla la respuesta del bot
        await _speak(botResponse);

      } catch (e) {
        // Muestra un mensaje de error si la llamada falla
        setState(() {
          _messages.removeLast(); // Remueve el mensaje temporal
          _messages.add(ChatMessage(text: "Error: $e", isUser: false));
        });
      }
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage(_selectedLanguage);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  Future<void> _startListening() async {
  // Solicita permisos de micrófono
  var status = await Permission.microphone.request();

  // Si los permisos no son concedidos, no continúa
  if (status.isGranted) {
    bool available = await _speech.initialize(
      onStatus: (val) {
        if (val == 'done') {
          _stopListening();
        }
      },
      onError: (val) => print('Error del reconocimiento de voz: $val'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _speechText = val.recognizedWords;
            _controller.text = _speechText; // Actualiza el TextField con el texto de la voz
          });
        },
        localeId: _selectedLanguage, // Configura el reconocimiento de voz al idioma seleccionado
        listenFor: const Duration(minutes: 1),
        pauseFor: const Duration(seconds: 5),
      );
    }
  } else {
    print("Permisos de micrófono denegados");
  }
}


  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
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
                      hintStyle: const TextStyle(color: Color.fromARGB(255, 122, 36, 172)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF67358E),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF67358E),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF67358E),
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF67358E)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: const Color(0xFF67358E),
                  iconSize: 35,
                  onPressed: _sendMessage,
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
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 1.25,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: message.isUser ? const Color.fromARGB(255, 136, 87, 167) : const Color.fromARGB(255, 83, 19, 117),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: message.isUser ? const Radius.circular(12) : Radius.zero,
                bottomRight: message.isUser ? Radius.zero : const Radius.circular(12),
              ),
            ),
            child: Text(
              message.text,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
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
