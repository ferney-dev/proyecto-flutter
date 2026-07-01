import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  final VoidCallback onRegisterPressed;
  final VoidCallback onForgotPasswordPressed;

  const LoginFooter({
    super.key,
    required this.onRegisterPressed,
    required this.onForgotPasswordPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔗 Enlaces de acción
        TextButton(
          onPressed: onRegisterPressed,
          child: Text(
            "¿No tienes una cuenta? Regístrate aquí",
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onForgotPasswordPressed,
          child: Text(
            "¿Olvidaste tu contraseña?",
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 30),

     
      ],
    );
  }
}
