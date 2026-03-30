import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/models/cefr.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/features/topics/topic_form_dialog.dart';
import 'package:lingu/features/topics/topic_view_state.dart';
import 'package:lingu/features/topics/topics_manager.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class TopicsView extends StatefulWidget {
  const TopicsView({super.key});

  @override
  State<TopicsView> createState() => _TopicsViewState();
}

class _TopicsViewState extends State<TopicsView> with SignalsMixin {
  late final manager = di<TopicsManager>();
  final Set<int> _selected = {};

  Future<void> _openAdd() async {
    final result =
        await showDialog<
          ({String title, String? subtitle, String? description, CEFR? level})
        >(
          context: context,
          builder: (_) => const TopicFormDialog(confirmLabel: 'Add'),
        );
    if (result != null) {
      manager.add(
        result.title,
        result.subtitle,
        result.description,
        result.level,
      );
    } else {
      manager.close();
    }
  }

  Future<void> _openEdit(EditingState s) async {
    final result =
        await showDialog<
          ({String title, String? subtitle, String? description, CEFR? level})
        >(
          context: context,
          builder: (_) => TopicFormDialog(
            initialTitle: s.title,
            initialSubtitle: s.subtitle,
            initialDescription: s.description,
            initialLevel: s.level,
            confirmLabel: 'Save',
          ),
        );
    if (result != null) {
      manager.saveEdit(
        s.index,
        result.title,
        result.subtitle,
        result.description,
        result.level,
      );
    } else {
      manager.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = manager.state.watch(context);
    final topics = manager.topics.watch(context);

    final isReordering = state is ReorderingState;
    final isDeleting = state is DeletingState;
    final hasSelection = _selected.isNotEmpty;
    final isBusy = isReordering || isDeleting;
    final isDeletingWithSelection = isDeleting && hasSelection;

    const activeOpacity = 1.0;
    const dimmedOpacity = 0.3;
    final reorderOpacity = isDeleting ? dimmedOpacity : activeOpacity;
    final deleteOpacity = isReordering ? dimmedOpacity : activeOpacity;
    final addOpacity = isDeletingWithSelection ? activeOpacity : (isBusy ? dimmedOpacity : activeOpacity);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is AddTopicState) _openAdd();
      if (state is EditingState) _openEdit(state);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
        actions: [
          AnimatedOpacity(
            opacity: reorderOpacity,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: isDeleting,
              child: IconButton(
                icon: Icon(isReordering ? Icons.check : Icons.sort),
                onPressed: () =>
                    isReordering ? manager.close() : manager.enableReordering(),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: deleteOpacity,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: isReordering,
              child: IconButton(
                icon: Icon(isDeleting ? Icons.close : Icons.checklist),
                onPressed: () {
                  if (isDeleting) {
                    _selected.clear();
                    manager.close();
                  } else {
                    manager.enableDeleting();
                  }
                },
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: addOpacity,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: isBusy && !isDeletingWithSelection,
              child: IconButton(
                icon: Icon(isDeletingWithSelection ? Icons.delete : Icons.add),
                onPressed: isDeletingWithSelection
                    ? () {
                        manager.delete(_selected.toList());
                        _selected.clear();
                      }
                    : manager.enableAdding,
              ),
            ),
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: topics.length,
        onReorder: manager.reorder,
        buildDefaultDragHandles: false,
        itemBuilder: (context, i) {
          final topic = topics[i];
          final isSelected = _selected.contains(i);

          void toggleSelection() => setState(
            () => isSelected ? _selected.remove(i) : _selected.add(i),
          );

          final onTap = isReordering
              ? null
              : isDeleting
              ? toggleSelection
              : () => manager.showEdit(i);

          final leading = isReordering
              ? ReorderableDragStartListener(
                  index: i,
                  child: const Icon(Icons.drag_handle),
                )
              : isDeleting
              ? GestureDetector(
                  onTap: toggleSelection,
                  child: Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                  ),
                )
              : null;

          return ListTile(
            key: ValueKey(i),
            onTap: onTap,
            leading: leading,
            title: Text(topic.title),
            subtitle: topic.subtitle != null ? Text(topic.subtitle!) : null,
            trailing: topic.level != null
                ? Text(topic.level!.name.toUpperCase())
                : null,
          );
        },
      ),
    );
  }
}
