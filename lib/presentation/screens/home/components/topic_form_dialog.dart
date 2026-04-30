import 'package:flutter/material.dart';
import 'package:lingu/domain/core/models/cefr.dart';
import 'package:lingu/domain/topic/models/topic.dart';

class TopicFormDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialSubtitle;
  final String? initialDescription;
  final CEFR? initialLevel;
  final TopicStatus? initialStatus;
  final String confirmLabel;

  const TopicFormDialog({
    super.key,
    this.initialTitle,
    this.initialSubtitle,
    this.initialDescription,
    this.initialLevel,
    this.initialStatus,
    required this.confirmLabel,
  });

  @override
  State<TopicFormDialog> createState() => _TopicFormDialogState();
}

class _TopicFormDialogState extends State<TopicFormDialog> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _subtitleCtrl;
  late final TextEditingController _descriptionCtrl;
  CEFR? _level;
  TopicStatus _status = TopicStatus.normal;
  bool _titleError = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle ?? '');
    _subtitleCtrl = TextEditingController(text: widget.initialSubtitle ?? '');
    _descriptionCtrl = TextEditingController(text: widget.initialDescription ?? '');
    _level = widget.initialLevel;
    _status = widget.initialStatus ?? TopicStatus.normal;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _titleError = true);
      return;
    }
    Navigator.of(context).pop((
      title: _titleCtrl.text.trim(),
      subtitle: _subtitleCtrl.text.trim().isEmpty ? null : _subtitleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim().isEmpty ? null : _descriptionCtrl.text.trim(),
      level: _level,
      status: _status,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                hintText: 'Title',
                border: const OutlineInputBorder(),
                errorText: _titleError ? 'Title is required' : null,
              ),
              onChanged: (_) {
                if (_titleError) setState(() => _titleError = false);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _subtitleCtrl,
              decoration: const InputDecoration(
                hintText: 'Subtitle',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<CEFR>(
              initialValue: _level,
              hint: const Text('Level (CEFR)'),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem(value: null, child: Text('Not specified')),
                ...CEFR.values.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name.toUpperCase()),
                    )),
              ],
              onChanged: (v) => setState(() => _level = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TopicStatus>(
              initialValue: _status,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Status'),
              items: TopicStatus.values.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toUpperCase()),
                  )).toList(),
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _confirm,
                  child: Text(widget.confirmLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
