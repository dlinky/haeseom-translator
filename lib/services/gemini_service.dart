import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/language.dart' as app_models;
import '../utils/constants.dart';
import 'storage_service.dart';

class GeminiService {
  final StorageService _storageService = StorageService();
  GenerativeModel? _model;
  String _currentModel = AppConstants.defaultGeminiModel;
  
  GeminiService() {
    _initializeModel();
  }
  
  void _initializeModel() {
    final apiKey = _storageService.getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      _model = null;
      return;
    }
    
    // 저장된 모델이 있으면 사용, 없으면 기본값 사용
    final savedModel = _storageService.getModel();
    _currentModel = savedModel ?? AppConstants.defaultGeminiModel;
    
    _model = GenerativeModel(
      model: _currentModel,
      apiKey: apiKey,
    );
  }
  
  // 모델 변경 및 재시도 로직
  Future<void> _tryWithFallbackModels(String apiKey) async {
    final models = AppConstants.availableModels;
    
    for (final modelName in models) {
      try {
        _currentModel = modelName;
        _model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
        );
        // 모델이 성공적으로 생성되면 저장
        _storageService.saveModel(modelName);
        return;
      } catch (e) {
        // 다음 모델 시도
        continue;
      }
    }
    
    throw Exception('사용 가능한 모델을 찾을 수 없습니다. API 키를 확인해주세요.');
  }
  
  Future<String> translate({
    required String text,
    required app_models.Language inputLanguage,
    required List<app_models.Language> outputLanguages,
  }) async {
    if (_model == null) {
      throw Exception('API 키가 설정되지 않았습니다. 설정 화면에서 API 키를 입력해주세요.');
    }
    
    if (text.trim().isEmpty) {
      throw Exception('번역할 텍스트가 비어있습니다.');
    }
    
    if (outputLanguages.isEmpty) {
      throw Exception('출력 언어를 최소 하나 선택해주세요.');
    }
    
    // 프롬프트 구성
    final prompt = _buildPrompt(text, inputLanguage, outputLanguages);
    
    try {
      final response = await _model!.generateContent([
        Content.text(prompt),
      ]);
      
      final translatedText = response.text;
      if (translatedText == null || translatedText.isEmpty) {
        throw Exception('번역 결과를 받아오지 못했습니다.');
      }
      
      return translatedText;
    } catch (e) {
      // 모델 오류인 경우 다른 모델로 재시도
      if (e.toString().contains('model') || e.toString().contains('not found')) {
        final apiKey = _storageService.getApiKey();
        if (apiKey != null) {
          try {
            await _tryWithFallbackModels(apiKey);
            // 재시도
            final response = await _model!.generateContent([
              Content.text(prompt),
            ]);
            final translatedText = response.text;
            if (translatedText == null || translatedText.isEmpty) {
              throw Exception('번역 결과를 받아오지 못했습니다.');
            }
            return translatedText;
          } catch (retryError) {
            throw Exception('모델 오류: 사용 가능한 모델을 찾을 수 없습니다. ${retryError.toString()}');
          }
        }
      }
      throw Exception('번역 중 오류가 발생했습니다: ${e.toString()}');
    }
  }
  
  String _buildPrompt(String text, app_models.Language inputLanguage, List<app_models.Language> outputLanguages) {
    final systemPrompt = _storageService.getSystemPrompt();
    final inputLangName = inputLanguage.displayName;
    final outputLangNames = outputLanguages.map<String>((lang) => lang.displayName).join(', ');
    
    String translationInstruction;
    if (outputLanguages.length == 1) {
      translationInstruction = '''다음 ${inputLangName} 텍스트를 ${outputLangNames}로 번역해주세요. 번역 결과만 출력하세요.

텍스트:
$text''';
    } else {
      // 여러 언어일 때: 한국어, 영어, 텔루구어 순서로 번역하고 각각 줄바꿈으로 구분
      final langOrder = ['한국어', 'English', 'తెలుగు'];
      final langList = outputLanguages.map<String>((lang) => lang.displayName).toList();
      translationInstruction = '''다음 ${inputLangName} 텍스트를 ${outputLangNames}로 번역해주세요. 
번역 결과는 각 언어별로 줄바꿈으로 구분하여 출력하세요. 언어명이나 접두사 없이 번역 결과만 출력하세요.
출력 순서는 한국어, 영어, 텔루구어 순서로 해주세요.

텍스트:
$text''';
    }
    
    // 시스템 프롬프트를 프롬프트 앞에 포함
    return '''$systemPrompt

$translationInstruction''';
  }
  
  // 시스템 프롬프트 업데이트 시 모델 재생성
  void updateSystemPrompt() {
    _initializeModel();
  }
  
  // API 키 업데이트 시 모델 재생성
  void updateApiKey() {
    _initializeModel();
  }
}