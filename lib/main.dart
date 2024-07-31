// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'reading_state.dart';
import 'tile_grid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCJqEhkF1ivRLS7W9nHGOEtfkOwW6c9d9E",
        authDomain: "bible-app-5f7f7.firebaseapp.com",
        projectId: "bible-app-5f7f7",
        storageBucket: "bible-app-5f7f7.appspot.com",
        messagingSenderId: "235791652091",
        appId: "1:235791652091:web:9c7bf50ae30cb74c064c5e"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReadingState(),
      child: MaterialApp(
        title: '교독문 웹',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: TileGrid(),
      ),
    );
  }
}