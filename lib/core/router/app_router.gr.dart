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
    required VoidCallback onComplete,
    List<PageRouteInfo>? children,
  }) : super(
         AICredentialsRoute.name,
         args: AICredentialsRouteArgs(onComplete: onComplete),
         initialChildren: children,
       );

  static const String name = 'AICredentialsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AICredentialsRouteArgs>();
      return AICredentialsView(onComplete: args.onComplete);
    },
  );
}

class AICredentialsRouteArgs {
  const AICredentialsRouteArgs({required this.onComplete});

  final VoidCallback onComplete;

  @override
  String toString() {
    return 'AICredentialsRouteArgs{onComplete: $onComplete}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AICredentialsRouteArgs) return false;
    return onComplete == other.onComplete;
  }

  @override
  int get hashCode => onComplete.hashCode;
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
    required VoidCallback onComplete,
    List<PageRouteInfo>? children,
  }) : super(
         LearningLocaleRoute.name,
         args: LearningLocaleRouteArgs(onComplete: onComplete),
         initialChildren: children,
       );

  static const String name = 'LearningLocaleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LearningLocaleRouteArgs>();
      return LearningLocaleView(onComplete: args.onComplete);
    },
  );
}

class LearningLocaleRouteArgs {
  const LearningLocaleRouteArgs({required this.onComplete});

  final VoidCallback onComplete;

  @override
  String toString() {
    return 'LearningLocaleRouteArgs{onComplete: $onComplete}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LearningLocaleRouteArgs) return false;
    return onComplete == other.onComplete;
  }

  @override
  int get hashCode => onComplete.hashCode;
}

/// generated route for
/// [NativeLocaleView]
class NativeLocaleRoute extends PageRouteInfo<NativeLocaleRouteArgs> {
  NativeLocaleRoute({
    required VoidCallback onComplete,
    List<PageRouteInfo>? children,
  }) : super(
         NativeLocaleRoute.name,
         args: NativeLocaleRouteArgs(onComplete: onComplete),
         initialChildren: children,
       );

  static const String name = 'NativeLocaleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NativeLocaleRouteArgs>();
      return NativeLocaleView(onComplete: args.onComplete);
    },
  );
}

class NativeLocaleRouteArgs {
  const NativeLocaleRouteArgs({required this.onComplete});

  final VoidCallback onComplete;

  @override
  String toString() {
    return 'NativeLocaleRouteArgs{onComplete: $onComplete}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NativeLocaleRouteArgs) return false;
    return onComplete == other.onComplete;
  }

  @override
  int get hashCode => onComplete.hashCode;
}

/// generated route for
/// [PronunciationAssessmentCredentialsView]
class PronunciationAssessmentCredentialsRoute
    extends PageRouteInfo<PronunciationAssessmentCredentialsRouteArgs> {
  PronunciationAssessmentCredentialsRoute({
    required VoidCallback onComplete,
    List<PageRouteInfo>? children,
  }) : super(
         PronunciationAssessmentCredentialsRoute.name,
         args: PronunciationAssessmentCredentialsRouteArgs(
           onComplete: onComplete,
         ),
         initialChildren: children,
       );

  static const String name = 'PronunciationAssessmentCredentialsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PronunciationAssessmentCredentialsRouteArgs>();
      return PronunciationAssessmentCredentialsView(
        onComplete: args.onComplete,
      );
    },
  );
}

class PronunciationAssessmentCredentialsRouteArgs {
  const PronunciationAssessmentCredentialsRouteArgs({required this.onComplete});

  final VoidCallback onComplete;

  @override
  String toString() {
    return 'PronunciationAssessmentCredentialsRouteArgs{onComplete: $onComplete}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PronunciationAssessmentCredentialsRouteArgs) return false;
    return onComplete == other.onComplete;
  }

  @override
  int get hashCode => onComplete.hashCode;
}

/// generated route for
/// [TTSCredentialsView]
class TTSCredentialsRoute extends PageRouteInfo<TTSCredentialsRouteArgs> {
  TTSCredentialsRoute({
    required VoidCallback onComplete,
    List<PageRouteInfo>? children,
  }) : super(
         TTSCredentialsRoute.name,
         args: TTSCredentialsRouteArgs(onComplete: onComplete),
         initialChildren: children,
       );

  static const String name = 'TTSCredentialsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TTSCredentialsRouteArgs>();
      return TTSCredentialsView(onComplete: args.onComplete);
    },
  );
}

class TTSCredentialsRouteArgs {
  const TTSCredentialsRouteArgs({required this.onComplete});

  final VoidCallback onComplete;

  @override
  String toString() {
    return 'TTSCredentialsRouteArgs{onComplete: $onComplete}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TTSCredentialsRouteArgs) return false;
    return onComplete == other.onComplete;
  }

  @override
  int get hashCode => onComplete.hashCode;
}
