import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../controllers/translation_controller.dart';

class PromptEditScreen extends StatefulWidget {
  const PromptEditScreen({super.key});

  @override
  State<PromptEditScreen> createState() => _PromptEditScreenState();
}

class _PromptEditScreenState extends State<PromptEditScreen> {
  final StorageService _storageService = StorageService();
  late final TextEditingController _promptController;
  
  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController(
      text: _storageService.getSystemPrompt(),
    );
  }
  
  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
  
  void _savePrompt() {
    _storageService.saveSystemPrompt(_promptController.text);
    Get.find<TranslationController>().updateSystemPrompt();
    Get.snackbar(
      '저장 완료',
      '시스템 프롬프트가 저장되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    Get.back();
  }
  
  void _resetToDefault() {
    final defaultPrompt = _storageService.getDefaultSystemPrompt();
    _storageService.saveSystemPrompt(defaultPrompt);
    _promptController.text = defaultPrompt;
    Get.snackbar(
      '초기화 완료',
      '기본 프롬프트로 초기화되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('시스템 프롬프트 수정'),
        backgroundColor: Colors.blue.shade100,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '시스템 프롬프트',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '번역 동작을 제어하는 시스템 프롬프트를 수정할 수 있습니다.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _promptController,
                      maxLines: 15,
                      decoration: const InputDecoration(
                        hintText: '시스템 프롬프트를 입력하세요...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetToDefault,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('기본값으로 초기화'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _savePrompt,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
