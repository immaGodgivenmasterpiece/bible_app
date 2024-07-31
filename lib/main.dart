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
        apiKey: "AIzaSyBaBn8ntgR45Tky8lgOihjiN5-ULdsqtB4",
        authDomain: "bible-app-406c3.firebaseapp.com",
        projectId: "bible-app-406c3",
        storageBucket: "bible-app-406c3.appspot.com",
        messagingSenderId: "360237294742",
        appId: "1:360237294742:web:ef61acc564936d99314eb7"),
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
