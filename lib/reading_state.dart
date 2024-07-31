import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ReadingState extends ChangeNotifier {
  Map<String, String> _readings = {};
  Map<String, bool> _readStatus = {};
  Map<String, String> get readings => _readings;
  Map<String, bool> get readStatus => _readStatus;

  ReadingState() {
    _loadReadings();
  }

  Future<void> _loadReadings() async {
    final firestore = FirebaseFirestore.instance;
    final readingsDoc =
        await firestore.collection('readings').doc('data').get();
    final readStatusDoc =
        await firestore.collection('readStatus').doc('data').get();

    if (readingsDoc.exists && readStatusDoc.exists) {
      _readings = Map<String, String>.from(readingsDoc.data()!);
      _readStatus = Map<String, bool>.from(readStatusDoc.data()!);
    } else {
      final String response =
          await rootBundle.loadString('assets/readings.json');
      final data = await json.decode(response);
      _readings = Map.from(data);
      _readStatus = Map.fromIterable(
        _readings.keys,
        key: (k) => k,
        value: (_) => false,
      );
      await _saveToFirestore();
    }
    notifyListeners();
  }

  Future<void> _saveToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('readings').doc('data').set(_readings);
    await firestore.collection('readStatus').doc('data').set(_readStatus);
  }

  void markAsRead(String tileId) {
    _readStatus[tileId] = true;
    _saveToFirestore();
    notifyListeners();
  }

  void markAsUnread(String tileId) {
    _readStatus[tileId] = false;
    _saveToFirestore();
    notifyListeners();
  }

  int getLastReadTileIndex() {
    List<MapEntry<String, bool>> sortedEntries = _readStatus.entries.toList()
      ..sort((a, b) => int.parse(a.key.split('_')[1])
          .compareTo(int.parse(b.key.split('_')[1])));
    for (int i = sortedEntries.length - 1; i >= 0; i--) {
      if (sortedEntries[i].value) {
        return i;
      }
    }
    return -1;
  }

  int getNextUnreadTileIndex() {
    int lastReadIndex = getLastReadTileIndex();
    List<MapEntry<String, bool>> sortedEntries = _readStatus.entries.toList()
      ..sort((a, b) => int.parse(a.key.split('_')[1])
          .compareTo(int.parse(b.key.split('_')[1])));
    for (int i = lastReadIndex + 1; i < sortedEntries.length; i++) {
      if (!sortedEntries[i].value) {
        return i;
      }
    }
    return -1;
  }
}
