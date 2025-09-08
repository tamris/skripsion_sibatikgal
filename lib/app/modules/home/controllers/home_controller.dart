import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/informasi_model.dart';

class QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  QuickAction({required this.icon, required this.label, this.onTap});
}

class HomeController extends GetxController {
  // greeting/user
  final userName = 'Rizqi Pratama'.obs;
  var greeting = ''.obs;

  // Search
  final searchC = TextEditingController();

  // Carousel
  final PageController pageC = PageController(viewportFraction: 0.98);

  final currentBanner = 0.obs;
  final banners = <String>[
    'assets/images/news4.png',
    'assets/images/news2.png',
    'assets/images/news3.png',
  ].obs;

  // Quick actions
  late final actions = <QuickAction>[
    QuickAction(
        icon: Icons.style,
        label: 'Galeri Batik',
        onTap: () => Get.toNamed('/galeri-page')),
    QuickAction(
        icon: Icons.center_focus_strong,
        label: 'Deteksi',
        onTap: () => Get.toNamed('/detect')),
    QuickAction(
        icon: Icons.map_outlined,
        label: 'Peta',
        onTap: () => Get.toNamed('/mapping')),
    QuickAction(
        icon: Icons.info_outline,
        label: 'Informasi',
        onTap: () => Get.toNamed('/news')),
  ];

  // informasi / news
  final news = <NewsItem>[
    NewsItem(
      title: 'Festival Batik Nasional Tegalan 2025',
      subtitle: 'Dalam rangka memperingatai hari Batik Nasional Tahun 2025',
      deskripsi:
          'Saksikan kemeriahan dan kekayaan budaya dalam "Festival Batik Nasional Tegalan 2025"! Diselenggarakan untuk merayakan Hari Batik Nasional, acara akbar ini bertujuan untuk melestarikan serta mempromosikan keindahan Batik Tegalan kepada masyarakat luas. Festival ini menjadi panggung utama bagi para perajin, desainer, dan pecinta batik untuk berkumpul, berbagi inspirasi, dan merayakan warisan budaya yang tak ternilai harganya.\n\nFestival akan dimeriahkan dengan berbagai rangkaian acara menarik yang dirancang untuk semua kalangan. Pengunjung dapat menikmati pameran koleksi batik klasik dan kontemporer, mengikuti lokakarya membatik untuk merasakan langsung proses kreatifnya, serta menyaksikan peragaan busana yang memukau. Tak hanya itu, akan ada juga bincang-bincang inspiratif bersama para maestro batik dan bazar kuliner khas Tegal yang akan melengkapi pengalaman budaya Anda.',
      categori: 'Berita Terkini',
      image: 'assets/images/news5.png',
    ),
    NewsItem(
      title:
          'Batik Ciprat Tegal, Tren Baru yang Populer di Kalangan Anak Muda dan Pegawai Pemerintahan',
      subtitle:
          'BATIK CIPRAT - Perajin batik, Muslikha menunjukkan batik ciprat di Galery Batik Rizki Ayu',
      deskripsi:
          'Batik Ciprat khas Tegal kini menjadi primadona baru di dunia mode, berhasil mencuri perhatian berkat gayanya yang segar dan modern. Dengan corak abstrak serta percikan warna yang dinamis, batik ini berhasil menarik minat generasi muda dan kalangan pegawai pemerintahan yang ingin tampil modis namun tetap berakar pada budaya. Estetikanya yang unik memberikan alternatif dari motif batik tradisional yang lebih formal.\n\nKeistimewaan Batik Ciprat terletak pada proses pembuatannya. Dibuat dengan teknik cipratan malam (lilin batik) secara manual, setiap helai kainnya menghasilkan motif yang eksklusif dan tidak pernah ada duanya. Proses ini menjadikan setiap karya sebagai sebuah "lukisan" personal yang merefleksikan kreativitas perajinnya. Inilah bukti nyata bagaimana tradisi dapat berinovasi dan berpadu serasi dengan tren zaman sekarang, menghasilkan karya yang otentik dan berkarakter.',
      categori: 'Sosok & Inspirasi',
      image: 'assets/images/news8.jpg',
    ),
    NewsItem(
      title: 'Taryo, Penggiat Batik Tegalan Sejak 1973',
      subtitle: 'Bersama pengrajin lokal',
      deskripsi:
          'Kenali sosok inspiratif di balik lestarinya Batik Tegalan, Taryo. Sejak tahun 1973, beliau telah mendedikasikan hidupnya untuk menjaga keaslian dan mengembangkan seni batik khas Tegal. Dengan ketekunan yang luar biasa, ia terus berkarya, menjaga agar motif-motif kuno Tegalan tidak punah ditelan zaman, sekaligus berinovasi untuk menciptakan desain-desain baru yang relevan.\n\nKontribusi Taryo tidak berhenti pada karyanya sendiri. Beliau adalah pilar bagi komunitas perajin lokal, aktif membina dan berkolaborasi untuk memastikan regenerasi pembatik terus berjalan. Melalui kerja kerasnya, Taryo telah membantu menciptakan ekosistem yang mendukung keberlanjutan industri batik di Tegal. Kisahnya bukan hanya tentang seorang seniman, tetapi tentang seorang penjaga budaya yang semangatnya menjadi cerminan dalam mempertahankan identitas bangsa.',
      categori: 'Wawasan & Edukasi',
      image: 'assets/images/news7.jpg',
    ),
    NewsItem(
      title: 'Festival Batik Tegalan Heritage 2024',
      subtitle: 'Merayakan Warisan Budaya Tegal',
      deskripsi:
          'Saksikan kemeriahan Festival Batik Tegalan Heritage 2024 yang akan diselenggarakan di Alun-alun Kota Tegal pada 15-17 November 2024. Event spektakuler ini menampilkan pameran karya batik terbaik dari puluhan pengrajin lokal, termasuk koleksi eksklusif dari maestro batik Taryo yang telah berkarya sejak 1973.\n\nFestival ini menawarkan beragam kegiatan menarik seperti workshop membatik untuk pemula, fashion show batik kontemporer, talk show bersama para ahli batik, dan pasar batik dengan harga spesial. Pengunjung juga dapat menyaksikan demo langsung proses pembuatan batik tulis tradisional dan berinteraksi dengan para pengrajin berpengalaman.\n\nAcara ini tidak hanya sebagai ajang promosi batik Tegalan, tetapi juga sebagai upaya pelestarian budaya dan pemberdayaan ekonomi kreatif lokal. Dengan mengusung tema "Batik Tegalan: Dari Tradisi Menuju Inovasi", festival ini diharapkan dapat menarik wisatawan dan meningkatkan apresiasi masyarakat terhadap kekayaan budaya Indonesia.',
      categori: 'Event',
      image: 'assets/images/news9.jpg',
    ),
  ].obs;

  void onBannerChanged(int i) => currentBanner.value = i;

  @override
  void onClose() {
    pageC.dispose();
    searchC.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    loadGreeting();
  }

  void loadGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      greeting.value = "Sugeng Enjing!";
    } else if (hour < 15) {
      greeting.value = "Sugeng Siang!";
    } else if (hour < 18) {
      greeting.value = "Sugeng Sonten!";
    } else {
      greeting.value = "Sugeng Dalu!";
    }
  }
}
