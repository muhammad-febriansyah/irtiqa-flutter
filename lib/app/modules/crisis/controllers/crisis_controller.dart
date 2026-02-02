import 'package:get/get.dart';
import 'package:irtiqa/app/core/api_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class CrisisController extends GetxController {
  var isLoading = false.obs;
  var hotlines = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHotlines();
  }

  /// Load crisis hotlines
  Future<void> loadHotlines() async {
    try {
      final response = await ApiClient.get('/crisis/hotlines');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        hotlines.value = [
          {
            'name': 'Hotline Kesehatan Jiwa',
            'number': data['hotline'] ?? '119',
            'description': 'Layanan darurat kesehatan jiwa 24/7',
            'icon': 'phone',
          },
          {
            'name': 'Hotline Kemenkes',
            'number': '500-567',
            'description': 'Layanan konsultasi kesehatan',
            'icon': 'hospital',
          },
        ];
      }
    } catch (e) {
      // Error loading hotlines: $e
      // Use default hotlines
      hotlines.value = [
        {
          'name': 'Hotline Kesehatan Jiwa',
          'number': '119',
          'description': 'Layanan darurat kesehatan jiwa 24/7',
          'icon': 'phone',
        },
      ];
    }
  }

  /// Trigger panic button
  Future<void> triggerPanicButton() async {
    try {
      isLoading.value = true;

      final response = await ApiClient.post('/crisis/panic-button', data: {});

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Peringatan Terkirim',
          'Tim kami telah menerima peringatan Anda. Silakan hubungi hotline darurat jika membutuhkan bantuan segera.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
        );

        // Show hotlines dialog
        _showHotlinesDialog();
      } else {
        Get.snackbar(
          'Gagal',
          response.data['message'] ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server. Silakan hubungi 119 untuk bantuan darurat.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Show hotlines dialog
  void _showHotlinesDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Hotline Darurat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: hotlines.map((hotline) {
            return ListTile(
              leading: Icon(Icons.phone),
              title: Text(hotline['name']),
              subtitle: Text(hotline['number']),
              trailing: ElevatedButton(
                onPressed: () => callHotline(hotline['number']),
                child: Text('Hubungi'),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Tutup')),
        ],
      ),
    );
  }

  /// Call hotline
  Future<void> callHotline(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka aplikasi telepon',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
