import 'dart:convert';
import 'package:app_bienestarmisena_v1/models/interesAdicionalConvocatoriaModel/interesAdicionalConvocatoria.dart';
import 'package:http/http.dart' as http;

class CallAdditionalInterestsController {
  final String baseUrl = "http://localhost:4000/api/v1/callAdditionalInterests";

  // 🔹 Obtener todos
  Future<List<CallAdditionalInterest>> getCallAdditionalInterests() async {
    try {
      final res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        return callAdditionalInterestsFromJson(res.body);
      } else {
        throw Exception("Error al obtener los datos");
      }
    } catch (e) {
      print("❌ Error getCallAdditionalInterests: $e");
      rethrow;
    }
  }

  // 🔹 Crear
  Future<bool> crearCallAdditionalInterest(int callId, int interestId) async {
    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"callId": callId, "interestId": interestId}),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (e) {
      print("❌ Error crearCallAdditionalInterest: $e");
      return false;
    }
  }

  // 🔹 Editar
  Future<bool> editarCallAdditionalInterest(
      int callId, int interestId, int newInterestId) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/$callId/$interestId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"interestId": newInterestId}),
      );
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error editarCallAdditionalInterest: $e");
      return false;
    }
  }

  // 🔹 Eliminar
  Future<bool> eliminarCallAdditionalInterest(int callId, int interestId) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/$callId/$interestId"));
      return res.statusCode == 200;
    } catch (e) {
      print("❌ Error eliminarCallAdditionalInterest: $e");
      return false;
    }
  }
}
