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

    // Tambahkan pesan user
    messages.add(Message(text: userMessage, isUser: true));

    textC.clear(); // ✅ clear setelah kirim

    // Reset input
    userInput.value = '';

    // Scroll ke bawah setelah update
    _scrollToBottom();

    // Tampilkan typing indicator
    isTyping.value = true;

    // Panggil API untuk mendapatkan response bot
    try {
      final botResponse = await ChatbotService.getChatResponse(userMessage);

      // Tambahkan response bot
      messages.add(
        Message(
          text: botResponse,
          isUser: false,
        ),
      );
    } catch (e) {
      // Jika ada error, tampilkan pesan error
      messages.add(
        Message(
          text: "Maaf, terjadi kesalahan. Silakan coba lagi nanti.",
          isUser: false,
        ),
      );
      print('Error getting bot response: $e');
    } finally {
      // Hilangkan typing indicator
      isTyping.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollC.hasClients) {
        scrollC.animateTo(
          scrollC.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textC.dispose();
    scrollC.dispose();
    super.onClose();
  }
}
