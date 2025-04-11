import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pb_audio_books/pages/new_home_page.dart';
import 'package:pb_audio_books/resources/audio_helper.dart';


late AudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  audioHandler = await initAudioService();
  runApp(ProviderScope(
      child: const AudioBooksApp()
  ),
  );
}

class AudioBooksApp extends StatefulWidget {
  const AudioBooksApp({Key? key}) : super(key: key);

  @override
  AudioBooksAppState createState() => AudioBooksAppState();
}

class AudioBooksAppState extends State<AudioBooksApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    connect();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        connect();
        break;
      case AppLifecycleState.paused:
        disconnect();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            titleLarge:
            TextStyle(fontFamily: "Aleo", fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontFamily: "Slabo", fontSize: 16.0),
          ),
          primarySwatch: Colors.pink,
        ),
        home:  NewHomePage(),
      );

  }

  void connect() async {
    // await AudioService.connect();
  }

  void disconnect() {
    // AudioService.disconnect();
  }
}
