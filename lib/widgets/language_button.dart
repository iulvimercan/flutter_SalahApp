import 'package:flutter/material.dart';
import 'package:salah_app/Services/LanguageService.dart';

class LanguageButton extends StatefulWidget {
  const LanguageButton({super.key});

  @override
  State<LanguageButton> createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.language),
    );
  }
}