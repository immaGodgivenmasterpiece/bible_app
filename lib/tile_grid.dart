import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reading_state.dart';
import 'reading_page.dart';

class TileGrid extends StatefulWidget {
  @override
  _TileGridState createState() => _TileGridState();
}

class _TileGridState extends State<TileGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final readingState = Provider.of<ReadingState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('교독문'),
        actions: [
          ElevatedButton(
            onPressed: () {
              _jumpToNextUnread(readingState);
            },
            child: Text('오늘의 교독문'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1.0,
        ),
        itemCount: 137,
        itemBuilder: (context, index) {
          final tileId = 'tile_${index + 1}';
          final isRead = readingState.readStatus[tileId] ?? false;
          final content = readingState.readings[tileId] ?? '';
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadingPage(tileId: tileId),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(4),
              color: isRead ? Colors.green : Colors.red,
              child: Center(
                child: Text(
                  '${content.split('\n').first}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _jumpToNextUnread(ReadingState readingState) {
    int nextUnreadIndex = readingState.getNextUnreadTileIndex();
    if (nextUnreadIndex == -1) return;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final itemWidth = screenWidth / 5;
    final itemHeight = itemWidth;
    final rowIndex = nextUnreadIndex ~/ 5;
    final targetPosition = rowIndex * itemHeight;
    _scrollController.jumpTo(targetPosition);
  }
}
