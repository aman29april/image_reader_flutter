import 'package:translator/translator.dart';

Future<String> translate(
  text, {
  String from,
  String to = 'hi',
}) async {
  final translator = new GoogleTranslator();
  String str = await translator.translate(text, to: to);
  return str;
}
