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
              child: _buildStyledContent(content),
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

  Widget _buildStyledContent(String content) {
    final lines = content.split('\n');
    List<TextSpan> textSpans = [];
    bool nextLineBlueBold = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (nextLineBlueBold) {
        textSpans.add(TextSpan(
          text: line + '\n',
          style: TextStyle(
              color: Color.fromARGB(245, 0, 79, 216),
              fontWeight: FontWeight.bold),
        ));
        nextLineBlueBold = false;
      } else if (line.contains('(다같이)')) {
        textSpans.add(TextSpan(
          text: line + '\n',
        ));
        nextLineBlueBold = true;
      } else if (i % 2 == 1) {
        textSpans.add(TextSpan(
          text: line + '\n',
        ));
      } else {
        textSpans.add(TextSpan(
          text: line + '\n',
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 18, color: Colors.black),
        children: textSpans,
      ),
    );
  }
}
