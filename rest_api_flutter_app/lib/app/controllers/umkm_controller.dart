import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/umkm_model.dart';
import '../services/service.dart';

class UmkmController extends GetxController {
  var umkmList = <Umkm>[].obs;
  var isLoading = true.obs;
  var responseMessage = ''.obs;

  final UmkmService _service = UmkmService();

  @override
  void onInit() {
    fetchUmkm();
    super.onInit();
  }

  // GET umkm
  Future<void> fetchUmkm() async {
    try {
      isLoading(true);
      var result = await _service.getUmkmList();
      umkmList.assignAll(result);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat data: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // POST umkm (CREATE)
  Future<bool> createUmkm({
    required String nama,
    String? kategori,
    String? pemilik,
    String? alamat,
    String? kontak,
  }) async {
    isLoading(true);
    responseMessage('');
    try {
      final result = await _service.createUmkm({
        'nama_umkm': nama,
        'kategori': kategori ?? '',
        'pemilik': pemilik ?? '',
        'alamat': alamat ?? '',
        'kontak': kontak ?? '',
      });

      responseMessage.value = result['message'] ?? 'Data berhasil disimpan';
      Get.snackbar(
        "Sukses",
        responseMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      await fetchUmkm();
      return true;
    } catch (e) {
      responseMessage.value = 'Error: $e';
      Get.snackbar(
        "Gagal",
        responseMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  // PUT umkm (UPDATE)
  Future<bool> updateUmkm({
    required int id,
    required String nama,
    String? kategori,
    String? pemilik,
    String? alamat,
    String? kontak,
  }) async {
    isLoading(true);
    responseMessage('');
    try {
      final result = await _service.updateUmkm(id, {
        'nama_umkm': nama,
        'kategori': kategori ?? '',
        'pemilik': pemilik ?? '',
        'alamat': alamat ?? '',
        'kontak': kontak ?? '',
      });

      responseMessage.value = result['message'] ?? 'Data berhasil diperbarui';
      Get.snackbar(
        "Sukses",
        responseMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      await fetchUmkm();
      return true;
    } catch (e) {
      responseMessage.value = 'Error: $e';
      Get.snackbar(
        "Gagal",
        responseMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  // DELETE umkm
  Future<bool> deleteUmkm(int id) async {
    isLoading(true);
    try {
      final result = await _service.deleteUmkm(id);
      Get.snackbar(
        "Sukses",
        result['message'] ?? 'Data UMKM berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      await fetchUmkm();
      return true;
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Error: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading(false);
    }
  }
}
