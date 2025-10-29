import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class VoteHistoryService {
  static const _storage = FlutterSecureStorage();

  static const _key = 'voted_polls_list';

  static Future<void> addVotedPoll(String pollToken) async {
    try {
      final String? jsonString = await _storage.read(key: _key);

      List<String> votedPolls = [];
      if (jsonString != null) {
        votedPolls = (jsonDecode(jsonString) as List).cast<String>();
      }

      if (!votedPolls.contains(pollToken)) {
        votedPolls.add(pollToken);

        final String newJsonString = jsonEncode(votedPolls);

        await _storage.write(key: _key, value: newJsonString);
      }
    } catch (e) {
      print('Error guardando en secure storage: $e');
    }
  }

  static Future<List<String>> getVotedPolls() async {
    try {
      final String? jsonString = await _storage.read(key: _key);

      if (jsonString == null) {
        return [];
      }

      return (jsonDecode(jsonString) as List).cast<String>();
    } catch (e) {
      print('Error leyendo de secure storage: $e');
      return [];
    }
  }
}
