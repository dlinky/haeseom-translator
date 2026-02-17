enum Language {
  korean('한국어', 'ko', 'KOR'),
  english('English', 'en', 'ENG'),
  telugu('తెలుగు', 'te', 'TEL');

  final String displayName;
  final String code;
  final String shortName;

  const Language(this.displayName, this.code, this.shortName);
  
  // 정렬 순서: 한국어, 영어, 텔루구어
  static List<Language> get sortedOrder => [
    Language.korean,
    Language.english,
    Language.telugu,
  ];
}
