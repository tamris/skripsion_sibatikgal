import 'package:flutter/material.dart';
import 'package:batikara/app/data/models/batik_model.dart';

class BatikHeroImage extends StatelessWidget {
  final BatikModel batik;
  const BatikHeroImage({super.key, required this.batik});

  @override
  Widget build(BuildContext context) {
    const Color bgImage = Color(0xFFEEDCC5);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.34,
          decoration: const BoxDecoration(color: bgImage),
          child: batik.image.isNotEmpty
              ? Image.network(batik.image, width: double.infinity, height: double.infinity, fit: BoxFit.cover)
              : const Center(child: Icon(Icons.image, size: 100, color: Colors.grey)),
        ),
      ),
    );
  }
}