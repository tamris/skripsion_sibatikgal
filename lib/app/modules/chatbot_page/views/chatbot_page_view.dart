import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/chatbot_page_controller.dart';
import '../widgets/typing_indicator_widget.dart';

class ChatbotPageView extends GetView<ChatbotPageController> {
  const ChatbotPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        title: Text("TikAI",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 28)),
        backgroundColor: const Color(0xFFF5F5F5),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Daftar pesan
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollC,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  // Tambah 1 untuk typing indicator jika sedang typing
                  itemCount: controller.messages.length +
                      (controller.isTyping.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Jika index adalah item terakhir dan sedang typing, tampilkan typing indicator
                    if (index == controller.messages.length &&
                        controller.isTyping.value) {
                      return const TypingIndicatorWidget();
                    }

                    final msg = controller.messages[index];
                    final isUser = msg.isUser;

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: ConstrainedBox(
                        // bubble max 75% lebar layar
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF8A5A44)
                                : Colors.grey.shade300,
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
                          child: Text(
                            msg.text,
                            softWrap: true,
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                                height: 1.4,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
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
                          ? null // Disable button saat typing
                          : () => controller.sendMessage(controller.textC.text),
                      child: CircleAvatar(
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
