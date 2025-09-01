import 'package:batikara/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width <= 550;

    return Obx(() => Scaffold(
          backgroundColor: controller.bgColors[controller.currentPage.value],
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: controller.pageC,
                    onPageChanged: controller.onChanged,
                    itemCount: controller.contents.length,
                    itemBuilder: (context, i) {
                      final item = controller.contents[i];
                      return Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 4 / 3,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Image.asset(item.image),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item.desc,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Mulish",
                                fontWeight: FontWeight.w300,
                                fontSize: isCompact ? 16 : 18,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // DOTS + BUTTONS
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          controller.contents.length,
                          (index) => _Dot(
                              active: controller.currentPage.value == index),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Obx(() {
                          final last = controller.currentPage.value + 1 ==
                              controller.contents.length;
                          if (last) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: controller.start,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD3582E),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isCompact ? 100 : width * 0.2,
                                    vertical: isCompact ? 18 : 22,
                                  ),
                                  textStyle:
                                      TextStyle(fontSize: isCompact ? 13 : 16),
                                ),
                                child: const Text("START",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: controller.skipToEnd,
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFFD3582E),
                                  textStyle: TextStyle(
                                    fontFamily: "Mulish",
                                    fontWeight: FontWeight.w600,
                                    fontSize: isCompact ? 13 : 16,
                                  ),
                                ),
                                child: const Text("SKIP"),
                              ),
                              ElevatedButton(
                                onPressed: controller.next,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD3582E),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 18),
                                  textStyle: TextStyle(
                                      fontSize: isCompact ? 13 : 16,
                                      fontFamily: "Mulish"),
                                ),
                                child: const Text("NEXT",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      margin: const EdgeInsets.only(right: 6),
      height: 10,
      width: active ? 22 : 10,
      decoration: BoxDecoration(
        color: const Color(0xFFD3582E),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
