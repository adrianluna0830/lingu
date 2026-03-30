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
