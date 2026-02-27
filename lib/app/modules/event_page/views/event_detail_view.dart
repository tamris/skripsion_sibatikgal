import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../data/models/event_model.dart';
import '../controllers/event_page_controller.dart';

class EventDetailView extends GetView<EventPageController> {
  const EventDetailView({super.key});

  Future<void> _openMap(String lat, String lng) async {
    // Format URL resmi Google Maps untuk koordinat spesifik
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";

    try {
      if (await canLaunchUrlString(googleMapsUrl)) {
        await launchUrlString(
          googleMapsUrl,
          mode: LaunchMode
              .externalApplication, // Memaksa buka aplikasi luar (Google Maps)
        );
      } else {
        // Jika tidak bisa buka aplikasi, coba buka lewat browser biasa
        await launchUrlString(googleMapsUrl, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat membuka peta: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tangkap data event dari arguments
    final EventModel? event = Get.arguments;

    // Proteksi jika data null (misal saat hot restart di halaman detail)
    if (event == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.brown[800]),
        body: const Center(child: Text("Data event tidak tersedia")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. BANNER IMAGE
                Hero(
                  tag: 'event-${event.id}',
                  child: Image.network(
                    event.bannerImageUrl ?? '',
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 400, color: Colors.grey[300]),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. KATEGORI BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF3E8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.kategori?.toUpperCase() ?? 'EVENT',
                          style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. JUDUL EVENT
                      Text(
                        event.title ?? '',
                        style: GoogleFonts.lora(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3E2723)),
                      ),
                      const SizedBox(height: 24),

                      // 4. KOTAK INFO TANGGAL & WAKTU
                      Row(
                        children: [
                          _buildInfoBox(
                            icon: Icons.calendar_today_outlined,
                            label: "Tanggal",
                            value:
                                event.formattedDate, // Menggunakan getter model
                          ),
                          const SizedBox(width: 16),
                          _buildInfoBox(
                            icon: Icons.access_time,
                            label: "Waktu",
                            value:
                                event.formattedTime, // Menggunakan getter model
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 5. KOTAK LOKASI
                      _buildLocationBox(event
                          .displayAddress), // Menggunakan displayAddress baru

                      const SizedBox(height: 30),

                      // 6. DESKRIPSI
                      Text(
                        "Deskripsi Acara",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF3E2723)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.description ?? 'Tidak ada deskripsi tersedia.',
                        style: GoogleFonts.mulish(
                            color: Colors.grey[700], fontSize: 15, height: 1.6),
                        textAlign: TextAlign.justify,
                      ),

                      const SizedBox(
                          height: 120), // Memberi ruang untuk bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),

          // TOMBOL KEMBALI & BOOKMARK
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(
                  icon: Icons.arrow_back,
                  onTap: () => Get.back(),
                ),
                _buildCircularButton(
                  icon: Icons.bookmark_border,
                  onTap: () => Get.snackbar(
                      "Simpan", "Fitur bookmark sedang dikembangkan"),
                ),
              ],
            ),
          ),
        ],
      ),
      // 7. BOTTOM ACTION BAR
      bottomSheet: _buildBottomBar(event),
    );
  }

  // WIDGET HELPERS
  Widget _buildCircularButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        radius: 22,
        child: Icon(icon, color: Colors.black, size: 20),
      ),
    );
  }

  Widget _buildInfoBox(
      {required IconData icon, required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFD4AF37), size: 20),
            const SizedBox(height: 8),
            Text(label,
                style: GoogleFonts.mulish(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.mulish(
                    fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationBox(String address) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_outlined,
              color: Color(0xFFD4AF37), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lokasi",
                  style: GoogleFonts.mulish(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(address,
                    style: GoogleFonts.mulish(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Harga Tiket",
                    style:
                        GoogleFonts.mulish(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  event.isFree == true ? "Gratis" : "Rp ${event.price}",
                  style: GoogleFonts.mulish(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723)),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () =>
                _openMap(event.latitude ?? '0', event.longitude ?? '0'),
            icon: const Icon(Icons.near_me_outlined, size: 20),
            label:
                Text("Petunjuk Arah", style: GoogleFonts.mulish(fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4E342E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
