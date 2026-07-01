import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/img/convo2.png",
          height: 140,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 30),

        const Text(
          "Inicia sesión para continuar",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 35),
      ],
    );
  }
}