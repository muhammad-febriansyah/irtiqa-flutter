import 'package:get/get.dart';
import 'package:irtiqa/app/data/models/package_model.dart';
import 'package:irtiqa/app/data/models/payment_method_model.dart';
import 'package:irtiqa/app/data/models/transaction_model.dart';
import 'package:irtiqa/app/data/repositories/payment_repository.dart';

class PaymentController extends GetxController {
  final PaymentRepository _repository = PaymentRepository();

  final paymentMethods = <PaymentMethodModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final selectedPackage = Rx<PackageModel?>(null);
  final selectedPaymentMethod = Rx<PaymentMethodModel?>(null);
  final selectedPaymentType = 'duitku'.obs; // duitku or manual_transfer

  // For linking to consultation
  final consultationId = Rx<int?>(null);
  final ticketId = Rx<int?>(null);

  // Current transaction
  final currentTransaction = Rx<TransactionModel?>(null);

  void setPackage(PackageModel package) {
    selectedPackage.value = package;
  }

  void setConsultationContext({int? consultId, int? ticketIdValue}) {
    consultationId.value = consultId;
    ticketId.value = ticketIdValue;
  }

  void selectPaymentType(String type) {
    selectedPaymentType.value = type;
    selectedPaymentMethod.value = null;
  }

  void selectPaymentMethod(PaymentMethodModel method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> loadPaymentMethods() async {
    if (selectedPackage.value == null) {
      Get.snackbar('Error', 'Paket belum dipilih');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final amount = selectedPackage.value!.price.toInt();
      paymentMethods.value = await _repository.getPaymentMethods(
        amount: amount,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat metode pembayaran: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createTransaction() async {
    if (selectedPackage.value == null) {
      Get.snackbar('Error', 'Paket belum dipilih');
      return false;
    }

    if (selectedPaymentType.value == 'duitku' &&
        selectedPaymentMethod.value == null) {
      Get.snackbar('Error', 'Metode pembayaran belum dipilih');
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final transaction = await _repository.createTransaction(
        packageId: selectedPackage.value!.id,
        paymentMethod: selectedPaymentType.value,
        consultationId: consultationId.value,
        ticketId: ticketId.value,
        paymentChannel: selectedPaymentMethod.value?.paymentMethod,
      );

      currentTransaction.value = transaction;
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal membuat transaksi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkPaymentStatus() async {
    if (currentTransaction.value == null) return;

    try {
      final updated = await _repository.checkTransactionStatus(
        currentTransaction.value!.id,
      );
      currentTransaction.value = updated;
    } catch (e) {
      // Silent fail for status check
    }
  }

  Future<bool> uploadPaymentProof(String filePath) async {
    if (currentTransaction.value == null) {
      Get.snackbar('Error', 'Transaksi tidak ditemukan');
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final updated = await _repository.uploadPaymentProof(
        currentTransaction.value!.id,
        filePath,
      );

      currentTransaction.value = updated;
      Get.snackbar(
        'Berhasil',
        'Bukti pembayaran berhasil diunggah',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal mengunggah bukti: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> cancelTransaction({String? reason}) async {
    if (currentTransaction.value == null) return false;

    try {
      isLoading.value = true;
      final success = await _repository.cancelTransaction(
        currentTransaction.value!.id,
        reason: reason,
      );

      if (success) {
        Get.snackbar(
          'Berhasil',
          'Transaksi dibatalkan',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return success;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membatalkan transaksi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  List<PaymentMethodModel> get virtualAccountMethods {
    return paymentMethods.where((m) => m.isVirtualAccount).toList();
  }

  List<PaymentMethodModel> get eWalletMethods {
    return paymentMethods.where((m) => m.isEWallet).toList();
  }

  List<PaymentMethodModel> get qrisMethods {
    return paymentMethods.where((m) => m.isQRIS).toList();
  }

  List<PaymentMethodModel> get retailMethods {
    return paymentMethods.where((m) => m.isRetail).toList();
  }

  @override
  void onClose() {
    // Reset state when controller is disposed
    selectedPackage.value = null;
    selectedPaymentMethod.value = null;
    currentTransaction.value = null;
    consultationId.value = null;
    ticketId.value = null;
    super.onClose();
  }
}
