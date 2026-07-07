import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <--- Tambahkan import GetX
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/batik_model.dart'; // <--- Sesuaikan path model batik kamu
import '../controllers/galeri_page_controller.dart'; // <--- Sesuaikan path controller kamu

class BatikActionButtons extends StatefulWidget {
  final BatikModel batik; // <--- TARUH DATA MODEL DI SINI
  const BatikActionButtons({super.key, required this.batik});

  @override
  State<BatikActionButtons> createState() => _BatikActionButtonsState();
}

class _BatikActionButtonsState extends State<BatikActionButtons>
    with SingleTickerProviderStateMixin {
  // State untuk status favorit
  bool _isFavorite = false;

  // Variabel untuk kebutuhan animasi scale (pop)
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // --- TETAP AMAN: Mengambil state bawaan database awal ---
    _isFavorite =
        widget.batik.isLiked; // Mengisi status awal true/false dari backend

    print(
        "DEBUG BUTTON DETAIL -> Motif: ${widget.batik.title}, Status _isFavorite di UI: $_isFavorite");

    // Inisialisasi controller animasi dengan durasi kilat (150 milidetik)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // Membuat efek membesar dari ukuran 1.0 ke 1.3, lalu kembali ke 1.0 (menggunakan kurva lurus/reverse)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Listener untuk memaksa animasi balik kucing (mengecil kembali) setelah mencapai puncaknya
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Amankan memori dari leak
    super.dispose();
  }

  void _handleFavoriteClick() async {
    _animationController.forward(); // Tetap jalankan animasi pop lu[cite: 5]

    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (Get.isRegistered<GaleriPageController>()) {
      final controller = Get.find<GaleriPageController>();
      bool finalStatus = await controller.toggleBatikLikeStatus(widget.batik);

      // Paksa sinkronisasi object widget agar tidak reset saat re-render
      widget.batik.isLiked = finalStatus;

      if (mounted) {
        setState(() {
          _isFavorite = finalStatus;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonColor = Color(0xFF1A1208);
    const Color textligt = Color(0xFFFFD264);

    return Row(
      children: [
        // Tombol Lihat Lokasi Pengrajin
        Expanded(
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
              onPressed: () {
                // Aksi navigasi ke peta lokasi pengrajin
              },
              child: Text(
                'Lihat Lokasi Pengrajin',
                style: GoogleFonts.poppins(
                  color: textligt,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Tombol Love Beranimasi Scale Pop
        GestureDetector(
          onTap: _handleFavoriteClick,
          child: ScaleTransition(
            scale: _scaleAnimation, // Hubungkan ke controller animasi scale
            child: SizedBox(
              width: 50,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: const BorderSide(color: buttonColor, width: 1.2),
                  backgroundColor: Colors.white,
                ),
                onPressed: _handleFavoriteClick, // Satukan aksi ketukan
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 200,
                  ), // Efek transisi perubahan icon
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _isFavorite
                      ? const Icon(
                          Icons.favorite, // Icon hati full saat true
                          key: ValueKey('icon_fav'),
                          color: Color.fromARGB(255, 212, 6, 6),
                          size: 24,
                        )
                      : const Icon(
                          Icons.favorite_border, // Icon hati kosong saat false
                          key: ValueKey('icon_not_fav'),
                          color: Color.fromARGB(255, 212, 6, 6),
                          size: 22,
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
