import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/widgets/base_message_details_options.dart';
import 'package:signals/signals_flutter.dart';

abstract class BaseMessageDetailsPanel<E extends Enum> extends StatefulWidget {
  const BaseMessageDetailsPanel({super.key});

  @override
  State<BaseMessageDetailsPanel<E>> createState();
}

abstract class BaseMessageDetailsPanelState<E extends Enum, T extends BaseMessageDetailsPanel<E>> extends State<T> with SignalsMixin {
  late final selectedOption = createSignal<E?>(null);

  Widget buildHeader(BuildContext context) => const SizedBox.shrink();
  String getOptionTitle(E option, BuildContext context);
  Widget getOptionContent(E option);
  List<Option<E>> getOptions();

  @override
  Widget build(BuildContext context) {
    final selected = selectedOption.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildHeader(context),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: selected != null
                ? SingleChildScrollView(key: ValueKey(selected), padding: const EdgeInsets.all(16.0), child: getOptionContent(selected))
                : const Center(
                    child: Text('Select analysis type', style: TextStyle(color: Colors.grey)),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: BaseMessageDetailsOptions<E>(options: getOptions(), labelBuilder: (E value, BuildContext context) => getOptionTitle(value, context)),
          ),
        ),
      ],
    );
  }
}