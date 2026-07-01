import 'package:flutter/material.dart';

class RecuperarHeader extends StatelessWidget {
  const RecuperarHeader({super.key});

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

        // 📝 Título
        const Text(
          "Recuperar Contraseña",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1565C0),
          ),
        ),

        const SizedBox(height: 8),

        // 📄 Subtítulo
        const Text(
          "Ingresa tu correo para restablecer tu contraseña",
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