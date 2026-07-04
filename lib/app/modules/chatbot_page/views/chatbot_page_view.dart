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
    // Palet warna premium konsisten Batikara
    const bgCanvas = Color(0xFFFAF7F2);
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);

    return Scaffold(
      backgroundColor: bgCanvas,
      // ================= FIXED PREMIUM APP BAR =================
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.arrow_back_rounded,
                    color: darkBrown, size: 20),
              ),
            ),
          ),
        ),
        title: Column(
          children: [
            Text(
              "TikAI",
              style: GoogleFonts.lora(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: darkBrown,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E6F3B), // Indikator hijau aktif/online
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "Asisten AI Aktif",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: bgCanvas,
        elevation: 0,
        toolbarHeight: 70,
        surfaceTintColor: Colors.transparent,
      ),

      // ================= BODY CONTENT =================
      body: Column(
        children: [
          // Pembatas garis tipis estetik di bawah AppBar
          Container(height: 1, color: const Color(0xFFE6DFD5).withOpacity(0.5)),

          // Daftar pesan
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollC,
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  itemCount: controller.messages.length +
                      (controller.isTyping.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (controller.isTyping.value && index == 0) {
                      // Custom Typing Indicator bawaan Anda
                      return const TypingIndicatorWidget(
                        dotsColor: darkBrown,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            // Inovasi Visual: Label nama kecil di atas bubble, menghemat ruang samping
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              child: Text(
                                isUser ? "Kamu" : "TikAI",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: textMuted,
                                ),
                              ),
                            ),

                            // Gelembung Chat Asimetris Modern
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.78,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isUser ? darkBrown : Colors.white,
                                  boxShadow: isUser
                                      ? null
                                      : [
                                          BoxShadow(
                                            color: darkBrown.withOpacity(0.03),
                                            blurRadius: 15,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(18),
                                    topRight: const Radius.circular(18),
                                    bottomLeft: isUser
                                        ? const Radius.circular(18)
                                        : const Radius.circular(
                                            4), // Sudut ekor chat AI
                                    bottomRight: isUser
                                        ? const Radius.circular(
                                            4) // Sudut ekor chat User
                                        : const Radius.circular(18),
                                  ),
                                ),
                                child: MarkdownBody(
                                  data: msg.text,
                                  selectable: true,
                                  styleSheet: MarkdownStyleSheet(
                                    p: GoogleFonts.poppins(
                                      color: isUser ? Colors.white : darkBrown,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                    strong: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isUser ? Colors.white : darkBrown,
                                    ),
                                    listBullet: TextStyle(
                                      color: isUser ? Colors.white : darkBrown,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ),

          // ================= SLICK INPUT PANEL =================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            decoration: BoxDecoration(
              color: bgCanvas,
              boxShadow: [
                BoxShadow(
                  color: darkBrown.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textC,
                    minLines: 1,
                    maxLines: 4,
                    cursorColor: darkBrown,
                    textInputAction: TextInputAction.send,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: darkBrown,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: "Tulis pertanyaan ke TikAI...",
                      hintStyle: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: textMuted.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Color(0xFFE6DFD5), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: darkBrown, width: 1.2),
                      ),
                    ),
                    onSubmitted: (val) => controller.sendMessage(val),
                  ),
                ),
                const SizedBox(width: 12),
                Obx(() => GestureDetector(
                      onTap: controller.isTyping.value
                          ? null
                          : () => controller.sendMessage(controller.textC.text),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: controller.isTyping.value
                              ? const Color(0xFFD1C7BD)
                              : darkBrown,
                          shape: BoxShape.circle,
                        ),
                        child: controller.isTyping.value
                            ? const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        accentGold),
                                  ),
                                ),
                              )
                            : const Icon(Icons.send_rounded,
                                color: accentGold, size: 18),
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
