import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      // 초기 데이터가 없을 경우 Firestore에 빈 데이터를 저장합니다.
      _readings = {};
      _readStatus = {};
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
    notifyListeners();
    _saveToFirestore(); // 비동기로 Firestore에 저장.
  }

  void markAsUnread(String tileId) {
    _readStatus[tileId] = false;
    notifyListeners();
    _saveToFirestore(); // 비동기로 Firestore에 저장
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
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ReadingState extends ChangeNotifier {
//   Map<String, String> _readings = {};
//   Map<String, bool> _readStatus = {};
//   Map<String, String> get readings => _readings;
//   Map<String, bool> get readStatus => _readStatus;

//   ReadingState() {
//     _loadReadings();
//   }

//   Future<void> _loadReadings() async {
//     final firestore = FirebaseFirestore.instance;
//     final readingsDoc =
//         await firestore.collection('readings').doc('data').get();
//     final readStatusDoc =
//         await firestore.collection('readStatus').doc('data').get();

//     if (readingsDoc.exists && readStatusDoc.exists) {
//       _readings = Map<String, String>.from(readingsDoc.data()!);
//       _readStatus = Map<String, bool>.from(readStatusDoc.data()!);
//     } else {
//       // 초기 데이터가 없을 경우 Firestore에 빈 데이터를 저장합니다.
//       _readings = {};
//       _readStatus = {};
//       await _saveToFirestore();
//     }
//     notifyListeners();
//   }

//   Future<void> _saveToFirestore() async {
//     final firestore = FirebaseFirestore.instance;
//     await firestore.collection('readings').doc('data').set(_readings);
//     await firestore.collection('readStatus').doc('data').set(_readStatus);
//   }

//   void markAsRead(String tileId) {
//     _readStatus[tileId] = true;
//     _saveToFirestore();
//     notifyListeners();
//   }

//   void markAsUnread(String tileId) {
//     _readStatus[tileId] = false;
//     _saveToFirestore();
//     notifyListeners();
//   }

//   int getLastReadTileIndex() {
//     List<MapEntry<String, bool>> sortedEntries = _readStatus.entries.toList()
//       ..sort((a, b) => int.parse(a.key.split('_')[1])
//           .compareTo(int.parse(b.key.split('_')[1])));
//     for (int i = sortedEntries.length - 1; i >= 0; i--) {
//       if (sortedEntries[i].value) {
//         return i;
//       }
//     }
//     return -1;
//   }

//   int getNextUnreadTileIndex() {
//     int lastReadIndex = getLastReadTileIndex();
//     List<MapEntry<String, bool>> sortedEntries = _readStatus.entries.toList()
//       ..sort((a, b) => int.parse(a.key.split('_')[1])
//           .compareTo(int.parse(b.key.split('_')[1])));
//     for (int i = lastReadIndex + 1; i < sortedEntries.length; i++) {
//       if (!sortedEntries[i].value) {
//         return i;
//       }
//     }
//     return -1;
//   }
// }
