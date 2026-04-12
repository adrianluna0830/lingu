import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';

class UserAudioMessageDetails extends StatelessWidget {
  final UserAudioMessageDetailsViewDto data;

  const UserAudioMessageDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Container()
      ),
    );
  }
}
