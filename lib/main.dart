import 'package:flutter/material.dart';
import 'package:salah_app/screens/home.dart';

void main() {
  salahApp();
}

void salahApp() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Salah App"),
        ),
        body: const Home(),
      ),
    ),
  );
}