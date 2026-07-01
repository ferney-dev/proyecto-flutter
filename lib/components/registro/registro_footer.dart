import 'package:flutter/material.dart';

class RegistroFooter extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const RegistroFooter({
    super.key,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onLoginPressed,
      child: Text(
        "¿Ya tienes una cuenta? Volver a Inicio de Sesión",
        style: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
