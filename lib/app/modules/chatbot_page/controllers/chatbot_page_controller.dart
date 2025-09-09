import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/chatbot_model.dart';

class ChatbotPageController extends GetxController {
  var messages = <Message>[].obs;
  var userInput = ''.obs;

  final textC = TextEditingController();
  final scrollC = ScrollController();

  var isTyping = false.obs;

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Tambahkan pesan user
    messages.add(Message(text: text, isUser: true));

    textC.clear(); // ✅ clear setelah kirim

    // Reset input
    userInput.value = '';

    // Scroll ke bawah setelah update
    _scrollToBottom();

    // Simulasi balasan bot
    Future.delayed(const Duration(milliseconds: 600), () {
      messages.add(
        Message(
          text:
              "Halo, Saya adalah TikAl, asisten yang dapat menjawab pertanyaan Anda tentang Batik Tegalan. Saya telah mempelajari konten tentang Batik Tegalan dan siap menjawab pertanyaan Anda tentang topik tersebut.",
          isUser: false,
        ),
      );
      isTyping.value = false;
      _scrollToBottom();
    });
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
    scrollC.dispose();
    super.onClose();
  }
}
