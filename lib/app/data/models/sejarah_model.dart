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
  SejarahModel(
    era: 'ABAD KE-17',
    tahun: '1670-an',
    judul: 'Awal Masuknya\nBudaya Batik',
    deskripsi:
        'Sejarah Batik Tegalan berkaitan dengan pelarian Raja Amangkurat I dari Kerajaan Mataram pada masa Perang Trunojoyo. Pengaruh budaya keraton kemudian menyebar ke masyarakat Tegal dan menjadi awal berkembangnya tradisi batik di wilayah pesisir.',
    motifChips: [
      'Pengaruh Mataram',
      'Budaya Keraton',
    ],
  ),
  SejarahModel(
    era: 'ABAD KE-18',
    tahun: '1700-an',
    judul: 'Akulturasi\nBudaya Pesisir',
    deskripsi:
        'Sebagai daerah pelabuhan, Tegal menerima pengaruh budaya dari pedagang Cina, Arab, dan Belanda. Motif Batik Tegalan berkembang menjadi lebih berani, luwes, dan kaya unsur flora-fauna.',
    infoCardJudul: 'Ciri Batik Pesisir',
    infoCardDeskripsi:
        'Karakter pesisir melahirkan warna yang lebih cerah dan motif yang lebih dinamis dibanding batik pedalaman.',
  ),
  SejarahModel(
    era: 'ABAD KE-19',
    tahun: '1800-an',
    judul: 'Lahirnya Identitas\nBatik Tegalan',
    deskripsi:
        'Pengrajin lokal mulai mengembangkan ciri khas Batik Tegalan melalui perpaduan unsur keraton dan budaya pesisir. Motif flora, fauna, dan garis-garis dinamis mulai banyak digunakan.',
    motifChips: [
      'Flora',
      'Fauna',
      'Motif Pesisir',
    ],
  ),
  SejarahModel(
    era: 'ERA KOLONIAL',
    tahun: '1900-an',
    judul: 'Bertahan di Tengah\nProduksi Modern',
    deskripsi:
        'Masuknya kain pabrikan dari Eropa sempat memengaruhi produksi batik tradisional. Namun masyarakat Tegal tetap mempertahankan tradisi membatik sebagai bagian dari budaya lokal.',
    quote:
        '"Batik menjadi bagian penting dalam berbagai acara adat dan tradisi masyarakat."',
  ),
  SejarahModel(
    era: '1950 – 1990',
    tahun: '1950–1990',
    judul: 'Perkembangan\nSentra Batik',
    deskripsi:
        'Setelah kemerdekaan, produksi Batik Tegalan berkembang melalui teknik batik cap dan batik tulis. Wilayah Bengle menjadi salah satu pusat perkembangan batik di Kabupaten Tegal.',
    stats: {
      'Sentra': 'Bengle',
      'Teknik': 'Cap & Tulis',
    },
  ),
  SejarahModel(
    era: '2009',
    tahun: '2009',
    judul: 'Pengakuan\nUNESCO',
    deskripsi:
        'Pengakuan batik Indonesia sebagai Warisan Budaya Tak Benda oleh UNESCO turut mendorong pelestarian Batik Tegalan sebagai bagian dari identitas budaya nasional.',
    motifChips: [
      'UNESCO',
      'Warisan Budaya',
    ],
  ),
  SejarahModel(
    era: 'SEKARANG · 2020s',
    tahun: 'Sekarang',
    judul: 'Warisan Hidup di\nEra Digital',
    deskripsi:
        'Batik Tegalan kini diakui sebagai warisan budaya tak benda. Generasi muda mengangkat kembali motif tradisional dengan pendekatan kontemporer — dari fashion hingga desain digital.',
    motifChips: [
      'Digital',
      'Fashion',
      'Pelestarian',
    ],
    isAktif: true,
  ),
];

// ==============================
// LABEL CONNECTOR TIMELINE
// ==============================

final List<String> connectorLabels = const [
  'pengaruh budaya Mataram',
  'akulturasi budaya pesisir',
  'perkembangan identitas lokal',
  'masa kolonial',
  'perkembangan sentra batik',
  'pengakuan UNESCO',
  'warisan budaya berlanjut',
];
