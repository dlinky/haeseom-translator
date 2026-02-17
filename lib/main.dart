import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/translation_controller.dart';
import 'services/storage_service.dart';
import 'views/main_screen.dart';
import 'views/prompt_edit_screen.dart';
import 'views/api_key_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

String _getInitialRoute() {
  final storageService = StorageService();
  if (!storageService.hasApiKey()) {
    return '/api-key';
  }
  return '/';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '해섬 번역기',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: _getInitialRoute(),
      getPages: [
        GetPage(name: '/', page: () => const MainScreen()),
        GetPage(name: '/prompt-edit', page: () => const PromptEditScreen()),
        GetPage(name: '/api-key', page: () => const ApiKeyScreen()),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(TranslationController());
      }),
    );
  }
}
