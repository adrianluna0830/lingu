// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class TopicAdapter extends TypeAdapter<Topic> {
  @override
  final typeId = 0;

  @override
  Topic read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Topic(
      language: fields[0] as LanguageLocale,
      title: fields[1] as String,
      subtitle: fields[2] as String?,
      description: fields[3] as String?,
      level: fields[4] as CEFR?,
    );
  }

  @override
  void write(BinaryWriter writer, Topic obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.level);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopicDataAdapter extends TypeAdapter<TopicData> {
  @override
  final typeId = 1;

  @override
  TopicData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopicData(
      topic: fields[7] as Topic,
      order: (fields[1] as num).toInt(),
      scoresNormalized: fields[2] == null
          ? const []
          : (fields[2] as List).cast<double>(),
      status: fields[8] == null ? TopicStatus.normal : fields[8] as TopicStatus,
    );
  }

  @override
  void write(BinaryWriter writer, TopicData obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.order)
      ..writeByte(2)
      ..write(obj.scoresNormalized)
      ..writeByte(7)
      ..write(obj.topic)
      ..writeByte(8)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CEFRAdapter extends TypeAdapter<CEFR> {
  @override
  final typeId = 2;

  @override
  CEFR read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CEFR.a1;
      case 1:
        return CEFR.a2;
      case 2:
        return CEFR.b1;
      case 3:
        return CEFR.b2;
      case 4:
        return CEFR.c1;
      case 5:
        return CEFR.c2;
      default:
        return CEFR.a1;
    }
  }

  @override
  void write(BinaryWriter writer, CEFR obj) {
    switch (obj) {
      case CEFR.a1:
        writer.writeByte(0);
      case CEFR.a2:
        writer.writeByte(1);
      case CEFR.b1:
        writer.writeByte(2);
      case CEFR.b2:
        writer.writeByte(3);
      case CEFR.c1:
        writer.writeByte(4);
      case CEFR.c2:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CEFRAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LanguageLocaleAdapter extends TypeAdapter<LanguageLocale> {
  @override
  final typeId = 3;

  @override
  LanguageLocale read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LanguageLocale.en;
      case 1:
        return LanguageLocale.es;
      case 2:
        return LanguageLocale.de;
      default:
        return LanguageLocale.en;
    }
  }

  @override
  void write(BinaryWriter writer, LanguageLocale obj) {
    switch (obj) {
      case LanguageLocale.en:
        writer.writeByte(0);
      case LanguageLocale.es:
        writer.writeByte(1);
      case LanguageLocale.de:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageLocaleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopicStatusAdapter extends TypeAdapter<TopicStatus> {
  @override
  final typeId = 4;

  @override
  TopicStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TopicStatus.disabled;
      case 1:
        return TopicStatus.normal;
      case 2:
        return TopicStatus.mastered;
      case 3:
        return TopicStatus.prioritized;
      default:
        return TopicStatus.disabled;
    }
  }

  @override
  void write(BinaryWriter writer, TopicStatus obj) {
    switch (obj) {
      case TopicStatus.disabled:
        writer.writeByte(0);
      case TopicStatus.normal:
        writer.writeByte(1);
      case TopicStatus.mastered:
        writer.writeByte(2);
      case TopicStatus.prioritized:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartOfSpeechAdapter extends TypeAdapter<PartOfSpeech> {
  @override
  final typeId = 5;

  @override
  PartOfSpeech read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PartOfSpeech.noun;
      case 1:
        return PartOfSpeech.verb;
      case 2:
        return PartOfSpeech.adjective;
      case 3:
        return PartOfSpeech.adverb;
      case 4:
        return PartOfSpeech.pronoun;
      case 5:
        return PartOfSpeech.preposition;
      case 6:
        return PartOfSpeech.conjunction;
      case 7:
        return PartOfSpeech.interjection;
      default:
        return PartOfSpeech.noun;
    }
  }

  @override
  void write(BinaryWriter writer, PartOfSpeech obj) {
    switch (obj) {
      case PartOfSpeech.noun:
        writer.writeByte(0);
      case PartOfSpeech.verb:
        writer.writeByte(1);
      case PartOfSpeech.adjective:
        writer.writeByte(2);
      case PartOfSpeech.adverb:
        writer.writeByte(3);
      case PartOfSpeech.pronoun:
        writer.writeByte(4);
      case PartOfSpeech.preposition:
        writer.writeByte(5);
      case PartOfSpeech.conjunction:
        writer.writeByte(6);
      case PartOfSpeech.interjection:
        writer.writeByte(7);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartOfSpeechAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordExampleAdapter extends TypeAdapter<WordExample> {
  @override
  final typeId = 6;

  @override
  WordExample read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordExample(
      translation: fields[0] as String,
      example: fields[1] as String,
      exampleAudioPath: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordExample obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.translation)
      ..writeByte(1)
      ..write(obj.example)
      ..writeByte(2)
      ..write(obj.exampleAudioPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordExampleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GrammaticalGenderAdapter extends TypeAdapter<GrammaticalGender> {
  @override
  final typeId = 7;

  @override
  GrammaticalGender read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GrammaticalGender.masculine;
      case 1:
        return GrammaticalGender.feminine;
      case 2:
        return GrammaticalGender.neuter;
      default:
        return GrammaticalGender.masculine;
    }
  }

  @override
  void write(BinaryWriter writer, GrammaticalGender obj) {
    switch (obj) {
      case GrammaticalGender.masculine:
        writer.writeByte(0);
      case GrammaticalGender.feminine:
        writer.writeByte(1);
      case GrammaticalGender.neuter:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrammaticalGenderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EnglishWordDetailsAdapter extends TypeAdapter<EnglishWordDetails> {
  @override
  final typeId = 8;

  @override
  EnglishWordDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnglishWordDetails(isIrregular: fields[0] as bool?);
  }

  @override
  void write(BinaryWriter writer, EnglishWordDetails obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isIrregular);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnglishWordDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EnglishWordAdapter extends TypeAdapter<EnglishWord> {
  @override
  final typeId = 10;

  @override
  EnglishWord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnglishWord(
      word: fields[0] as String,
      meanings: (fields[1] as List).cast<WordMeaning>(),
    );
  }

  @override
  void write(BinaryWriter writer, EnglishWord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.meanings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnglishWordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GermanWordDetailsAdapter extends TypeAdapter<GermanWordDetails> {
  @override
  final typeId = 11;

  @override
  GermanWordDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GermanWordDetails(
      gender: fields[0] as GrammaticalGender?,
      pluralForm: fields[1] as String?,
      isSeparable: fields[2] as bool?,
      separablePrefix: fields[3] as String?,
      genitiveForm: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GermanWordDetails obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.gender)
      ..writeByte(1)
      ..write(obj.pluralForm)
      ..writeByte(2)
      ..write(obj.isSeparable)
      ..writeByte(3)
      ..write(obj.separablePrefix)
      ..writeByte(4)
      ..write(obj.genitiveForm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GermanWordDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GermanWordAdapter extends TypeAdapter<GermanWord> {
  @override
  final typeId = 13;

  @override
  GermanWord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GermanWord(
      word: fields[0] as String,
      meanings: (fields[1] as List).cast<WordMeaning>(),
    );
  }

  @override
  void write(BinaryWriter writer, GermanWord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.meanings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GermanWordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VerbConjugationTypeAdapter extends TypeAdapter<VerbConjugationType> {
  @override
  final typeId = 14;

  @override
  VerbConjugationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VerbConjugationType.regular;
      case 1:
        return VerbConjugationType.irregular;
      case 2:
        return VerbConjugationType.stemChanging;
      default:
        return VerbConjugationType.regular;
    }
  }

  @override
  void write(BinaryWriter writer, VerbConjugationType obj) {
    switch (obj) {
      case VerbConjugationType.regular:
        writer.writeByte(0);
      case VerbConjugationType.irregular:
        writer.writeByte(1);
      case VerbConjugationType.stemChanging:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerbConjugationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SpanishWordDetailsAdapter extends TypeAdapter<SpanishWordDetails> {
  @override
  final typeId = 15;

  @override
  SpanishWordDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpanishWordDetails(
      gender: fields[0] as GrammaticalGender?,
      pluralForm: fields[1] as String?,
      isReflexive: fields[2] as bool?,
      verbType: fields[3] as VerbConjugationType?,
    );
  }

  @override
  void write(BinaryWriter writer, SpanishWordDetails obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.gender)
      ..writeByte(1)
      ..write(obj.pluralForm)
      ..writeByte(2)
      ..write(obj.isReflexive)
      ..writeByte(3)
      ..write(obj.verbType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpanishWordDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordMeaningAdapter extends TypeAdapter<WordMeaning> {
  @override
  final typeId = 16;

  @override
  WordMeaning read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordMeaning(
      meaning: fields[0] as String,
      partOfSpeech: fields[1] as PartOfSpeech,
      examples: (fields[2] as List).cast<WordExample>(),
      wordPronunciationAudioPath: fields[3] as String,
      image: fields[6] as WordImage?,
      languageSpecificDetails: fields[5] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, WordMeaning obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.meaning)
      ..writeByte(1)
      ..write(obj.partOfSpeech)
      ..writeByte(2)
      ..write(obj.examples)
      ..writeByte(3)
      ..write(obj.wordPronunciationAudioPath)
      ..writeByte(5)
      ..write(obj.languageSpecificDetails)
      ..writeByte(6)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordMeaningAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SpanishWordAdapter extends TypeAdapter<SpanishWord> {
  @override
  final typeId = 17;

  @override
  SpanishWord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpanishWord(
      word: fields[0] as String,
      meanings: (fields[1] as List).cast<WordMeaning>(),
    );
  }

  @override
  void write(BinaryWriter writer, SpanishWord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.meanings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpanishWordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordImageAdapter extends TypeAdapter<WordImage> {
  @override
  final typeId = 18;

  @override
  WordImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordImage(
      imagePath: fields[0] as String,
      imageCredits: fields[1] as String,
      width: (fields[2] as num).toInt(),
      height: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, WordImage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.imagePath)
      ..writeByte(1)
      ..write(obj.imageCredits)
      ..writeByte(2)
      ..write(obj.width)
      ..writeByte(3)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
