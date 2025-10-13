import 'package:flutter/material.dart';
import 'package:app_bienestarmisena_v1/controllers/empresa_controller.dart';

class ModalCrearEmpresa extends StatefulWidget {
  final VoidCallback onSuccess;
  const ModalCrearEmpresa({super.key, required this.onSuccess});

  @override
  State<ModalCrearEmpresa> createState() => _ModalCrearEmpresaState();
}

class _ModalCrearEmpresaState extends State<ModalCrearEmpresa> {
  final EmpresaController _controller = EmpresaController();

  // 🔹 Controladores de texto
  final TextEditingController _name = TextEditingController();
  final TextEditingController _taxId = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _website = TextEditingController();
  final TextEditingController _sector = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  final Color verde = const Color(0xFF39A900);
  final Color verdeOscuro = const Color(0xFF2d8500);

  // 🔹 Validar y guardar
  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (_name.text.trim().isEmpty) {
      _mostrarMensaje("⚠️ El nombre de la empresa es obligatorio", Colors.orange);
      return;
    }

    final Map<String, dynamic> data = {
      "name": _name.text.trim(),
      "taxId": _taxId.text.trim(),
      "address": _address.text.trim(),
      "phone": _phone.text.trim(),
      "website": _website.text.trim(),
      "economicSector": _sector.text.trim(),
      "description": _desc.text.trim(),
    };

    final bool creada = await _controller.crearEmpresa(data);

    if (creada) {
      _mostrarMensaje("✅ Empresa creada correctamente", verde);
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context);
        widget.onSuccess();
      });
    } else {
      _mostrarMensaje("❌ Error al crear la empresa. Verifica el servidor.", Colors.redAccent);
    }
  }

  // 🔹 SnackBar
  void _mostrarMensaje(String texto, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto, style: const TextStyle(fontSize: 15)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 900,
        padding: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Encabezado
            Container(
              decoration: BoxDecoration(
                color: verde,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.business_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Registrar Nueva Empresa",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white, size: 26),
                  ),
                ],
              ),
            ),

            // 🔹 Formulario grande
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre y NIT
                    Row(
                      children: [
                        Expanded(child: _campoTexto(
                          label: "Nombre de la Empresa",
                          icon: Icons.business_center_rounded,
                          controller: _name,
                          hint: "Ej: Soluciones Tecnológicas S.A.",
                        )),
                        const SizedBox(width: 20),
                        Expanded(child: _campoTexto(
                          label: "NIT",
                          icon: Icons.confirmation_number_rounded,
                          controller: _taxId,
                          hint: "Ej: 900123456-7",
                        )),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Dirección y Teléfono
                    Row(
                      children: [
                        Expanded(child: _campoTexto(
                          label: "Dirección",
                          icon: Icons.location_on_outlined,
                          controller: _address,
                          hint: "Ej: Calle 45 #10-22, Manizales",
                        )),
                        const SizedBox(width: 20),
                        Expanded(child: _campoTexto(
                          label: "Teléfono",
                          icon: Icons.phone_android_rounded,
                          controller: _phone,
                          hint: "Ej: 6041234567",
                        )),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Sitio Web y Sector
                    Row(
                      children: [
                        Expanded(child: _campoTexto(
                          label: "Sitio Web",
                          icon: Icons.language_rounded,
                          controller: _website,
                          hint: "https://miempresa.com",
                        )),
                        const SizedBox(width: 20),
                        Expanded(child: _campoTexto(
                          label: "Sector Económico",
                          icon: Icons.work_outline_rounded,
                          controller: _sector,
                          hint: "Ej: Tecnología, Educación...",
                        )),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Ciudad
                    _campoTexto(
                      label: "Ciudad",
                      icon: Icons.location_city_rounded,
                      controller: _city,
                      hint: "Ej: Pereira",
                    ),

                    const SizedBox(height: 25),

                    // Descripción
                    const Text(
                      "Descripción",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _desc,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description_rounded, color: verdeOscuro, size: 26),
                        hintText: "Describe brevemente a qué se dedica la empresa...",
                        hintStyle: const TextStyle(color: Colors.black38),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: verde, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // 🔹 Botones inferiores
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded, color: Colors.black54, size: 22),
                          label: const Text("Cancelar",
                              style: TextStyle(color: Colors.black54, fontSize: 15)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            backgroundColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _guardar,
                          icon: const Icon(Icons.save_rounded, color: Colors.white, size: 24),
                          label: const Text(
                            "Guardar Empresa",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: verde,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget reutilizable para campos de texto
  Widget _campoTexto({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: verdeOscuro, size: 26),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: verde, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
