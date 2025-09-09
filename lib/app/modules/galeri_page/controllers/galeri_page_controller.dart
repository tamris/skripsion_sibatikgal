import 'dart:async';
import 'package:batikara/app/data/models/batik_model.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GaleriPageController extends GetxController {
  // Query pencarian
  final RxString searchQuery = ''.obs;
  final count = 0.obs;
  final currentBanner = 0.obs;

  void onSearchChanged(String query) {
    searchQuery.value = query;
    update();
  }

  final List<String> banners = [
    'assets/images/Sekar Jagad.jpg',
    'assets/images/Kembang Pacar.jpg',
    'assets/images/Poci Tahu Aci.jpg',
    'assets/images/Sidomulyo.jpg',
  ];

  // CHANGED: mulai dari halaman 1 (karena 0 dipakai "tail clone")
  final PageController pageC = PageController(initialPage: 1); // CHANGED

  // dipanggil saat page berubah (index real = virtualIndex - 1)
  void onBannerChanged(int index) {
    currentBanner.value = index;
  }

  // ========== Auto-play ==========
  final Duration autoPlayInterval = const Duration(seconds: 3);
  final Duration slideDuration = const Duration(milliseconds: 630);
  final Curve slideCurve = Curves.easeInOut;

  Timer? _autoTimer;

  void startAutoPlay() {
    _autoTimer?.cancel();
    if (banners.isEmpty) return;

    _autoTimer = Timer.periodic(autoPlayInterval, (_) {
      pageC.nextPage(duration: slideDuration, curve: slideCurve);
    });
  }

  void stopAutoPlay() {
    _autoTimer?.cancel();
    _autoTimer = null;
  }

  void jumpSilently(int page) {
    // NEW
    pageC.jumpToPage(page);
  }

  @override
  void onInit() {
    super.onInit();
    startAutoPlay();
  }

  @override
  void onClose() {
    stopAutoPlay();
    pageC.dispose();
    super.onClose();
  }

  final batikList = <BatikModel>[
    BatikModel(
      title: 'Sekar Jagad',
      deskripsi:
          'Motif Sekar Jagad adalah salah satu motif batik paling filosofis dari Indonesia, yang namanya sering diartikan sebagai "bunga sedunia" atau "peta dunia". Interpretasi pertama, dari bahasa Jawa **"sekar" (bunga)** dan **"jagad" (dunia)**, melambangkan kumpulan keindahan flora dari seluruh penjuru alam. Interpretasi kedua, yang diyakini berasal dari pengaruh Belanda **"kar" (peta)** dan **"jagad" (dunia)**, melihatnya sebagai representasi keragaman budaya di seluruh dunia.\n\n'
          'Secara visual, motif ini sangat khas karena terdiri dari fragmen-fragmen atau "pulau-pulau" yang berisi aneka corak batik yang berbeda dan tidak saling berhubungan. Pola ini melambangkan **harmoni dalam keberagaman**, sebuah perayaan atas kehidupan yang rukun meskipun terdiri dari berbagai latar belakang suku, budaya, dan sosial. Karena maknanya yang mendalam, Sekar Jagad sering dikenakan dalam upacara pernikahan dengan harapan agar pasangan dapat membangun dunia mereka sendiri yang indah dan harmonis.\n\n'
          'Keunikan Sekar Jagad terletak pada strukturnya yang bebas dan tidak terikat oleh pola geometris yang kaku seperti motif *parang* atau *ceplok*. Hal ini membuatnya menjadi favorit di kalangan desainer modern yang ingin mengeksplorasi kekayaan batik dalam busana kontemporer. Fleksibilitas motif ini memungkinkan perpaduan warna yang cerah dan dinamis, menjadikannya simbol abadi dari keindahan Indonesia yang beragam dan selalu relevan dengan perkembangan zaman.',
      image: 'assets/images/Sekar Jagad.jpg',
    ),
    BatikModel(
      title: 'Kembang Pacar',
      deskripsi:
          'Motif Kembang Pacar terinspirasi dari keindahan **bunga pacar air (henna)**, sebuah tanaman yang bunganya kecil namun memancarkan pesona kesederhanaan dan keceriaan. Ciri khas motif ini adalah pengulangan pola-pola floral berukuran kecil yang disusun secara rapi dan teratur, sering kali dihiasi dengan isian titik-titik (cecek) untuk menambah tekstur. Desainnya yang simpel dan elegan ini merupakan simbol dari kecantikan yang bersahaja dan alami.\n\n'
          'Filosofi di balik motif Kembang Pacar adalah cerminan dari sifat-sifat luhur seperti **keanggunan, kesetiaan, dan kebahagiaan yang tulus**. Pola ini mengajarkan bahwa keindahan sejati tidak selalu datang dari sesuatu yang megah, melainkan dari hal-hal kecil yang tulus dan sederhana. Karena kesannya yang ceria namun tetap sopan, batik ini sangat populer untuk digunakan dalam berbagai kesempatan, mulai dari busana sehari-hari hingga acara semi-formal.\n\n'
          'Dalam klasifikasi motif batik, Kembang Pacar dapat digolongkan sebagai motif *ceplokan* dengan inspirasi flora. Kesederhanaan polanya membuat motif ini sangat serbaguna. Terkadang ia tampil sebagai motif utama, namun tidak jarang pula dijadikan sebagai *isen-isen* atau pola pengisi latar belakang untuk motif lain yang lebih kompleks. Peran gandanya ini membuktikan bahwa keindahan yang sederhana dapat menjadi fondasi yang memperkuat kemegahan yang lebih besar.',
      image: 'assets/images/Kembang Pacar.jpg',
    ),
    BatikModel(
      title: 'Poci Tahu Aci',
      deskripsi:
          'Motif Poci Tahu Aci merupakan contoh nyata dari **batik identitas**, sebuah inovasi modern dari Tegal yang mengangkat ikon-ikon lokal untuk merepresentasikan budayanya. Motif ini secara jelas menggambarkan dua elemen khas Tegal: **poci** dari tanah liat yang menjadi pusat tradisi minum teh (dikenal dengan istilah "moci"), dan **tahu aci**, kuliner kebanggaan daerah. Motif ini lahir dari keinginan untuk membuat batik lebih dekat dengan kehidupan masyarakat dan menjadi duta budaya Tegal.\n\n'
          'Setiap elemen dalam motif ini adalah simbol **kearifan lokal dan kebanggaan daerah**. Poci melambangkan nilai-nilai keramahan, kehangatan dalam pergaulan, dan budaya komunal yang kuat di Tegal. Sementara itu, tahu aci adalah representasi dari kreativitas dan kekayaan kuliner yang menjadi bagian tak terpisahkan dari identitas kota. Memakai batik ini bukan sekadar berbusana, melainkan sebuah pernyataan cinta terhadap tanah kelahiran.\n\n'
          'Berbeda dengan batik klasik yang sarat akan filosofi Jawa kuno, motif Poci Tahu Aci lebih berfokus pada narasi kontemporer dan promosi daerah. Kehadirannya menjadi penggerak ekonomi kreatif lokal, memberikan para pengrajin medium baru untuk berekspresi sekaligus memperkuat *branding* kota Tegal. Motif ini adalah bukti bahwa batik adalah seni yang hidup, dinamis, dan mampu beradaptasi untuk menceritakan kisah-kisah baru dari setiap generasi.',
      image: 'assets/images/Poci Tahu Aci.jpg',
    ),
    BatikModel(
      title: 'Sidomulyo',
      deskripsi:
          'Sidomulyo adalah salah satu motif batik klasik dari lingkungan keraton yang memiliki makna spiritual mendalam. Namanya tersusun dari dua kata dalam bahasa Jawa, **"sido" (menjadi/terlaksana)** dan **"mulyo" (mulia/makmur)**. Secara harfiah, motif ini adalah untaian doa agar pemakainya dapat meraih kehidupan yang penuh dengan kemuliaan, kehormatan, dan kesejahteraan baik secara material maupun spiritual.\n\n'
          'Secara tradisional, Sidomulyo merupakan busana yang dikhususkan bagi **pasangan pengantin** dalam upacara pernikahan adat Jawa. Dengan mengenakan motif ini, kedua mempelai diharapkan dapat memulai kehidupan rumah tangga yang luhur dan bahagia. Ciri khas visualnya adalah pola dasar geometris berbentuk belah ketupat yang di dalamnya diisi dengan beragam ornamen kaya makna, seperti singgasana, garuda, atau pohon hayat yang melambangkan kemakmuran.\n\n'
          'Motif ini termasuk dalam rumpun motif **"Sido"** yang lebih besar, di mana setiap variasinya memiliki penekanan doa yang sedikit berbeda. Misalnya, *Sidoluhur* untuk keluhuran budi, *Sidomukti* untuk kebahagiaan, dan *Sidoasih* untuk kasih sayang. Keberadaan rumpun motif ini menunjukkan betapa dalam masyarakat Jawa, batik bukan sekadar kain, melainkan medium untuk menyampaikan harapan dan doa-doa terbaik dalam setiap fase penting kehidupan manusia.',
      image: 'assets/images/Sidomulyo.jpg',
    ),
  ].obs;
}
