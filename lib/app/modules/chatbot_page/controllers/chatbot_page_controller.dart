import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/chatbot_model.dart';
import '../../../data/service/chatbot_service.dart';

class ChatbotPageController extends GetxController {
  var messages = <Message>[].obs;
  var userInput = ''.obs;

  final textC = TextEditingController();
  final scrollC = ScrollController();

  var isTyping = false.obs;

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = text.trim();

    // 1. Ubah .add menjadi .insert(0, ...) agar pesan muncul di posisi paling bawah
    messages.insert(0, Message(text: userMessage, isUser: true));

    textC.clear();
    userInput.value = '';

    // 2. Karena pakai reverse: true, kita tidak butuh lagi manual scroll ke bawah
    // Pesan di index 0 otomatis terlihat di atas input bar.

    isTyping.value = true;

    try {
      final botResponse = await ChatbotService.getChatResponse(userMessage);

      // 3. Masukkan respon bot juga ke index 0
      messages.insert(
        0,
        Message(
          text: botResponse,
          isUser: false,
        ),
      );
    } catch (e) {
      messages.insert(
        0,
        Message(
          text: "Maaf, terjadi kesalahan. Silakan coba lagi nanti.",
          isUser: false,
        ),
      );
    } finally {
      isTyping.value = false;
      // _scrollToBottom() sudah tidak diperlukan
    }
  }

  @override
  void onClose() {
    textC.dispose();
    scrollC.dispose();
    super.onClose();
  }
}
