import 'package:get/get.dart';

import '../modules/account/views/about_view.dart';
import '../modules/account/views/help_view.dart';
import '../modules/account/views/profile_edit_view.dart';
import '../modules/auth/bindings/otp_verification_binding.dart';
import '../modules/auth/views/otp_verification_view.dart';
import '../modules/bottomnavigator/bindings/bottomnavigator_binding.dart';
import '../modules/bottomnavigator/views/bottomnavigator_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/consultant/bindings/consultant_binding.dart';
import '../modules/consultant/bindings/consultant_profile_binding.dart';
import '../modules/consultant/views/consultant_dashboard_view.dart';
import '../modules/consultant/views/consultant_profile_edit_view.dart';
import '../modules/consultant/views/consultant_profile_view.dart';
import '../modules/consultant/views/consultant_ticket_detail_view.dart';
import '../modules/consultant_application/bindings/consultant_application_binding.dart';
import '../modules/consultant_application/views/consultant_application_view.dart';
import '../modules/consultation/views/consultation_create_view.dart';
import '../modules/consultation/views/consultation_detail_view.dart';
import '../modules/crisis/bindings/crisis_binding.dart';
import '../modules/crisis/views/hotlines_view.dart';
import '../modules/dream/bindings/dream_binding.dart';
import '../modules/dream/views/dream_create_view.dart';
import '../modules/dream/views/dream_detail_view.dart';
import '../modules/dream/views/dream_education_gate_view.dart';
import '../modules/dream/views/dream_view.dart';
import '../modules/education/views/article_detail_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/journal/bindings/journal_binding.dart';
import '../modules/journal/views/journal_create_view.dart';
import '../modules/journal/views/journal_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/onboarding/views/welcome_view.dart';
import '../modules/package/bindings/package_binding.dart';
import '../modules/package/views/package_list_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_checkout_view.dart';
import '../modules/payment/views/payment_manual_transfer_view.dart';
import '../modules/payment/views/payment_method_selection_view.dart';
import '../modules/payment/views/payment_process_view.dart';
import '../modules/payment/views/payment_success_view.dart';
import '../modules/privacy/bindings/privacy_binding.dart';
import '../modules/privacy/views/data_management_view.dart';
import '../modules/privacy/views/privacy_policy_view.dart';
import '../modules/program/bindings/program_binding.dart';
import '../modules/program/views/program_detail_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/transaction/bindings/transaction_binding.dart';
import '../modules/transaction/views/transaction_history_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial =
      Routes.WELCOME; // Default, actual route set in main.dart

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const BottomnavigatorView(),
      binding: BottomnavigatorBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOMNAVIGATOR,
      page: () => const BottomnavigatorView(),
      binding: BottomnavigatorBinding(),
    ),
    GetPage(
      name: _Paths.CONSULTATION_CREATE,
      page: () => const ConsultationCreateView(),
    ),
    GetPage(
      name: _Paths.CONSULTATION_DETAIL,
      page: () => const ConsultationDetailView(),
    ),
    GetPage(
      name: _Paths.DREAM,
      page: () => const DreamView(),
      binding: DreamBinding(),
    ),
    GetPage(name: _Paths.DREAM_CREATE, page: () => const DreamCreateView()),
    GetPage(name: _Paths.DREAM_DETAIL, page: () => const DreamDetailView()),
    GetPage(name: _Paths.PROFILE_EDIT, page: () => const ProfileEditView()),
    GetPage(name: _Paths.ABOUT, page: () => const AboutView()),
    GetPage(name: _Paths.HELP, page: () => const HelpView()),
    GetPage(
      name: _Paths.EDUCATION_ARTICLE,
      page: () => const ArticleDetailView(),
    ),
    GetPage(
      name: _Paths.HOTLINES,
      page: () => const HotlinesView(),
      binding: CrisisBinding(),
    ),
    GetPage(
      name: _Paths.JOURNAL,
      page: () => const JournalView(),
      binding: JournalBinding(),
    ),
    GetPage(
      name: _Paths.JOURNAL_CREATE,
      page: () => const JournalCreateView(),
      binding: JournalBinding(),
    ),
    GetPage(
      name: _Paths.CONSULTANT_APPLICATION,
      page: () => const ConsultantApplicationView(),
      binding: ConsultantApplicationBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_CONDITIONS,
      page: () =>
          const PrivacyPolicyView(), // Using PrivacyPolicyView as it handles Markdown
      binding: PrivacyBinding(),
    ),
    GetPage(
      name: _Paths.DATA_MANAGEMENT,
      page: () => const DataManagementView(),
      binding: PrivacyBinding(),
    ),
    GetPage(
      name: _Paths.DREAM_EDUCATION_GATE,
      page: () => const DreamEducationGateView(),
    ),
    GetPage(
      name: _Paths.CONSULTANT_DASHBOARD,
      page: () => const ConsultantDashboardView(),
      binding: ConsultantBinding(),
    ),
    GetPage(
      name: _Paths.CONSULTANT_QUEUE,
      page: () => const ConsultantDashboardView(),
      binding: ConsultantBinding(),
    ),
    GetPage(
      name: _Paths.CONSULTANT_ACTIVE,
      page: () => const ConsultantDashboardView(),
      binding: ConsultantBinding(),
    ),
    GetPage(
      name: _Paths.CONSULTANT_TICKET_DETAIL,
      page: () => const ConsultantTicketDetailView(),
      binding: ConsultantBinding(),
    ),
    GetPage(
      name: _Paths.CONSULTANT_PROFILE,
      page: () => const ConsultantProfileView(),
      binding: ConsultantProfileBinding(),
    ),
    GetPage(
      name: _Paths.CONSULTANT_PROFILE_EDIT,
      page: () => const ConsultantProfileEditView(),
      binding: ConsultantProfileBinding(),
    ),
    GetPage(
      name: _Paths.PROGRAM_DETAIL,
      page: () => const ProgramDetailView(),
      binding: ProgramBinding(),
    ),
    GetPage(
      name: _Paths.PACKAGE_LIST,
      page: () => const PackageListView(),
      binding: PackageBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_CHECKOUT,
      page: () => const PaymentCheckoutView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_METHOD_SELECTION,
      page: () => const PaymentMethodSelectionView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_PROCESS,
      page: () => const PaymentProcessView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_SUCCESS,
      page: () => const PaymentSuccessView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_MANUAL_TRANSFER,
      page: () => const PaymentManualTransferView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_HISTORY,
      page: () => const TransactionHistoryView(),
      binding: TransactionBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
  ];
}
