enum AudioEncoding {
  linear16('LINEAR16'),
  flac('FLAC'),
  mp3('MP3'),
  oggOpus('OGG_OPUS'),
  webmOpus('WEBM_OPUS');

  final String value;
  const AudioEncoding(this.value);
}
