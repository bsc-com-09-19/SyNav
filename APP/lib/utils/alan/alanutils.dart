// alan_voice_utils.dart
import 'package:alan_voice/alan_voice.dart';
class AlanVoiceUtils {
  static void playText(String text) {
    AlanVoice.activate();
    AlanVoice.playText(text);
    
  }
}
