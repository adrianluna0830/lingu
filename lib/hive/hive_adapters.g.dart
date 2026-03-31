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
