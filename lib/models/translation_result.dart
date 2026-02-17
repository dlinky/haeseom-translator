import 'language.dart';

class TranslationResult {
  final Language language;
  final String text;

  TranslationResult({
    required this.language,
    required this.text,
  });

  String get formattedOutput {
    return '[${language.displayName}]\n$text';
  }
}
