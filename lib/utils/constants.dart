// 앱 전역 상수 정의
class AppConstants {
  // API 관련 - v1beta API를 사용하여 generateContent를 지원하는 모델 목록 (우선순위 순서)
  // gemini-1.5-flash: v1beta에서 generateContent 지원 ✅ (빠르고 높은 요청 제한)
  // gemini-1.5-pro: v1beta에서 generateContent 지원 ✅ (더 강력한 성능)
  // gemini-pro: 기본 모델, generateContent 지원 ✅ (폴백용)
  static const List<String> availableModels = [
    'gemini-2.5-flash',     // 권장: v1beta에서 generateContent 지원, 빠르고 높은 제한
    'gemini-2.5-pro',       // 대안: v1beta에서 generateContent 지원, 더 강력한 성능
    'gemini-pro',           // 폴백: 기본 모델, 안정적
  ];
  static const String defaultGeminiModel = 'gemini-2.5-flash';
  // 참고: 최신 google_generative_ai 패키지(0.4.0+)는 자동으로 v1beta API를 지원합니다
  
  // Storage Keys
  static const String storageKeySystemPrompt = 'system_prompt';
  static const String storageKeyInputLanguage = 'input_language';
  static const String storageKeyOutputLanguages = 'output_languages';
  
  // UI 관련
  static const double defaultPadding = 16.0;
  static const double cardElevation = 2.0;
}
