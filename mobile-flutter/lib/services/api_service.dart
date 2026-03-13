import 'dart:convert';
import 'package:http/http.dart' as http;

class AxiomApiService {
  // 1. REPLACE THIS with your actual IDX Forwarded URL (ending in /api/v1)
  final String baseUrl =
      "https://3000-firebase-axiom-project-1773333210161.cluster-htdgsbmflbdmov5xrjithceibm.cloudworkstations.dev/api/v1";

  Future<Map<String, dynamic>> solveMath(String problem) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/solve'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"problem": problem}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Axiom Engine Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Connection Failed: $e");
    }
  }
}
