import 'package:get/get.dart';
import 'package:irtiqa/app/data/models/transaction_model.dart';
import 'package:irtiqa/app/data/repositories/payment_repository.dart';

class TransactionController extends GetxController {
  final PaymentRepository _repository = PaymentRepository();

  final transactions = <TransactionModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedTransaction = Rx<TransactionModel?>(null);

  final currentPage = 1.obs;
  final hasMorePages = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      transactions.clear();
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final newTransactions = await _repository.getTransactions(
        page: currentPage.value,
      );

      if (refresh) {
        transactions.value = newTransactions;
      } else {
        transactions.addAll(newTransactions);
      }

      // Check if there are more pages (simple check based on result count)
      hasMorePages.value = newTransactions.length >= 15;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat transaksi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMorePages.value || isLoading.value) return;
    currentPage.value++;
    await loadTransactions();
  }

  Future<void> loadTransactionDetail(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      selectedTransaction.value = await _repository.getTransactionDetail(id);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat detail transaksi: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTransactionStatus(int id) async {
    try {
      final updated = await _repository.checkTransactionStatus(id);

      // Update in list
      final index = transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        transactions[index] = updated;
      }

      // Update selected if it's the same transaction
      if (selectedTransaction.value?.id == id) {
        selectedTransaction.value = updated;
      }
    } catch (e) {
      // Silent fail for status refresh
    }
  }

  List<TransactionModel> get pendingTransactions {
    return transactions.where((t) => t.isPending).toList();
  }

  List<TransactionModel> get paidTransactions {
    return transactions.where((t) => t.isPaid).toList();
  }

  List<TransactionModel> get failedTransactions {
    return transactions.where((t) => t.isFailed || t.isExpired).toList();
  }
}
