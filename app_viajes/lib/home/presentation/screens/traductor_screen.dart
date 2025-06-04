import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// Eliminamos: import 'package:flutter_dotenv/flutter_dotenv.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  // --- ¡AQUÍ ES DONDE PONES TU API KEY DIRECTAMENTE! ---
  // Reemplaza 'TU_CLAVE_DE_API_DE_GEMINI_AQUI' con tu clave real.
  static const String _geminiApiKey = 'AIzaSyB_mmfa4J2TdW4atYzqi8DjDJv4wOodTkU';
  // ---------------------------------------------------

  final _textController = TextEditingController();
  String _translatedText = '';
  String _selectedSourceLanguageName = 'Español';
  String _selectedTargetLanguageName = 'Inglés';
  bool _isLoading = false;

  final List<String> _commonPhrases = [
    '¿Cuánto cuesta?',
    '¿Dónde está el baño?',
    'No entiendo.',
    '¿Habla inglés?',
    'Ayuda, por favor.',
    'Buenos días.',
    'Buenas tardes.',
    'Buenas noches.',
    'Gracias.',
    'De nada.',
  ];

  final Map<String, String> _languageCodes = {
    'Español': 'es',
    'Inglés': 'en',
    'Francés': 'fr',
    'Alemán': 'de',
    'Italiano': 'it',
    // Agrega más idiomas según sea necesario
  };

  String _getCodeFromName(String name) {
    return _languageCodes[name] ?? 'es';
  }

  Future<void> _translateText(
    String text,
    String sourceLanguageCode,
    String targetLanguageCode,
  ) async {
    setState(() {
      _isLoading = true;
      _translatedText = 'Traduciendo...';
    });

    // Ahora usamos la clave de API directamente desde la constante
    if (_geminiApiKey.isEmpty) {
      setState(() {
        _translatedText = 'La clave de API de Gemini no ha sido configurada.';
        _isLoading = false;
      });
      return;
    }

    try {
      final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _geminiApiKey);
      final content = [
        Content.text(
          'Traduce la siguiente frase de "$sourceLanguageCode" a "$targetLanguageCode": "$text"',
        ),
      ];
      final response = await model.generateContent(content);
      setState(() {
        _translatedText = response.text ?? 'Error al traducir.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _translatedText = 'Error al comunicarse con Gemini: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Traductor Gemini para Viajeros')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: _selectedSourceLanguageName,
                  hint: const Text('Idioma Origen'),
                  items:
                      _languageCodes.keys.map((String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text(key),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        _selectedSourceLanguageName = newValue;
                      }
                    });
                  },
                ),
                const Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: _selectedTargetLanguageName,
                  hint: const Text('Idioma Destino'),
                  items:
                      _languageCodes.keys.map((String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text(key),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        _selectedTargetLanguageName = newValue;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Ingresa la frase a traducir',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  _isLoading
                      ? null
                      : () {
                        final textToTranslate = _textController.text.trim();
                        if (textToTranslate.isNotEmpty) {
                          _translateText(
                            textToTranslate,
                            _selectedSourceLanguageName,
                            _selectedTargetLanguageName,
                          );
                        }
                      },
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Traducir'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Traducción:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_translatedText),
            const SizedBox(height: 20),
            const Text(
              'Frases Comunes para Viajar:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children:
                  _commonPhrases.map((phrase) {
                    return ElevatedButton(
                      onPressed: () {
                        _textController.text = phrase;
                        _translateText(
                          phrase,
                          _selectedSourceLanguageName,
                          _selectedTargetLanguageName,
                        );
                      },
                      child: Text(phrase),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
