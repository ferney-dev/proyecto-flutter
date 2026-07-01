import 'package:flutter/material.dart';

class RegistroHeader extends StatelessWidget {
  const RegistroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🖼️ Logo
        Image.asset(
          "assets/img/convo2.png",
          height: 140,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 25),


        const SizedBox(height: 8),

        // 📄 Subtítulo
        const Text(
          "Completa tus datos para registrarte",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}