import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/chatbot_page_controller.dart';
import '../widgets/typing_indicator_widget.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatbotPageView extends GetView<ChatbotPageController> {
  const ChatbotPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        title: Text("TikAI",
            style: GoogleFonts.lora(fontWeight: FontWeight.w800, fontSize: 28)),
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: Colors.black87,
        elevation: 1,
        shadowColor: Colors.grey.withValues(alpha: 0.3),
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Daftar pesan
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollC,
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.messages.length +
                      (controller.isTyping.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (controller.isTyping.value && index == 0) {
                      // Custom Typing Indicator
                      return const TypingIndicatorWidget(
                        dotsColor: Color(0xFF8A5A44),
                        animationDuration: Duration(milliseconds: 400),
                      );
                    }

                    final messageIndex =
                        controller.isTyping.value ? index - 1 : index;
                    final msg = controller.messages[messageIndex];
                    final isUser = msg.isUser;

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser)
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade400,
                              child: Text(
                                "AI",
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          if (!isUser) const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? const Color(0xFF8A5A44)
                                    : Colors.grey.shade300,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: isUser
                                      ? const Radius.circular(16)
                                      : const Radius.circular(6),
                                  bottomRight: isUser
                                      ? const Radius.circular(6)
                                      : const Radius.circular(16),
                                ),
                              ),
                              child: MarkdownBody(
                                data: msg.text,
                                selectable: true,
                                styleSheet: MarkdownStyleSheet(
                                  p: GoogleFonts.plusJakartaSans(
                                    color:
                                        isUser ? Colors.white : Colors.black87,
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                  strong: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isUser ? Colors.white : Colors.black87,
                                  ),
                                  listBullet: TextStyle(
                                    color:
                                        isUser ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isUser) const SizedBox(width: 8),
                          if (isUser)
                            CircleAvatar(
                              backgroundColor: const Color(0xFF8A5A44),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                )),
          ),

          // Input box
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textC,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: "Kirim pesan ke TikAI",
                      hintStyle: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (val) => controller.sendMessage(val),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => GestureDetector(
                      onTap: controller.isTyping.value
                          ? null
                          : () => controller.sendMessage(controller.textC.text),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: controller.isTyping.value
                            ? Colors.grey
                            : const Color(0xFF8A5A44),
                        child: controller.isTyping.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.send, color: Colors.white),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
