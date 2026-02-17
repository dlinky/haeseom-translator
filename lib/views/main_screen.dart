import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/translation_controller.dart';
import '../models/language.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TranslationController>();
    
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('해섬 번역기'),
        backgroundColor: Colors.blue.shade100,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('프롬프트 수정'),
                        onTap: () {
                          Get.back();
                          Get.toNamed('/prompt-edit');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.key),
                        title: const Text('API 키 설정'),
                        onTap: () {
                          Get.back();
                          Get.toNamed('/api-key');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 언어 선택 섹션
            _buildLanguageSelection(controller),
            const SizedBox(height: 16),
            
            // 입력 영역
            _buildInputCard(controller),
            const SizedBox(height: 16),
            
            // 번역 버튼
            _buildTranslateButton(controller),
            const SizedBox(height: 16),
            
            // 출력 영역
            _buildOutputCard(controller),
            const SizedBox(height: 16),
            
            // 에러 메시지
            Obx(() => controller.errorMessage.value.isNotEmpty
                ? _buildErrorMessage(controller.errorMessage.value)
                : const SizedBox.shrink()),
            const SizedBox(height: 16),
            
            // 액션 버튼
            _buildActionButtons(controller),
          ],
        ),
      ),
        ),
    );
  }
  
  Widget _buildLanguageSelection(TranslationController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '입력 언어',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => Row(
                    children: Language.values.map((lang) {
                      return Expanded(
                        child: RadioListTile<Language>(
                          title: Text(lang.shortName),
                          value: lang,
                          groupValue: controller.inputLanguage.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.setInputLanguage(value);
                            }
                          },
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      );
                    }).toList(),
                  )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  '출력 언어',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => Row(
                    children: Language.values.map((lang) {
                      return Expanded(
                        child: CheckboxListTile(
                          title: Text(lang.shortName),
                          value: controller.outputLanguages.contains(lang),
                          onChanged: (value) {
                            controller.toggleOutputLanguage(lang);
                          },
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        ),
                      );
                    }).toList(),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInputCard(TranslationController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '번역할 내용',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: '번역할 내용을 입력하세요...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.setInputText(value),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTranslateButton(TranslationController controller) {
    return Builder(
      builder: (context) => Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : () => controller.translate(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                '번역하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      )),
    );
  }
  
  Widget _buildOutputCard(TranslationController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '번역 결과',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() => TextField(
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: '번역 결과가 여기에 표시됩니다...',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: controller.outputText.value)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.outputText.value.length),
                ),
              onChanged: (value) => controller.setOutputText(value),
            )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildErrorMessage(String message) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButtons(TranslationController controller) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => controller.copyToClipboard(),
            icon: const Icon(Icons.copy),
            label: const Text('복사'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed('/prompt-edit'),
            icon: const Icon(Icons.settings),
            label: const Text('프롬프트 수정'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
