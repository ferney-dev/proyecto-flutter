import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OlvidarContrasena extends StatefulWidget {
  const OlvidarContrasena({super.key});

  @override
  State<OlvidarContrasena> createState() => _OlvidarContrasenaState();
}

class _OlvidarContrasenaState extends State<OlvidarContrasena> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmarPassController = TextEditingController();

  bool _loading = false;
  bool _mostrarCodigo = false;
  bool _mostrarReset = false;
  bool _mostrarPassword = false;
  bool _mostrarConfirmarPassword = false;

  final Color verde = const Color(0xFF39A900);

  // 👉 Enviar correo con código
  Future<void> _enviarCorreo() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnack("Por favor ingresa tu correo");
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await http.post(
        Uri.parse("http://localhost:4000/api/v1/auths/forgotPassword"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _showSnack("✅ Código enviado a tu correo");
        setState(() => _mostrarCodigo = true);
      } else {
        _showSnack("⚠️ ${data["message"] ?? "No se pudo enviar el código"}");
      }
    } catch (e) {
      _showSnack("❌ Error de conexión");
    } finally {
      setState(() => _loading = false);
    }
  }

  // 👉 Verificar código
  Future<void> _verificarCodigo() async {
    if (_codigoController.text.length != 6) {
      _showSnack("El código debe tener 6 dígitos");
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await http.post(
        Uri.parse("http://localhost:4000/api/v1/auths/verifyCode"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "code": _codigoController.text.trim()
        }),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _showSnack("✅ Código válido, ahora ingresa tu nueva contraseña");
        setState(() {
          _mostrarCodigo = false;
          _mostrarReset = true;
        });
      } else {
        _showSnack("⚠️ ${data["message"] ?? "Código inválido"}");
      }
    } catch (e) {
      _showSnack("❌ Error al verificar código");
    } finally {
      setState(() => _loading = false);
    }
  }

  // 👉 Resetear contraseña
  Future<void> _resetPassword() async {
    final pass = _passController.text.trim();
    final confirm = _confirmarPassController.text.trim();

    if (pass.length < 6) {
      _showSnack("La contraseña debe tener al menos 6 caracteres");
      return;
    }
    if (pass != confirm) {
      _showSnack("Las contraseñas no coinciden");
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await http.post(
        Uri.parse("http://localhost:4000/api/v1/auths/resetPassword"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "code": _codigoController.text.trim(),
          "newPassword": pass
        }),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _showSnack("✅ Contraseña actualizada correctamente");
        Navigator.pop(context); // Regresa al login
      } else {
        _showSnack("⚠️ ${data["message"] ?? "No se pudo actualizar"}");
      }
    } catch (e) {
      _showSnack("❌ Error de conexión");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: verde.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("img/convo2.png", height: 100),
                const SizedBox(height: 20),
                Text(
                  "Recuperar Contraseña",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: verde,
                  ),
                ),
                const SizedBox(height: 30),

                // Paso 1: Ingresar correo
                if (!_mostrarCodigo && !_mostrarReset)
                  Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Correo Electrónico",
                          prefixIcon: const Icon(Icons.mail, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: verde, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _botonAccion("Enviar Código", _enviarCorreo),
                    ],
                  ),

                // Paso 2: Ingresar código
                if (_mostrarCodigo)
                  Column(
                    children: [
                      TextField(
                        controller: _codigoController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: "Código de Verificación",
                          prefixIcon: const Icon(Icons.confirmation_number,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _botonAccion("Verificar Código", _verificarCodigo),
                    ],
                  ),

                // Paso 3: Resetear contraseña
                if (_mostrarReset)
                  Column(
                    children: [
                      TextField(
                        controller: _passController,
                        obscureText: !_mostrarPassword,
                        decoration: InputDecoration(
                          labelText: "Nueva Contraseña",
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _mostrarPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(
                                () => _mostrarPassword = !_mostrarPassword),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _confirmarPassController,
                        obscureText: !_mostrarConfirmarPassword,
                        decoration: InputDecoration(
                          labelText: "Confirmar Contraseña",
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _mostrarConfirmarPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() =>
                                _mostrarConfirmarPassword =
                                    !_mostrarConfirmarPassword),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _botonAccion("Guardar Nueva Contraseña", _resetPassword),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonAccion(String texto, Function() accion) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _loading ? null : accion,
        style: ElevatedButton.styleFrom(
          backgroundColor: verde,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(texto,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
