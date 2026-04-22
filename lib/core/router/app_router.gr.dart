// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AICredentialsView]
class AICredentialsRoute extends PageRouteInfo<AICredentialsRouteArgs> {
  AICredentialsRoute({
    Key? key,
    required VoidCallback onComplete,
    bool isSetupFlow = false,
    List<PageRouteInfo>? children,
  }) : super(
         AICredentialsRoute.name,
         args: AICredentialsRouteArgs(
           key: key,
           onComplete: onComplete,
           isSetupFlow: isSetupFlow,
         ),
         initialChildren: children,
       );

  static const String name = 'AICredentialsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AICredentialsRouteArgs>();
      return AICredentialsView(
        key: args.key,
        onComplete: args.onComplete,
        isSetupFlow: args.isSetupFlow,
      );
    },
  );
}

class AICredentialsRouteArgs {
  const AICredentialsRouteArgs({
    this.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  final Key? key;

  final VoidCallback onComplete;

  final bool isSetupFlow;

  @override
  String toString() {
    return 'AICredentialsRouteArgs{key: $key, onComplete: $onComplete, isSetupFlow: $isSetupFlow}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AICredentialsRouteArgs) return false;
    return key == other.key &&
        onComplete == other.onComplete &&
        isSetupFlow == other.isSetupFlow;
  }

  @override
  int get hashCode => key.hashCode ^ onComplete.hashCode ^ isSetupFlow.hashCode;
}

/// generated route for
/// [CEFRLevelView]
class CEFRLevelRoute extends PageRouteInfo<CEFRLevelRouteArgs> {
  CEFRLevelRoute({
    Key? key,
    required VoidCallback onComplete,
    bool isSetupFlow = false,
    List<PageRouteInfo>? children,
  }) : super(
         CEFRLevelRoute.name,
         args: CEFRLevelRouteArgs(
           key: key,
           onComplete: onComplete,
           isSetupFlow: isSetupFlow,
         ),
         initialChildren: children,
       );

  static const String name = 'CEFRLevelRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CEFRLevelRouteArgs>();
      return CEFRLevelView(
        key: args.key,
        onComplete: args.onComplete,
        isSetupFlow: args.isSetupFlow,
      );
    },
  );
}

class CEFRLevelRouteArgs {
  const CEFRLevelRouteArgs({
    this.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  final Key? key;

  final VoidCallback onComplete;

  final bool isSetupFlow;

  @override
  String toString() {
    return 'CEFRLevelRouteArgs{key: $key, onComplete: $onComplete, isSetupFlow: $isSetupFlow}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CEFRLevelRouteArgs) return false;
    return key == other.key &&
        onComplete == other.onComplete &&
        isSetupFlow == other.isSetupFlow;
  }

  @override
  int get hashCode => key.hashCode ^ onComplete.hashCode ^ isSetupFlow.hashCode;
}

/// generated route for
/// [ChatView]
class ChatRoute extends PageRouteInfo<void> {
  const ChatRoute({List<PageRouteInfo>? children})
    : super(ChatRoute.name, initialChildren: children);

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChatView();
    },
  );
}

/// generated route for
/// [HomeView]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeView();
    },
  );
}

/// generated route for
/// [LearningLocaleView]
class LearningLocaleRoute extends PageRouteInfo<LearningLocaleRouteArgs> {
  LearningLocaleRoute({
    Key? key,
    required VoidCallback onComplete,
    bool isSetupFlow = false,
    List<PageRouteInfo>? children,
  }) : super(
         LearningLocaleRoute.name,
         args: LearningLocaleRouteArgs(
           key: key,
           onComplete: onComplete,
           isSetupFlow: isSetupFlow,
         ),
         initialChildren: children,
       );

  static const String name = 'LearningLocaleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LearningLocaleRouteArgs>();
      return LearningLocaleView(
        key: args.key,
        onComplete: args.onComplete,
        isSetupFlow: args.isSetupFlow,
      );
    },
  );
}

class LearningLocaleRouteArgs {
  const LearningLocaleRouteArgs({
    this.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  final Key? key;

  final VoidCallback onComplete;

  final bool isSetupFlow;

  @override
  String toString() {
    return 'LearningLocaleRouteArgs{key: $key, onComplete: $onComplete, isSetupFlow: $isSetupFlow}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LearningLocaleRouteArgs) return false;
    return key == other.key &&
        onComplete == other.onComplete &&
        isSetupFlow == other.isSetupFlow;
  }

  @override
  int get hashCode => key.hashCode ^ onComplete.hashCode ^ isSetupFlow.hashCode;
}

/// generated route for
/// [MainView]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainView();
    },
  );
}

/// generated route for
/// [NativeLocaleView]
class NativeLocaleRoute extends PageRouteInfo<NativeLocaleRouteArgs> {
  NativeLocaleRoute({
    Key? key,
    required VoidCallback onComplete,
    bool isSetupFlow = false,
    List<PageRouteInfo>? children,
  }) : super(
         NativeLocaleRoute.name,
         args: NativeLocaleRouteArgs(
           key: key,
           onComplete: onComplete,
           isSetupFlow: isSetupFlow,
         ),
         initialChildren: children,
       );

  static const String name = 'NativeLocaleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NativeLocaleRouteArgs>();
      return NativeLocaleView(
        key: args.key,
        onComplete: args.onComplete,
        isSetupFlow: args.isSetupFlow,
      );
    },
  );
}

class NativeLocaleRouteArgs {
  const NativeLocaleRouteArgs({
    this.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  final Key? key;

  final VoidCallback onComplete;

  final bool isSetupFlow;

  @override
  String toString() {
    return 'NativeLocaleRouteArgs{key: $key, onComplete: $onComplete, isSetupFlow: $isSetupFlow}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NativeLocaleRouteArgs) return false;
    return key == other.key &&
        onComplete == other.onComplete &&
        isSetupFlow == other.isSetupFlow;
  }

  @override
  int get hashCode => key.hashCode ^ onComplete.hashCode ^ isSetupFlow.hashCode;
}

/// generated route for
/// [PixabayCredentialsView]
class PixabayCredentialsRoute
    extends PageRouteInfo<PixabayCredentialsRouteArgs> {
  PixabayCredentialsRoute({
    Key? key,
    required VoidCallback onComplete,
    bool isSetupFlow = false,
    List<PageRouteInfo>? children,
  }) : super(
         PixabayCredentialsRoute.name,
         args: PixabayCredentialsRouteArgs(
           key: key,
           onComplete: onComplete,
           isSetupFlow: isSetupFlow,
         ),
         initialChildren: children,
       );

  static const String name = 'PixabayCredentialsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PixabayCredentialsRouteArgs>();
      return PixabayCredentialsView(
        key: args.key,
        onComplete: args.onComplete,
        isSetupFlow: args.isSetupFlow,
      );
    },
  );
}

class PixabayCredentialsRouteArgs {
  const PixabayCredentialsRouteArgs({
    this.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  final Key? key;

  final VoidCallback onComplete;

  final bool isSetupFlow;

  @override
  String toString() {
    return 'PixabayCredentialsRouteArgs{key: $key, onComplete: $onComplete, isSetupFlow: $isSetupFlow}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PixabayCredentialsRouteArgs) return false;
    return key == other.key &&
        onComplete == other.onComplete &&
        isSetupFlow == other.isSetupFlow;
  }

  @override
  int get hashCode => key.hashCode ^ onComplete.hashCode ^ isSetupFlow.hashCode;
}

/// generated route for
/// [PronunciationAssessmentCredentialsView]
class PronunciationAssessmentCredentialsRoute
    extends PageRouteInfo<PronunciationAssessmentCredentialsRouteArgs> {
  PronunciationAssessmentCredentialsRoute({
    Key? key,
    required VoidCallback onComplete,
    bool isSetupFlow = false,
    List<PageRouteInfo>? children,
  }) : super(
         PronunciationAssessmentCredentialsRoute.name,
         args: PronunciationAssessmentCredentialsRouteArgs(
           key: key,
           onComplete: onComplete,
           isSetupFlow: isSetupFlow,
         ),
         initialChildren: children,
       );

  static const String name = 'PronunciationAssessmentCredentialsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PronunciationAssessmentCredentialsRouteArgs>();
      return PronunciationAssessmentCredentialsView(
        key: args.key,
        onComplete: args.onComplete,
        isSetupFlow: args.isSetupFlow,
      );
    },
  );
}

class PronunciationAssessmentCredentialsRouteArgs {
  const PronunciationAssessmentCredentialsRouteArgs({
    this.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  final Key? key;

  final VoidCallback onComplete;

  final bool isSetupFlow;

  @override
  String toString() {
    return 'PronunciationAssessmentCredentialsRouteArgs{key: $key, onComplete: $onComplete, isSetupFlow: $isSetupFlow}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PronunciationAssessmentCredentialsRouteArgs) return false;
    return key == other.key &&
        onComplete == other.onComplete &&
        isSetupFlow == other.isSetupFlow;
  }

  @override
  int get hashCode => key.hashCode ^ onComplete.hashCode ^ isSetupFlow.hashCode;
}

/// generated route for
/// [STTCredentialsView]
class STTCredentialsRoute extends PageRouteInfo<STTCredentialsRouteArgs> {
  STTCredentialsRoute({
    Key? key,
    required VoidCallback onComplete,
    bool isSetupFlow = false,
    List<PageRouteInfo>? children,
  }) : super(
         STTCredentialsRoute.name,
         args: STTCredentialsRouteArgs(
           key: key,
           onComplete: onComplete,
           isSetupFlow: isSetupFlow,
         ),
         initialChildren: children,
       );

  static const String name = 'STTCredentialsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<STTCredentialsRouteArgs>();
      return STTCredentialsView(
        key: args.key,
        onComplete: args.onComplete,
        isSetupFlow: args.isSetupFlow,
      );
    },
  );
}

class STTCredentialsRouteArgs {
  const STTCredentialsRouteArgs({
    this.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  final Key? key;

  final VoidCallback onComplete;

  final bool isSetupFlow;

  @override
  String toString() {
    return 'STTCredentialsRouteArgs{key: $key, onComplete: $onComplete, isSetupFlow: $isSetupFlow}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! STTCredentialsRouteArgs) return false;
    return key == other.key &&
        onComplete == other.onComplete &&
        isSetupFlow == other.isSetupFlow;
  }

  @override
  int get hashCode => key.hashCode ^ onComplete.hashCode ^ isSetupFlow.hashCode;
}

/// generated route for
/// [SettingsView]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsView();
    },
  );
}

/// generated route for
/// [TTSCredentialsView]
class TTSCredentialsRoute extends PageRouteInfo<TTSCredentialsRouteArgs> {
  TTSCredentialsRoute({
    Key? key,
    required VoidCallback onComplete,
    bool isSetupFlow = false,
    List<PageRouteInfo>? children,
  }) : super(
         TTSCredentialsRoute.name,
         args: TTSCredentialsRouteArgs(
           key: key,
           onComplete: onComplete,
           isSetupFlow: isSetupFlow,
         ),
         initialChildren: children,
       );

  static const String name = 'TTSCredentialsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TTSCredentialsRouteArgs>();
      return TTSCredentialsView(
        key: args.key,
        onComplete: args.onComplete,
        isSetupFlow: args.isSetupFlow,
      );
    },
  );
}

class TTSCredentialsRouteArgs {
  const TTSCredentialsRouteArgs({
    this.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  final Key? key;

  final VoidCallback onComplete;

  final bool isSetupFlow;

  @override
  String toString() {
    return 'TTSCredentialsRouteArgs{key: $key, onComplete: $onComplete, isSetupFlow: $isSetupFlow}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TTSCredentialsRouteArgs) return false;
    return key == other.key &&
        onComplete == other.onComplete &&
        isSetupFlow == other.isSetupFlow;
  }

  @override
  int get hashCode => key.hashCode ^ onComplete.hashCode ^ isSetupFlow.hashCode;
}

/// generated route for
/// [TopicsView]
class TopicsRoute extends PageRouteInfo<void> {
  const TopicsRoute({List<PageRouteInfo>? children})
    : super(TopicsRoute.name, initialChildren: children);

  static const String name = 'TopicsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TopicsView();
    },
  );
}

/// generated route for
/// [WordFetchView]
class WordFetchRoute extends PageRouteInfo<WordFetchRouteArgs> {
  WordFetchRoute({
    Key? key,
    required String word,
    required String wordInContext,
    required LanguageLocale learningLocale,
    required LanguageLocale nativeLocale,
    List<PageRouteInfo>? children,
  }) : super(
         WordFetchRoute.name,
         args: WordFetchRouteArgs(
           key: key,
           word: word,
           wordInContext: wordInContext,
           learningLocale: learningLocale,
           nativeLocale: nativeLocale,
         ),
         initialChildren: children,
       );

  static const String name = 'WordFetchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WordFetchRouteArgs>();
      return WordFetchView(
        key: args.key,
        word: args.word,
        wordInContext: args.wordInContext,
        learningLocale: args.learningLocale,
        nativeLocale: args.nativeLocale,
      );
    },
  );
}

class WordFetchRouteArgs {
  const WordFetchRouteArgs({
    this.key,
    required this.word,
    required this.wordInContext,
    required this.learningLocale,
    required this.nativeLocale,
  });

  final Key? key;

  final String word;

  final String wordInContext;

  final LanguageLocale learningLocale;

  final LanguageLocale nativeLocale;

  @override
  String toString() {
    return 'WordFetchRouteArgs{key: $key, word: $word, wordInContext: $wordInContext, learningLocale: $learningLocale, nativeLocale: $nativeLocale}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WordFetchRouteArgs) return false;
    return key == other.key &&
        word == other.word &&
        wordInContext == other.wordInContext &&
        learningLocale == other.learningLocale &&
        nativeLocale == other.nativeLocale;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      word.hashCode ^
      wordInContext.hashCode ^
      learningLocale.hashCode ^
      nativeLocale.hashCode;
}

/// generated route for
/// [WordView]
class WordRoute extends PageRouteInfo<WordRouteArgs> {
  WordRoute({Key? key, required Word word, List<PageRouteInfo>? children})
    : super(
        WordRoute.name,
        args: WordRouteArgs(key: key, word: word),
        initialChildren: children,
      );

  static const String name = 'WordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WordRouteArgs>();
      return WordView(key: args.key, word: args.word);
    },
  );
}

class WordRouteArgs {
  const WordRouteArgs({this.key, required this.word});

  final Key? key;

  final Word word;

  @override
  String toString() {
    return 'WordRouteArgs{key: $key, word: $word}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WordRouteArgs) return false;
    return key == other.key && word == other.word;
  }

  @override
  int get hashCode => key.hashCode ^ word.hashCode;
}
