class SejarahModel {
  final String era;
  final String tahun;
  final String judul;
  final String deskripsi;
  final List<String> motifChips;
  final String? infoCardJudul;
  final String? infoCardDeskripsi;
  final String? quote;
  final Map<String, String>? stats;
  final bool isAktif;

  const SejarahModel({
    required this.era,
    required this.tahun,
    required this.judul,
    required this.deskripsi,
    this.motifChips = const [],
    this.infoCardJudul,
    this.infoCardDeskripsi,
    this.quote,
    this.stats,
    this.isAktif = false,
  });
}

// ==============================
// DATA SEJARAH BATIK TEGALAN
// ==============================

final List<SejarahModel> sejarahData = const [
  // 1
  SejarahModel(
    era: 'ABAD KE-17',
    tahun: '1677',
    judul: 'Awal Tradisi\nBatik Tegalan',
    deskripsi:
        'Tradisi Batik Tegalan mulai berkembang ketika Raja Amangkurat I melarikan diri ke wilayah Tegal Arum pada tahun 1677. Bersama para pengikut dari lingkungan Kerajaan Mataram, keterampilan membatik diperkenalkan kepada masyarakat dan menjadi cikal bakal berkembangnya Batik Tegalan.',
    motifChips: [
      'Amangkurat I',
      'Keraton Mataram',
    ],
  ),

  // 2
  SejarahModel(
    era: 'ABAD KE-18',
    tahun: '1700-an',
    judul: 'Perkembangan\nBatik Pesisir',
    deskripsi:
        'Sebagai wilayah di jalur perdagangan Pantai Utara Jawa, Batik Tegalan berkembang dengan karakter batik pesisir yang lebih bebas dalam bentuk, warna, dan ragam hias dibandingkan batik keraton.',
    infoCardJudul: 'Karakter Batik Pesisir',
    infoCardDeskripsi:
        'Batik pesisir dikenal memiliki warna yang lebih cerah, motif yang dinamis, serta terbuka terhadap berbagai pengaruh budaya.',
  ),

  // 3
  SejarahModel(
    era: 'AKHIR ABAD KE-19',
    tahun: '1800-an',
    judul: 'Munculnya Identitas\nBatik Tegalan',
    deskripsi:
        'Menjelang akhir abad ke-19, Batik Tegalan mulai dikenal dengan ciri khasnya sendiri. Berbagai motif flora, fauna, serta ornamen khas pesisir berkembang dan menjadi identitas budaya masyarakat Tegal.',
    motifChips: [
      'Flora',
      'Fauna',
      'Motif Pesisir',
    ],
  ),

  // 4
  SejarahModel(
    era: '1908–1914',
    tahun: '1914',
    judul: 'Peran\nRA Kardinah',
    deskripsi:
        'RA Kardinah, istri Bupati Tegal sekaligus adik RA Kartini, berperan penting dalam perkembangan Batik Tegalan. Melalui Sekolah Kepandaian Putri yang didirikannya pada tahun 1914, keterampilan membatik diajarkan kepada perempuan pribumi sehingga tradisi membatik semakin berkembang.',
    quote:
        '"Pendidikan menjadi salah satu sarana penting dalam melestarikan tradisi membatik di Tegal."',
  ),

  // 5
  SejarahModel(
    era: '1950–1990',
    tahun: '1950–1990',
    judul: 'Perkembangan\nSentra Batik',
    deskripsi:
        'Setelah Indonesia merdeka, Batik Tegalan berkembang sebagai industri rumah tangga. Teknik batik tulis dan batik cap semakin banyak digunakan, sementara Desa Bengle menjadi salah satu sentra batik penting di Kabupaten Tegal.',
    stats: {
      'Sentra': 'Desa Bengle',
      'Teknik': 'Tulis & Cap',
    },
  ),

  // 6
  SejarahModel(
    era: '2009',
    tahun: '2 Okt 2009',
    judul: 'Pengakuan\nUNESCO',
    deskripsi:
        'Pada 2 Oktober 2009, UNESCO menetapkan Batik Indonesia sebagai Warisan Budaya Takbenda Dunia. Pengakuan ini turut memperkuat upaya pelestarian Batik Tegalan sebagai bagian dari kekayaan budaya Indonesia.',
    motifChips: [
      'UNESCO',
      'Warisan Budaya',
    ],
  ),

  // 7
  SejarahModel(
    era: 'SEKARANG',
    tahun: '2020-an',
    judul: 'Pelestarian di\nEra Digital',
    deskripsi:
        'Batik Tegalan terus dilestarikan melalui inovasi motif, pengembangan UMKM, pendidikan, pariwisata budaya, serta pemanfaatan teknologi digital untuk memperkenalkan warisan budaya kepada generasi muda.',
    motifChips: [
      'Digital',
      'UMKM',
      'Pelestarian',
    ],
    isAktif: true,
  ),
];

// ==============================
// LABEL CONNECTOR TIMELINE
// ==============================

final List<String> connectorLabels = const [
  'awal tradisi membatik',
  'perkembangan batik pesisir',
  'identitas Batik Tegalan',
  'peran RA Kardinah',
  'perkembangan sentra batik',
  'pengakuan UNESCO',
  'pelestarian era digital',
];
