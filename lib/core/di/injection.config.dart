// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lingu/core/audio/playback/i_audio_playback.dart' as _i65;
import 'package:lingu/core/audio/playback/just_audio_player_manager.dart'
    as _i198;
import 'package:lingu/core/audio/record/audio_recorder.dart' as _i109;
import 'package:lingu/core/audio/record/i_audio_recorder.dart' as _i709;
import 'package:lingu/core/router/app_router.dart' as _i1036;
import 'package:lingu/features/chat/logic/message/audio_message_input.dart'
    as _i344;
import 'package:lingu/features/chat/logic/message/chat_messages_manager.dart'
    as _i149;
import 'package:lingu/features/chat/logic/panel/panel_handler.dart' as _i15;
import 'package:lingu/features/chat/logic/panel/panel_manager.dart' as _i420;
import 'package:lingu/features/text_message_input.dart' as _i239;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i1036.AppRouter>(() => _i1036.AppRouter());
    gh.singleton<_i149.ChatMessagesManager>(() => _i149.ChatMessagesManager());
    gh.singleton<_i420.PanelManager>(() => _i420.PanelManager());
    gh.singleton<_i709.IAudioRecorder>(() => _i109.AudioRecorder());
    gh.singleton<_i65.IAudioPlayerManager>(
      () => _i198.JustAudioPlayerManager(),
    );
    gh.singleton<_i344.AudioMessageInput>(
      () => _i344.AudioMessageInput(gh<_i149.ChatMessagesManager>()),
    );
    gh.singleton<_i239.TextMessageInput>(
      () => _i239.TextMessageInput(gh<_i149.ChatMessagesManager>()),
    );
    gh.singleton<_i15.PanelHandler>(
      () => _i15.PanelHandler(
        gh<_i420.PanelManager>(),
        gh<_i344.AudioMessageInput>(),
        gh<_i239.TextMessageInput>(),
      ),
    );
    return this;
  }
}
