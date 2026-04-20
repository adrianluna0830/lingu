import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> copyAssetSmart(String assetPath) async {
  final directory = await getApplicationSupportDirectory();
  final targetPath = join(directory.path, assetPath);

  if (!assetPath.endsWith('/') && !assetPath.contains('espeak-ng-data')) {
    final targetFile = File(targetPath);
    
    if (await targetFile.exists()) {
      return targetPath;
    }

    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    await targetFile.create(recursive: true);
    await targetFile.writeAsBytes(bytes);
    return targetPath;
  }

  final targetDir = Directory(targetPath);
  if (await targetDir.exists()) {
    final listaArchivos = await targetDir.list().toList();
    if (listaArchivos.isNotEmpty) {
      return targetPath;
    }
  }

  final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    
  final espeakFiles = manifest.listAssets()
      .where((String key) => key.startsWith(assetPath))
      .toList();

  for (String fileAsset in espeakFiles) {
    final data = await rootBundle.load(fileAsset);
    final bytes = data.buffer.asUint8List();
    final fileTarget = File(join(directory.path, fileAsset));
    await fileTarget.create(recursive: true);
    await fileTarget.writeAsBytes(bytes);
  }

  return targetPath;
}


//   final modelPath = await copyAssetSmart(Assets.models.tts.spanish.esMXClaudeHigh);
//   final tokensPAth = await copyAssetSmart(Assets.models.tts.spanish.tokens);
// final espeakPath = await copyAssetSmart('assets/models/tts/english/espeak-ng-data');
// final config = sherpa_onnx.OfflineTtsModelConfig(
//   vits: sherpa_onnx.OfflineTtsVitsModelConfig(
//     model: modelPath,
//     tokens: tokensPAth,
//     dataDir: espeakPath,
//   ),
// );

// final ttsConfig = sherpa_onnx.OfflineTtsConfig(
//   model: config,
// );

// final tts = sherpa_onnx.OfflineTts(ttsConfig);

//   final genConfig = sherpa_onnx.OfflineTtsGenerationConfig(
//     sid: 0, // Speaker ID (0 para modelos de una sola voz)
//     speed: 1.0, // Velocidad (0.5 a 3.0)
//     silenceScale: 0.2, // Silencio entre frases
//   );
//   print("Generando audio con TTS...");
//   final text = "La selva amazónica, conocida frecuentemente como los pulmones de la Tierra, se extiende por más de 5.5 millones de kilómetros cuadrados a lo largo de nueve países sudamericanos, siendo Brasil el que alberga la mayor parte de su territorio. Es hogar de aproximadamente el 10% de todas las especies del planeta, incluyendo más de 40,000 especies de plantas, 1,300 especies de aves y 3,000 tipos de peces. A pesar de su papel fundamental en la regulación del clima global mediante la absorción de enormes cantidades de dióxido de carbono, la Amazonía enfrenta graves amenazas derivadas de la deforestación, la minería ilegal y la expansión agrícola. Los científicos advierten que si los niveles actuales de destrucción continúan, el bosque podría alcanzar un punto de no retorno en las próximas décadas, transformando vastas extensiones de exuberante selva en sabana seca, un cambio que tendría consecuencias catastróficas no solo para América del Sur, sino para el mundo entero.";

//   final audio = tts.generateWithConfig(text: text, config: genConfig);

//   final tempDir = await getTemporaryDirectory();
//   final filePath = '${tempDir.path}/tts_output.wav';
//   print("Archivo temporal para TTS: $filePath");
//   final ok = sherpa_onnx.writeWave(
//     filename: filePath,
//     samples: audio.samples,
//     sampleRate: audio.sampleRate,
//   );
//   print("Archivo WAV generado: $ok");
