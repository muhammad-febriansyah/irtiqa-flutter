// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const BOTTOMNAVIGATOR = _Paths.BOTTOMNAVIGATOR;
  static const CONSULTATION_CREATE = _Paths.CONSULTATION_CREATE;
  static const DREAM = _Paths.DREAM;
  static const DREAM_CREATE = _Paths.DREAM_CREATE;
  static const DREAM_DETAIL = _Paths.DREAM_DETAIL;
  static const PROFILE_EDIT = _Paths.PROFILE_EDIT;
  static const ABOUT = _Paths.ABOUT;
  static const HELP = _Paths.HELP;
  static const EDUCATION_ARTICLE = _Paths.EDUCATION_ARTICLE;
  static const EDUCATION_FAQ = _Paths.EDUCATION_FAQ;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const WELCOME = _Paths.WELCOME;
  static const HOTLINES = _Paths.HOTLINES;
  static const JOURNAL = _Paths.JOURNAL;
  static const JOURNAL_CREATE = _Paths.JOURNAL_CREATE;
  static const CONSULTANT_APPLICATION = _Paths.CONSULTANT_APPLICATION;
  static const PRIVACY_POLICY = _Paths.PRIVACY_POLICY;
  static const DATA_MANAGEMENT = _Paths.DATA_MANAGEMENT;
  static const DREAM_EDUCATION_GATE = _Paths.DREAM_EDUCATION_GATE;
  static const CONSULTANT_DASHBOARD = _Paths.CONSULTANT_DASHBOARD;
  static const CONSULTANT_QUEUE = _Paths.CONSULTANT_QUEUE;
  static const CONSULTANT_ACTIVE = _Paths.CONSULTANT_ACTIVE;
  static const CONSULTANT_TICKET_DETAIL = _Paths.CONSULTANT_TICKET_DETAIL;
  static const PACKAGE_LIST = _Paths.PACKAGE_LIST;
  static const PAYMENT_CHECKOUT = _Paths.PAYMENT_CHECKOUT;
  static const PAYMENT_METHOD_SELECTION = _Paths.PAYMENT_METHOD_SELECTION;
  static const PAYMENT_PROCESS = _Paths.PAYMENT_PROCESS;
  static const PAYMENT_SUCCESS = _Paths.PAYMENT_SUCCESS;
  static const PAYMENT_MANUAL_TRANSFER = _Paths.PAYMENT_MANUAL_TRANSFER;
  static const TRANSACTION_HISTORY = _Paths.TRANSACTION_HISTORY;
  static const TRANSACTION_DETAIL = _Paths.TRANSACTION_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const BOTTOMNAVIGATOR = '/bottomnavigator';
  static const CONSULTATION_CREATE = '/consultation/create';
  static const DREAM = '/dream';
  static const DREAM_CREATE = '/dream/create';
  static const DREAM_DETAIL = '/dream/detail';
  static const PROFILE_EDIT = '/account/profile/edit';
  static const ABOUT = '/account/about';
  static const HELP = '/account/help';
  static const EDUCATION_ARTICLE = '/education/article/:id';
  static const EDUCATION_FAQ = '/education/faq/:id';
  static const ONBOARDING = '/onboarding';
  static const WELCOME = '/welcome';
  static const HOTLINES = '/hotlines';
  static const JOURNAL = '/journal';
  static const JOURNAL_CREATE = '/journal/create';
  static const CONSULTANT_APPLICATION = '/consultant-application';
  static const PRIVACY_POLICY = '/privacy/policy';
  static const DATA_MANAGEMENT = '/privacy/data-management';
  static const DREAM_EDUCATION_GATE = '/dream/education-gate';
  static const CONSULTANT_DASHBOARD = '/consultant/dashboard';
  static const CONSULTANT_QUEUE = '/consultant/queue';
  static const CONSULTANT_ACTIVE = '/consultant/active';
  static const CONSULTANT_TICKET_DETAIL = '/consultant/ticket/:id';
  static const PACKAGE_LIST = '/package/list';
  static const PAYMENT_CHECKOUT = '/payment/checkout';
  static const PAYMENT_METHOD_SELECTION = '/payment/method-selection';
  static const PAYMENT_PROCESS = '/payment/process';
  static const PAYMENT_SUCCESS = '/payment/success';
  static const PAYMENT_MANUAL_TRANSFER = '/payment/manual-transfer';
  static const TRANSACTION_HISTORY = '/transaction/history';
  static const TRANSACTION_DETAIL = '/transaction/detail/:id';
}
