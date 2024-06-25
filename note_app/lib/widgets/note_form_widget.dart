import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  const NoteFormWidget({
    Key? key,
    required this.isImportant,
    required this.title,
    required this.description,
    required this.time,
    required this.folderId,
    required this.onChangedImportant,
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onChangedTime,
    required this.onChangedFolderId,
  }) : super(key: key);

  final bool isImportant;
  final String title;
  final String description;
  final String time;
  final int folderId;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<String> onChangedTime;
  final ValueChanged<int> onChangedFolderId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Switch(
                  value: isImportant,
                  onChanged: onChangedImportant,
                ),
                Expanded(
                  child: TextFormField(
                    maxLines: 1,
                    initialValue: title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onChanged: onChangedTitle,
                    validator: (title) {
                      return title == null || title.isEmpty ? 'Title cannot be empty' : null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: null,
              initialValue: description,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type something',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: onChangedDescription,
              validator: (desc) {
                return desc != null && desc.isEmpty ? 'The description cannot be empty' : null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
