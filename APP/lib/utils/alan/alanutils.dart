// alan_voice_utils.dart
import 'package:alan_voice/alan_voice.dart';

class AlanVoiceUtils {
  // Method to play a given text using Alan Voice
  static void playText(String text) {
    AlanVoice.activate(); // Activate Alan Voice
    AlanVoice.playText(text); // Play the given text
  }
}
