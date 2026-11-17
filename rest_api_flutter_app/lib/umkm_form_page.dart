import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/controllers/umkm_controller.dart';
import 'app/models/umkm_model.dart';

class UmkmFormPage extends StatefulWidget {
  final Umkm? umkm;

  const UmkmFormPage({super.key, this.umkm});

  @override
  State<UmkmFormPage> createState() => _UmkmFormPageState();
}

class _UmkmFormPageState extends State<UmkmFormPage> {
  final UmkmController controller = Get.find<UmkmController>();

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController namaC;
  late final TextEditingController pemilikC;
  late final TextEditingController alamatC;
  late final TextEditingController kategoriC;
  late final TextEditingController kontakC;

  bool get isEdit => widget.umkm != null;

  @override
  void initState() {
    super.initState();
    namaC = TextEditingController(text: widget.umkm?.namaUmkm ?? '');
    pemilikC = TextEditingController(text: widget.umkm?.pemilik ?? '');
    alamatC = TextEditingController(text: widget.umkm?.alamat ?? '');
    kategoriC = TextEditingController(text: widget.umkm?.kategori ?? '');
    kontakC = TextEditingController(text: widget.umkm?.kontak ?? '');
  }

  @override
  void dispose() {
    namaC.dispose();
    pemilikC.dispose();
    alamatC.dispose();
    kategoriC.dispose();
    kontakC.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    bool success;
    if (isEdit) {
      success = await controller.updateUmkm(
        id: widget.umkm!.id!,
        nama: namaC.text.trim(),
        pemilik: pemilikC.text.trim(),
        alamat: alamatC.text.trim(),
        kategori: kategoriC.text.trim(),
        kontak: kontakC.text.trim(),
      );
    } else {
      success = await controller.createUmkm(
        nama: namaC.text.trim(),
        pemilik: pemilikC.text.trim(),
        alamat: alamatC.text.trim(),
        kategori: kategoriC.text.trim(),
        kontak: kontakC.text.trim(),
      );
    }

    if (success && mounted) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit UMKM' : 'Tambah UMKM',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: namaC,
                        decoration: InputDecoration(
                          labelText: 'Nama UMKM *',
                          hintText: 'Contoh: Kopi Nusantara',
                          prefixIcon: const Icon(Icons.storefront_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama UMKM wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: pemilikC,
                        decoration: InputDecoration(
                          labelText: 'Nama Pemilik',
                          hintText: 'Contoh: Rafi A',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: kategoriC,
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          hintText: 'Contoh: Kuliner / Kerajinan',
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: kontakC,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Kontak / No. Telepon',
                          hintText: 'Contoh: 08123456789',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: alamatC,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Alamat Lengkap',
                          hintText: 'Contoh: Jl. A. Yani No. 10, Banjarbaru',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                final isLoading = controller.isLoading.value;
                return SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isEdit ? 'Perbarui Data' : 'Simpan Data',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.responseMessage.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                final isErr = controller.responseMessage.value.startsWith('Error');
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isErr
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isErr ? Colors.red : Colors.green,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isErr ? Icons.error_outline : Icons.check_circle_outline,
                        color: isErr ? Colors.red : Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.responseMessage.value,
                          style: TextStyle(
                            color: isErr ? Colors.red.shade800 : Colors.green.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
