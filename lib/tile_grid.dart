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
            final chapterInfo = content.split('.').length > 1
                ? content.split('.')[1].split('\n')[0].trim()
                : '';

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
                color:
                    isRead ? Colors.green : Color.fromARGB(255, 219, 130, 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      chapterInfo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ));
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
