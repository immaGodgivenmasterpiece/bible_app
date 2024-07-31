import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reading_state.dart';

class ReadingPage extends StatelessWidget {
  final String tileId;
  ReadingPage({required this.tileId});

  @override
  Widget build(BuildContext context) {
    final readingState = Provider.of<ReadingState>(context);
    final isRead = readingState.readStatus[tileId] ?? false;
    final content = readingState.readings[tileId] ?? '내용을 불러올 수 없습니다.';

    return Scaffold(
      appBar: AppBar(title: Text('교독문 ${int.parse(tileId.split('_')[1])}')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(
                content,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          if (isRead)
            ElevatedButton(
              onPressed: () {
                readingState.markAsUnread(tileId);
                Navigator.pop(context);
              },
              child: Text('읽음 취소'),
            ),
          if (!isRead)
            ElevatedButton(
              onPressed: () {
                readingState.markAsRead(tileId);
                Navigator.pop(context);
              },
              child: Text('읽음 표시'),
            ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
