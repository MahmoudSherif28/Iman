/// Mushaf page mapping data for the 604-page Madani Mushaf
/// This contains the page ranges for each Surah and major divisions
class MushafPageMapping {
  // Total pages in Madani Mushaf
  static const int totalPages = 604;

  // Juz boundaries (which page each Juz starts on)
  static const Map<int, int> juzStartPages = {
    1: 1,    // Juz 1 starts at page 1
    2: 22,   // Juz 2 starts at page 22
    3: 42,   // Juz 3 starts at page 42
    4: 62,   // Juz 4 starts at page 62
    5: 82,   // Juz 5 starts at page 82
    6: 102,  // Juz 6 starts at page 102
    7: 121,  // Juz 7 starts at page 121
    8: 142,  // Juz 8 starts at page 142
    9: 162,  // Juz 9 starts at page 162
    10: 182, // Juz 10 starts at page 182
    11: 201, // Juz 11 starts at page 201
    12: 222, // Juz 12 starts at page 222
    13: 242, // Juz 13 starts at page 242
    14: 262, // Juz 14 starts at page 262
    15: 282, // Juz 15 starts at page 282
    16: 302, // Juz 16 starts at page 302
    17: 322, // Juz 17 starts at page 322
    18: 342, // Juz 18 starts at page 342
    19: 362, // Juz 19 starts at page 362
    20: 382, // Juz 20 starts at page 382
    21: 402, // Juz 21 starts at page 402
    22: 422, // Juz 22 starts at page 422
    23: 442, // Juz 23 starts at page 442
    24: 462, // Juz 24 starts at page 462
    25: 482, // Juz 25 starts at page 482
    26: 502, // Juz 26 starts at page 502
    27: 522, // Juz 27 starts at page 522
    28: 542, // Juz 28 starts at page 542
    29: 562, // Juz 29 starts at page 562
    30: 582, // Juz 30 starts at page 582
  };

  // Surah start pages (which page each Surah starts on)
  static const Map<int, int> surahStartPages = {
    1: 1,     // Al-Fatihah
    2: 2,     // Al-Baqarah
    3: 50,    // Ali 'Imran
    4: 77,    // An-Nisa
    5: 106,   // Al-Ma'idah
    6: 128,   // Al-An'am
    7: 151,   // Al-A'raf
    8: 177,   // Al-Anfal
    9: 187,   // At-Tawbah
    10: 208,  // Yunus
    11: 221,  // Hud
    12: 235,  // Yusuf
    13: 249,  // Ar-Ra'd
    14: 255,  // Ibrahim
    15: 262,  // Al-Hijr
    16: 267,  // An-Nahl
    17: 282,  // Al-Isra
    18: 293,  // Al-Kahf
    19: 305,  // Maryam
    20: 312,  // Ta-Ha
    21: 322,  // Al-Anbya
    22: 332,  // Al-Hajj
    23: 342,  // Al-Mu'minun
    24: 350,  // An-Nur
    25: 359,  // Al-Furqan
    26: 367,  // Ash-Shu'ara
    27: 377,  // An-Naml
    28: 385,  // Al-Qasas
    29: 396,  // Al-'Ankabut
    30: 404,  // Ar-Rum
    31: 411,  // Luqman
    32: 415,  // As-Sajdah
    33: 418,  // Al-Ahzab
    34: 428,  // Saba
    35: 434,  // Fatir
    36: 440,  // Ya-Sin
    37: 446,  // As-Saffat
    38: 453,  // Sad
    39: 458,  // Az-Zumar
    40: 467,  // Ghafir
    41: 477,  // Fussilat
    42: 483,  // Ash-Shuraa
    43: 489,  // Az-Zukhruf
    44: 496,  // Ad-Dukhan
    45: 499,  // Al-Jathiyah
    46: 502,  // Al-Ahqaf
    47: 507,  // Muhammad
    48: 511,  // Al-Fath
    49: 515,  // Al-Hujurat
    50: 518,  // Qaf
    51: 520,  // Adh-Dhariyat
    52: 523,  // At-Tur
    53: 526,  // An-Najm
    54: 528,  // Al-Qamar
    55: 531,  // Ar-Rahman
    56: 534,  // Al-Waqi'ah
    57: 537,  // Al-Hadid
    58: 542,  // Al-Mujadila
    59: 545,  // Al-Hashr
    60: 549,  // Al-Mumtahanah
    61: 551,  // As-Saff
    62: 553,  // Al-Jumu'ah
    63: 554,  // Al-Munafiqun
    64: 556,  // At-Taghabun
    65: 558,  // At-Talaq
    66: 560,  // At-Tahrim
    67: 562,  // Al-Mulk
    68: 564,  // Al-Qalam
    69: 566,  // Al-Haqqah
    70: 568,  // Al-Ma'arij
    71: 570,  // Nuh
    72: 572,  // Al-Jinn
    73: 574,  // Al-Muzzammil
    74: 575,  // Al-Muddaththir
    75: 577,  // Al-Qiyamah
    76: 578,  // Al-Insan
    77: 580,  // Al-Mursalat
    78: 582,  // An-Naba
    79: 583,  // An-Nazi'at
    80: 585,  // 'Abasa
    81: 586,  // At-Takwir
    82: 587,  // Al-Infitar
    83: 587,  // Al-Mutaffifin
    84: 589,  // Al-Inshiqaq
    85: 590,  // Al-Buruj
    86: 591,  // At-Tariq
    87: 591,  // Al-A'la
    88: 592,  // Al-Ghashiyah
    89: 593,  // Al-Fajr
    90: 594,  // Al-Balad
    91: 595,  // Ash-Shams
    92: 595,  // Al-Layl
    93: 596,  // Ad-Dhuha
    94: 596,  // Ash-Sharh
    95: 597,  // At-Tin
    96: 597,  // Al-'Alaq
    97: 598,  // Al-Qadr
    98: 598,  // Al-Bayyinah
    99: 599,  // Az-Zalzalah
    100: 599, // Al-'Adiyat
    101: 600, // Al-Qari'ah
    102: 600, // At-Takathur
    103: 601, // Al-'Asr
    104: 601, // Al-Humazah
    105: 601, // Al-Fil
    106: 602, // Quraysh
    107: 602, // Al-Ma'un
    108: 602, // Al-Kawthar
    109: 603, // Al-Kafirun
    110: 603, // An-Nasr
    111: 603, // Al-Masad
    112: 604, // Al-Ikhlas
    113: 604, // Al-Falaq
    114: 604, // An-Nas
  };

  /// Get the Juz number for a given page
  static int getJuzForPage(int pageNumber) {
    for (int juz = 30; juz >= 1; juz--) {
      if (pageNumber >= juzStartPages[juz]!) {
        return juz;
      }
    }
    return 1;
  }

  /// Get the Hizb number for a given page (approximate, 2 hizbs per juz)
  static int getHizbForPage(int pageNumber) {
    int juz = getJuzForPage(pageNumber);
    int juzStartPage = juzStartPages[juz]!;
    int juzEndPage = juz < 30 ? juzStartPages[juz + 1]! - 1 : totalPages;
    int pagesPerJuz = juzEndPage - juzStartPage + 1;
    int pagesPerHizb = pagesPerJuz ~/ 4; // 4 hizbs per juz (each hizb is 1/4 juz)
    
    int pageInJuz = pageNumber - juzStartPage;
    int hizbInJuz = pageInJuz ~/ pagesPerHizb;
    
    return ((juz - 1) * 4) + hizbInJuz + 1;
  }

  /// Get the starting page for a Surah
  static int? getPageForSurah(int surahId) {
    return surahStartPages[surahId];
  }

  /// Get the Surah ID for a given page
  static int getSurahForPage(int pageNumber) {
    for (int surah = 114; surah >= 1; surah--) {
      if (pageNumber >= surahStartPages[surah]!) {
        return surah;
      }
    }
    return 1;
  }

  /// Check if a page is the start of a new Juz
  static bool isJuzStart(int pageNumber) {
    return juzStartPages.values.contains(pageNumber);
  }

  /// Check if a page is the start of a new Surah
  static bool isSurahStart(int pageNumber) {
    return surahStartPages.values.contains(pageNumber);
  }
}
