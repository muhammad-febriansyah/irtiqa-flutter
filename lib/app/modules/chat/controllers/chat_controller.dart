import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/message_model.dart';
import '../../../data/repositories/message_repository.dart';
import 'dart:async';

class ChatController extends GetxController {
  final MessageRepository _repository = MessageRepository();
  final GetStorage _storage = GetStorage();
  final TextEditingController messageController = TextEditingController();

  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;

  late int contextId; // consultation_id atau program_id
  late String contextType; // 'consultation' atau 'program'
  int? currentUserId;

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();

    // Get arguments dari Get.arguments
    if (Get.arguments != null) {
      contextId = Get.arguments['id'] ?? 0;
      contextType = Get.arguments['type'] ?? 'consultation';
    }

    loadMessages();

    // Auto-refresh setiap 10 detik
    _startAutoRefresh();
  }

  @override
  void onClose() {
    messageController.dispose();
    _refreshTimer?.cancel();
    super.onClose();
  }

  void _loadCurrentUser() {
    final userData = _storage.read('user_data');
    if (userData != null) {
      currentUserId = userData['id'];
    }
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      loadMessages(silent: true);
    });
  }

  Future<void> loadMessages({bool silent = false}) async {
    if (!silent) {
      isLoading.value = true;
    }

    try {
      List<MessageModel> fetchedMessages;

      if (contextType == 'consultation') {
        fetchedMessages = await _repository.getConsultationMessages(contextId);
      } else {
        fetchedMessages = await _repository.getProgramMessages(contextId);
      }

      messages.value = fetchedMessages;
    } catch (e) {
      if (!silent) {
        Get.snackbar(
          'Error',
          'Gagal memuat pesan: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (!silent) {
        isLoading.value = false;
      }
    }
  }

  Future<void> sendMessage() async {
    final content = messageController.text.trim();

    if (content.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Pesan tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSending.value = true;

    try {
      MessageModel? newMessage;

      if (contextType == 'consultation') {
        newMessage = await _repository.sendConsultationMessage(
          consultationId: contextId,
          content: content,
        );
      } else {
        newMessage = await _repository.sendProgramMessage(
          programId: contextId,
          content: content,
        );
      }

      if (newMessage != null) {
        // Add to local list
        messages.add(newMessage);

        // Clear input
        messageController.clear();

        // Scroll to bottom (will be handled in view)
      } else {
        Get.snackbar(
          'Gagal',
          'Pesan gagal dikirim',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim pesan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }

  void refreshMessages() {
    loadMessages();
  }
}
