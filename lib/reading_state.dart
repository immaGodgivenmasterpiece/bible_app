import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingState extends ChangeNotifier {
  Map<String, String> _readings = {};
  Map<String, bool> _readStatus = {};
  Map<String, String> get readings => _readings;
  Map<String, bool> get readStatus => _readStatus;

  ReadingState() {
    _loadReadings();
  }

  Future<void> _loadReadings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedReadings = prefs.getString('readings');
    final String? storedReadStatus = prefs.getString('readStatus');

    if (storedReadings != null && storedReadStatus != null) {
      _readings = Map<String, String>.from(json.decode(storedReadings));
      _readStatus = Map<String, bool>.from(json.decode(storedReadStatus));
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
      await _saveToLocalStorage();
    }
    notifyListeners();
  }

  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('readings', json.encode(_readings));
    await prefs.setString('readStatus', json.encode(_readStatus));
  }

  void markAsRead(String tileId) {
    _readStatus[tileId] = true;
    _saveToLocalStorage();
    notifyListeners();
  }

  void markAsUnread(String tileId) {
    _readStatus[tileId] = false;
    _saveToLocalStorage();
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
