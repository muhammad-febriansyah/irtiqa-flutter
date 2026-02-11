import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:irtiqa/app/core/api_client.dart';
import 'package:irtiqa/app/modules/onboarding/controllers/onboarding_controller.dart';

class RegisterStep extends GetView<OnboardingController> {
  const RegisterStep({super.key});

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
            }),
          ),

          const SizedBox(height: 32),

          // Title
          Center(
            child: Text(
              'Daftar Akun',
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
              'Buat akun untuk memulai perjalanan Anda',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40),

          // Name field
          _buildTextField(
            label: 'Nama Lengkap',
            hint: 'Masukkan nama lengkap',
            icon: Iconsax.user,
            onChanged: (value) => controller.registerName.value = value,
          ),

          const SizedBox(height: 20),

          // Email field
          _buildTextField(
            label: 'Email',
            hint: 'Masukkan email',
            icon: Iconsax.sms,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => controller.registerEmail.value = value,
          ),

          const SizedBox(height: 20),

          // WhatsApp Number field
          _buildTextField(
            label: 'Nomor WhatsApp',
            hint: 'Contoh: 081234567890',
            icon: Iconsax.call,
            keyboardType: TextInputType.phone,
            onChanged: (value) => controller.registerPhone.value = value,
          ),

          const SizedBox(height: 20),

          // Gender field
          _buildGenderField(),

          const SizedBox(height: 20),

          // Province field
          _buildTextField(
            label: 'Provinsi',
            hint: 'Masukkan provinsi',
            icon: Iconsax.map,
            onChanged: (value) => controller.province.value = value,
          ),

          const SizedBox(height: 20),

          // City field
          _buildTextField(
            label: 'Kota/Kabupaten',
            hint: 'Masukkan kota/kabupaten',
            icon: Iconsax.location,
            onChanged: (value) => controller.city.value = value,
          ),

          const SizedBox(height: 20),

          // Password field
          Obx(
            () => _buildTextField(
              label: 'Kata Sandi',
              hint: 'Minimal 8 karakter',
              icon: Iconsax.lock,
              obscureText: !controller.registerPasswordVisible.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.registerPasswordVisible.value
                      ? Iconsax.eye
                      : Iconsax.eye_slash,
                  size: 20.sp,
                ),
                onPressed: () => controller.registerPasswordVisible.value =
                    !controller.registerPasswordVisible.value,
              ),
              onChanged: (value) => controller.registerPassword.value = value,
            ),
          ),

          const SizedBox(height: 20),

          // Confirm Password field
          Obx(
            () => _buildTextField(
              label: 'Konfirmasi Kata Sandi',
              hint: 'Masukkan ulang kata sandi',
              icon: Iconsax.lock,
              obscureText: !controller.registerPasswordVisible.value,
              onChanged: (value) =>
                  controller.registerPasswordConfirm.value = value,
            ),
          ),

          const SizedBox(height: 24),

          // Terms checkbox
          Obx(
            () => CheckboxListTile(
              value: controller.acceptTerms.value,
              onChanged: (val) => controller.acceptTerms.value = val ?? false,
              title: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                  children: [
                    const TextSpan(text: 'Saya menyetujui '),
                    TextSpan(
                      text: 'Syarat & Ketentuan',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              activeColor: Theme.of(context).primaryColor,
            ),
          ),

          const SizedBox(height: 32),

          // Register button
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.registerAndContinue(),
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
                        'Daftar & Lanjutkan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Login link
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sudah punya akun? ',
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                ),
                TextButton(
                  onPressed: () => Get.offAllNamed('/login'),
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
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
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.3)),
            prefixIcon: Icon(icon, color: Get.theme.primaryColor, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Get.theme.primaryColor.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Get.theme.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Kelamin',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Get.theme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonFormField<String>(
              value: controller.registerGender.value,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Iconsax.user,
                  color: Get.theme.primaryColor,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Get.theme.primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Laki-laki')),
                DropdownMenuItem(value: 'female', child: Text('Perempuan')),
                DropdownMenuItem(
                  value: 'prefer_not_to_say',
                  child: Text('Lebih baik tidak menyebutkan'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.registerGender.value = value;
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
