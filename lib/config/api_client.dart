import 'package:http/http.dart' as http;
import 'environment.dart';

class ApiClient {
  final http.Client client;

  ApiClient({http.Client? client}) : client = client ?? http.Client();

  Future<http.Response> get(String path) {
    final uri = Uri.parse('${Environment.apiBaseUrl}$path');
    return client.get(uri);
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) {
    final uri = Uri.parse('${Environment.apiBaseUrl}$path');
    return client.post(uri, body: body);
  }

  // métodos put, delete, etc.
}
