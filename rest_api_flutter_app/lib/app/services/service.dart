import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/umkm_model.dart';

class UmkmService {
  // baseUrl untuk localhost backend CodeIgniter 4
  // Catatan: Gunakan 10.0.2.2 jika dijalankan di emulator Android standar,
  // atau IP LAN komputer jika di perangkat fisik nyata.
  final String baseUrl = "http://localhost:8080/api/";

  // METHOD GET
  Future<List<Umkm>> getUmkmList() async {
    final response = await http.get(Uri.parse('${baseUrl}umkm'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'] ?? [];
      return data.map((e) => Umkm.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data UMKM");
    }
  }

  // METHOD POST (CREATE)
  Future<Map<String, dynamic>> createUmkm(Map<String, dynamic> data) async {
    final url = Uri.parse('${baseUrl}umkm');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: data,
    );

    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonResponse;
    } else {
      final message = jsonResponse['message'] ?? 'Gagal menambah data';
      throw Exception(message);
    }
  }

  // METHOD PUT (UPDATE)
  Future<Map<String, dynamic>> updateUmkm(int id, Map<String, dynamic> data) async {
    final url = Uri.parse('${baseUrl}umkm/$id');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: data,
    );

    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    } else {
      final message = jsonResponse['message'] ?? 'Gagal memperbarui data';
      throw Exception(message);
    }
  }

  // METHOD DELETE
  Future<Map<String, dynamic>> deleteUmkm(int id) async {
    final url = Uri.parse('${baseUrl}umkm/$id');

    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    } else {
      final message = jsonResponse['message'] ?? 'Gagal menghapus data';
      throw Exception(message);
    }
  }
}
