import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:irtiqa/app/core/api_client.dart';
import 'package:irtiqa/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:irtiqa/app/routes/app_pages.dart';

class DisclaimerStep extends GetView<OnboardingController> {
  const DisclaimerStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Logo from API
          Center(
            child: Obx(() {
              final logoPath = controller.appSettings.value?.logo;
              final logoUrl = ApiClient.getAssetUrl(logoPath);

              return Container(
                width: 130.w,
                height: 130.w,
                child: logoUrl.isNotEmpty
                    ? Image.network(
                        logoUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
              );
            },),
          ),

          const SizedBox(height: 32),

          // Title
          Center(
            child: Text(
              'Selamat Datang di IRTIQA',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              'Di sini, Anda didampingi secara tenang dan bertahap.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40),

          // Disclaimer content
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kesepahaman Awal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'IRTIQA bersifat pendampingan dan edukasi.\nKami tidak menetapkan kepastian perkara ghaib dan tidak menggantikan tenaga medis atau fatwa ulama.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                Obx(
                  () => _buildDisclaimerCheckbox(
                    value: controller.understandNotGhaib.value,
                    onChanged: (val) =>
                        controller.understandNotGhaib.value = val ?? false,
                    text: 'Saya memahami IRTIQA bukan penentu perkara ghaib',
                  ),
                ),

                Obx(
                  () => _buildDisclaimerCheckbox(
                    value: controller.understandNotMedical.value,
                    onChanged: (val) =>
                        controller.understandNotMedical.value = val ?? false,
                    text: 'Saya memahami ini bukan pengganti medis atau fatwa',
                  ),
                ),

                Obx(
                  () => _buildDisclaimerCheckbox(
                    value: controller.willingToFollowProcess.value,
                    onChanged: (val) =>
                        controller.willingToFollowProcess.value = val ?? false,
                    text:
                        'Saya bersedia mengikuti proses bertahap dengan tenang',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Important note
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Layanan ini untuk usia minimal 17 tahun',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Accept button
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.acceptDisclaimer(),
                style: ElevatedButton.styleFrom(
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
                        'Saya Mengerti',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Legal links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Get.toNamed(Routes.TERMS_AND_CONDITIONS),
                child: Text(
                  'Syarat & Ketentuan',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text(' • ', style: TextStyle(color: Colors.grey)),
              TextButton(
                onPressed: () => Get.toNamed(Routes.PRIVACY_POLICY),
                child: Text(
                  'Kebijakan Privasi',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Colors.black87,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
        activeColor: Get.theme.primaryColor,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
