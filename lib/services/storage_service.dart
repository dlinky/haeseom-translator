import 'package:get_storage/get_storage.dart';
import '../models/language.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();
  
  // Keys
  static const String _keySystemPrompt = 'system_prompt';
  static const String _keyInputLanguage = 'input_language';
  static const String _keyOutputLanguages = 'output_languages';
  static const String _keyApiKey = 'gemini_api_key';
  static const String _keyModel = 'gemini_model';
  
  // System Prompt
  String getSystemPrompt() {
    return _storage.read(_keySystemPrompt) ?? _getDefaultSystemPrompt();
  }
  
  void saveSystemPrompt(String prompt) {
    _storage.write(_keySystemPrompt, prompt);
  }
  
  String getDefaultSystemPrompt() {
    return '''You are a student manager communicating with Indian Christian students.
Your role is to translate text naturally and conversationally, specifically tailored for Indian Telugu-speaking Christians.

# STYLE GUIDELINES:
1. Tone: Respectful, friendly, and approachable. Maintain a "neutral-polite" tone that works for both young adults and elders.
2. Universal Phrasing: Use "Brother" or "Sister" as the standard greeting. In Telugu, use respectful verb endings (e.g., -andi, -aru) to ensure the tone is polite regardless of the student's age.
3. Natural Mix: Use a mix of English loanwords (e.g., 'Join', 'Class', 'Link', 'Message') which is the standard "modern conversational" style in India.
4. Conciseness: Keep sentences brief and clear. Focus on the core message without unnecessary formal flourishes.

# IMPORTANT RULES:
1. Output Only: NEVER include explanatory phrases like "Here is the translation" or "Translation:". ONLY output the translated text itself.
2. Formatting: When multiple target languages are requested, output each translation separated by a line break. DO NOT use [Language Name] prefixes or any language labels. Just output the translations in order: Korean, English, Telugu (if selected), each on a new line.

Example format for multiple languages:
Brother, it's time to join the class.

బ్రదర్, క్లాస్ జాయిన్ అవ్వడానికి ఇది సమయం.''';
  }
  
  String _getDefaultSystemPrompt() {
    return getDefaultSystemPrompt();
  }
  
  // Input Language
  Language? getInputLanguage() {
    final code = _storage.read(_keyInputLanguage);
    if (code == null) return null;
    return Language.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => Language.korean,
    );
  }
  
  void saveInputLanguage(Language language) {
    _storage.write(_keyInputLanguage, language.code);
  }
  
  // Output Languages
  List<Language> getOutputLanguages() {
    final codes = _storage.read<List<dynamic>>(_keyOutputLanguages);
    if (codes == null || codes.isEmpty) {
      return [Language.english]; // Default
    }
    return codes
        .map((code) => Language.values.firstWhere(
              (lang) => lang.code == code,
              orElse: () => Language.english,
            ))
        .toList();
  }
  
  void saveOutputLanguages(List<Language> languages) {
    _storage.write(_keyOutputLanguages, languages.map((lang) => lang.code).toList());
  }
  
  // API Key
  String? getApiKey() {
    return _storage.read(_keyApiKey);
  }
  
  void saveApiKey(String apiKey) {
    _storage.write(_keyApiKey, apiKey);
  }
  
  bool hasApiKey() {
    final key = getApiKey();
    return key != null && key.isNotEmpty;
  }
  
  // Model
  String? getModel() {
    return _storage.read(_keyModel);
  }
  
  void saveModel(String model) {
    _storage.write(_keyModel, model);
  }
}
