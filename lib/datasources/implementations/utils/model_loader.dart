import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> copyAssetSmart(String assetPath) async {
  final directory = await getApplicationSupportDirectory();
  final targetPath = join(directory.path, assetPath);

  if (!assetPath.endsWith('/') && !assetPath.contains('espeak-ng-data')) {
    final targetFile = File(targetPath);
    if (await targetFile.exists()) return targetPath;
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    await targetFile.create(recursive: true);
    await targetFile.writeAsBytes(bytes);
    return targetPath;
  }

  final targetDir = Directory(targetPath);
  if (await targetDir.exists()) {
    final lista = await targetDir.list().toList();
    if (lista.isNotEmpty) return targetPath;
  }

  final AssetManifest manifest =
      await AssetManifest.loadFromAssetBundle(rootBundle);
  final files = manifest
      .listAssets()
      .where((key) => key.startsWith(assetPath))
      .toList();

  for (String fileAsset in files) {
    final data = await rootBundle.load(fileAsset);
    final bytes = data.buffer.asUint8List();
    final fileTarget = File(join(directory.path, fileAsset));
    await fileTarget.create(recursive: true);
    await fileTarget.writeAsBytes(bytes);
  }
  return targetPath;
}

Future<String> extractEspeakData(String tarAssetPath) async {
  final directory = await getApplicationSupportDirectory();
  
  final espeakDir = Directory(
    join(directory.path, 
    'assets/models/tts/kokoro/kokoro-multi-lang-v1_0/espeak-ng-data'),
  );

  if (await espeakDir.exists()) {
    final lista = await espeakDir.list().toList();
    if (lista.isNotEmpty) return espeakDir.path;
  }

  final tarFile = File(join(directory.path, tarAssetPath));
  if (!await tarFile.exists()) {
    final data = await rootBundle.load(tarAssetPath);
    final bytes = data.buffer.asUint8List();
    await tarFile.create(recursive: true);
    await tarFile.writeAsBytes(bytes);
  }

  final extractDir = Directory(
    join(directory.path,
    'assets/models/tts/kokoro/kokoro-multi-lang-v1_0'),
  );
  await extractDir.create(recursive: true);

  final result = await Process.run(
    'tar',
    ['xzf', tarFile.path, '-C', extractDir.path],
  );

  if (result.exitCode != 0) {
    throw Exception('Error extrayendo espeak-ng-data: ${result.stderr}');
  }

  await tarFile.delete();

  return espeakDir.path;
}


// final modelPath = await copyAssetSmart(
//   Assets.models.tts.kokoro.kokoroMultiLangV10.model,
// );
// final tokensPAth = await copyAssetSmart(
//   Assets.models.tts.kokoro.kokoroMultiLangV10.tokens,
// );
// final voicesPath = await copyAssetSmart(
//   Assets.models.tts.kokoro.kokoroMultiLangV10.voices,
// );

// final espeakPath = await extractEspeakData(
//   'assets/models/tts/kokoro/kokoro-multi-lang-v1_0/espeak-ng-data.tar.gz',
// );

// final config = sherpa_onnx.OfflineTtsModelConfig(
//   kokoro: sherpa_onnx.OfflineTtsKokoroModelConfig(
//     model: modelPath,
//     voices: voicesPath,
//     tokens: tokensPAth,
//     dataDir: espeakPath,
//         lang: 'en-us',
//   ),
// );
// final ttsConfig = sherpa_onnx.OfflineTtsConfig(
//   model: config,
// );

// final tts = sherpa_onnx.OfflineTts(ttsConfig);

//   final genConfig = sherpa_onnx.OfflineTtsGenerationConfig(
//     sid: 0,
//     speed: 1.0,
//     silenceScale: 0.2,
//   );
//   print("Generando audio con TTS...");
//   final String text = "The Amazon rainforest, frequently known as the lungs of the Earth, stretches across more than 5.5 million square kilometers through nine South American countries, with Brazil hosting the largest portion of its territory.";
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