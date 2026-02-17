import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/language.dart';
import '../models/translation_result.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';

class TranslationController extends GetxController {
  final GeminiService _geminiService = GeminiService();
  final StorageService _storageService = StorageService();
  
  // 상태 변수
  final Rx<Language> inputLanguage = Language.korean.obs;
  final RxList<Language> outputLanguages = <Language>[Language.english].obs;
  final RxString inputText = ''.obs;
  final RxString outputText = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadSavedSettings();
  }
  
  void _loadSavedSettings() {
    final savedInputLang = _storageService.getInputLanguage();
    if (savedInputLang != null) {
      inputLanguage.value = savedInputLang;
    }
    
    final savedOutputLangs = _storageService.getOutputLanguages();
    if (savedOutputLangs.isNotEmpty) {
      outputLanguages.value = savedOutputLangs;
    }
  }
  
  void setInputLanguage(Language language) {
    inputLanguage.value = language;
    _storageService.saveInputLanguage(language);
  }
  
  void toggleOutputLanguage(Language language) {
    if (outputLanguages.contains(language)) {
      if (outputLanguages.length > 1) {
        outputLanguages.remove(language);
      }
    } else {
      outputLanguages.add(language);
    }
    _storageService.saveOutputLanguages(outputLanguages);
  }
  
  void setInputText(String text) {
    inputText.value = text;
  }
  
  Future<void> translate(BuildContext? context) async {
    // 키보드 내리기
    if (context != null) {
      FocusScope.of(context).unfocus();
    }
    
    if (inputText.value.trim().isEmpty) {
      errorMessage.value = '번역할 텍스트를 입력해주세요.';
      return;
    }
    
    if (outputLanguages.isEmpty) {
      errorMessage.value = '최소 하나의 출력 언어를 선택해주세요.';
      return;
    }
    
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // 출력 언어를 항상 한국어, 영어, 텔루구어 순서로 정렬
      final sortedOutputLanguages = Language.sortedOrder
          .where((lang) => outputLanguages.contains(lang))
          .toList();
      
      final result = await _geminiService.translate(
        text: inputText.value,
        inputLanguage: inputLanguage.value,
        outputLanguages: sortedOutputLanguages,
      );
      
      outputText.value = result;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      outputText.value = '';
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> copyToClipboard() async {
    if (outputText.value.isEmpty) {
      return;
    }
    
    await Clipboard.setData(ClipboardData(text: outputText.value));
    Get.snackbar(
      '복사 완료',
      '번역 결과가 클립보드에 복사되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  void setOutputText(String text) {
    outputText.value = text;
  }
  
  void updateSystemPrompt() {
    _geminiService.updateSystemPrompt();
  }
  
  void updateApiKey() {
    _geminiService.updateApiKey();
  }
}
