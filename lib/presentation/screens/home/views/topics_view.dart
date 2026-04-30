import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/core/models/cefr.dart';
import 'package:lingu/domain/topic/models/topic.dart';
import 'package:lingu/domain/topic/models/topic_view_state.dart';
import 'package:lingu/domain/topic/managers/topics_manager.dart';
import 'package:signals/signals_flutter.dart';

import 'package:lingu/presentation/screens/home/components/topic_form_dialog.dart';

@RoutePage()
class TopicsView extends StatefulWidget {
  const TopicsView({super.key});

  @override
  State<TopicsView> createState() => _TopicsViewState();
}

class _TopicsViewState extends State<TopicsView> with SignalsMixin {
  late final manager = di<TopicsManager>();
  final Set<int> _selected = {};
  bool _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    manager.close();
  }

  Future<void> _openAdd() async {
    if (_isDialogOpen || !mounted) return;
    _isDialogOpen = true;
    final result =
        await showDialog<
          ({String title, String? subtitle, String? description, CEFR? level, TopicStatus status})
        >(
          context: context,
          builder: (_) => const TopicFormDialog(confirmLabel: 'Add'),
        );
    _isDialogOpen = false;
    if (result != null) {
      manager.add(
        result.title,
        result.subtitle,
        result.description,
        result.level,
        result.status,
      );
    } else {
      manager.close();
    }
  }

  Future<void> _openEdit(EditingState s) async {
    if (_isDialogOpen || !mounted) return;
    _isDialogOpen = true;
    final result =
        await showDialog<
          ({String title, String? subtitle, String? description, CEFR? level, TopicStatus status})
        >(
          context: context,
          builder: (_) => TopicFormDialog(
            initialTitle: s.title,
            initialSubtitle: s.subtitle,
            initialDescription: s.description,
            initialLevel: s.level,
            initialStatus: s.status,
            confirmLabel: 'Save',
          ),
        );
    _isDialogOpen = false;
    if (result != null) {
      manager.saveEdit(
        s.index,
        result.title,
        result.subtitle,
        result.description,
        result.level,
        result.status,
      );
    } else {
      manager.close();
    }
  }

  Future<void> _openBulkEditStatus() async {
    final result = await showDialog<TopicStatus>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change status for selected'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TopicStatus.values.map((status) {
            return ListTile(
              title: Text(status.name.toUpperCase()),
              onTap: () => Navigator.of(context).pop(status),
            );
          }).toList(),
        ),
      ),
    );

    if (result != null) {
      manager.bulkUpdateStatus(_selected.toList(), result);
      _selected.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = manager.state.watch(context);
    final topics = manager.filteredTopics.watch(context);

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
          if (isDeleting)
            IconButton(
              icon: Icon(_selected.length == topics.length ? Icons.select_all : Icons.deselect),
              tooltip: 'Select/Deselect All',
              onPressed: () {
                setState(() {
                  if (_selected.length == topics.length) {
                    _selected.clear();
                  } else {
                    _selected.clear();
                    _selected.addAll(Iterable<int>.generate(topics.length));
                  }
                });
              },
            ),
          if (isDeletingWithSelection)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: _openBulkEditStatus,
            ),
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

          Widget? statusIndicator;
          switch (topic.status) {
            case TopicStatus.normal:
            case TopicStatus.disabled:
            case TopicStatus.mastered:
              statusIndicator = null;
              break;
            case TopicStatus.prioritized:
              statusIndicator = const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.label_important, size: 16, color: Colors.amber),
              );
              break;
          }

          final tile = ListTile(
            key: ValueKey(topic.id),
            onTap: onTap,
            leading: leading,
            title: Row(
              children: [
                Text(
                  topic.topic.title,
                  style: TextStyle(
                    color: topic.status == TopicStatus.mastered ? Colors.grey : null,
                    decoration: topic.status == TopicStatus.mastered 
                        ? TextDecoration.lineThrough 
                        : TextDecoration.none,
                    fontStyle: topic.status == TopicStatus.disabled ? FontStyle.italic : null,
                  ),
                ),
                ?statusIndicator,
              ],
            ),
            subtitle: topic.topic.subtitle != null ? Text(topic.topic.subtitle!) : null,
            trailing: topic.topic.level != null
                ? Text(topic.topic.level!.name.toUpperCase())
                : null,
          );

          if (topic.status == TopicStatus.disabled) {
            return Opacity(
              key: ValueKey(topic.id),
              opacity: 0.5,
              child: tile,
            );
          }

          return tile;
        },
      ),
    );
  }
}
