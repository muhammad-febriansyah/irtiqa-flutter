import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irtiqa/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:irtiqa/app/modules/onboarding/views/disclaimer_step.dart';
import 'package:irtiqa/app/modules/onboarding/views/age_verification_step.dart';
import 'package:irtiqa/app/modules/onboarding/views/register_step.dart';
import 'package:irtiqa/app/modules/onboarding/views/profile_step.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Obx(
              () => LinearProgressIndicator(
                value: (controller.currentStep.value + 1) / 4,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),

            // Step content
            Expanded(
              child: Obx(() {
                switch (controller.currentStep.value) {
                  case 0:
                    return const DisclaimerStep();
                  case 1:
                    return const AgeVerificationStep();
                  case 2:
                    return const RegisterStep();
                  case 3:
                    return const ProfileStep();
                  default:
                    return const DisclaimerStep();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
