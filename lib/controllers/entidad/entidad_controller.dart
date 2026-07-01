import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/entidadInstitucion/entidadInstitucionModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InstitutionController extends GetxController {
  final RxBool loading = false.obs;

  // Obtener lista
  Future<List<InstitutionModel>> getInstitutions() async {
    try {
      loading.value = true;
      final response = await http.get(Uri.parse(InstitutionModel.apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List list = jsonData["data"] ?? [];
        return list.map((i) => InstitutionModel.fromJson(i)).toList();
      } else {
        print("❌ Error HTTP: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("⚠️ Error de conexión: $e");
      return [];
    } finally {
      loading.value = false;
    }
  }

  // Crear institución
  Future<void> crearInstitution(Map<String, dynamic> data) async {
    await http.post(
      Uri.parse(InstitutionModel.apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  // Editar institución
  Future<void> editarInstitution(int id, Map<String, dynamic> data) async {
    await http.put(
      Uri.parse("${InstitutionModel.apiUrl}/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  // Eliminar institución
  Future<void> eliminarInstitution(int id) async {
    await http.delete(Uri.parse("${InstitutionModel.apiUrl}/$id"));
  }
}
