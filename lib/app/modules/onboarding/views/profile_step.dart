import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irtiqa/app/modules/onboarding/controllers/onboarding_controller.dart';

class ProfileStep extends GetView<OnboardingController> {
  const ProfileStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            'Lengkapi Profil',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Informasi ini bersifat opsional dan dapat diubah nanti',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Pseudonym field
          _buildTextField(
            label: 'Nama Panggilan (Opsional)',
            hint: 'Nama yang ingin Anda gunakan',
            icon: Icons.badge_outlined,
            onChanged: (value) => controller.pseudonym.value = value,
          ),

          const SizedBox(height: 20),

          // Province field
          _buildTextField(
            label: 'Provinsi (Opsional)',
            hint: 'Contoh: Jawa Barat',
            icon: Icons.location_on_outlined,
            onChanged: (value) => controller.province.value = value,
          ),

          const SizedBox(height: 20),

          // City field
          _buildTextField(
            label: 'Kota/Kabupaten (Opsional)',
            hint: 'Contoh: Bandung',
            icon: Icons.location_city_outlined,
            onChanged: (value) => controller.city.value = value,
          ),

          const SizedBox(height: 20),

          // Primary concern field
          _buildTextField(
            label: 'Kebutuhan Utama (Opsional)',
            hint: 'Apa yang ingin Anda konsultasikan?',
            icon: Icons.help_outline,
            maxLines: 3,
            onChanged: (value) => controller.primaryConcern.value = value,
          ),

          const SizedBox(height: 24),

          // Privacy note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_outline, color: Colors.green[800], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Semua informasi Anda dijaga kerahasiaannya dan hanya digunakan untuk memberikan layanan terbaik',
                    style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Buttons
          Row(
            children: [
              // Back button
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Complete button
              Expanded(
                flex: 2,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.completeOnboarding(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Selesai',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Skip button
          Center(
            child: TextButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.completeOnboarding(),
              child: Text(
                'Lewati untuk sekarang',
                style: TextStyle(
                  color: Colors.grey[600],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Get.theme.primaryColor, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Get.theme.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
