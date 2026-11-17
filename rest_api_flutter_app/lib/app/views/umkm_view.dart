import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/umkm_controller.dart';
import '../models/umkm_model.dart';
import '../../umkm_form_page.dart';

class UmkmView extends StatelessWidget {
  const UmkmView({super.key});

  void _showDeleteDialog(BuildContext context, UmkmController controller, Umkm item) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus UMKM?'),
        content: Text('Apakah Anda yakin ingin menghapus "${item.namaUmkm}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              if (item.id != null) {
                controller.deleteUmkm(item.id!);
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UmkmController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "Daftar UMKM",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan data',
            onPressed: controller.fetchUmkm,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.umkmList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.umkmList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store_mall_directory_outlined,
                  size: 72,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  "Belum ada data UMKM",
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => Get.to(() => const UmkmFormPage()),
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah UMKM Pertama"),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchUmkm,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: controller.umkmList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.umkmList[index];
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Get.to(() => UmkmFormPage(umkm: item));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: theme.colorScheme.primaryContainer,
                              child: Text(
                                item.id?.toString() ?? "?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.namaUmkm,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (item.pemilik != null && item.pemilik!.isNotEmpty)
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          size: 15,
                                          color: theme.colorScheme.secondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.pemilik!,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            if (item.kategori != null && item.kategori!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.kategori!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onTertiaryContainer,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.alamat != null && item.alamat!.isNotEmpty
                                    ? item.alamat!
                                    : "Alamat belum diatur",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (item.kontak != null && item.kontak!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 16,
                                color: theme.colorScheme.outline,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item.kontak!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Get.to(() => UmkmFormPage(umkm: item));
                              },
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text('Edit'),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filledTonal(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red.withValues(alpha: 0.1),
                                foregroundColor: Colors.red,
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () => _showDeleteDialog(context, controller, item),
                              icon: const Icon(Icons.delete_outline, size: 18),
                              tooltip: 'Hapus UMKM',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const UmkmFormPage());
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah UMKM"),
      ),
    );
  }
}
