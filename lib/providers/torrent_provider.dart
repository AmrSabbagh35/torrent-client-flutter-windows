import 'package:flutter/material.dart';
import 'package:qbittorrent_api/qbittorrent_api.dart';
import '../../data/services/qbittorrent_service.dart';

class TorrentProvider extends ChangeNotifier {
  final QBittorrentService _service = QBittorrentService();
  List<TorrentInfo> torrents = [];
  bool isLoading = true;
  String error = '';

  QBittorrentService get service => _service;

  Future<void> initialize() async {
    try {
      print('[TorrentProvider] Starting initialization...');
      isLoading = true;
      notifyListeners();

      await _service.initialize();

      print('[TorrentProvider] Starting sync...');
      _service.startSync(
        interval: Duration(seconds: 3),
        onData: (data) {
          torrents = data;
          print('[TorrentProvider] Received ${data.length} torrents');
          notifyListeners();
        },
      );

      isLoading = false;
      notifyListeners();
    } catch (e, stacktrace) {
      print('[TorrentProvider] ❌ Init failed: $e\n$stacktrace');
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMagnet(String url) async {
    try {
      await _service.addMagnet(url);
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> pauseTorrent(String hash) async {
    await _service.pause(hash);
  }

  Future<void> resumeTorrent(String hash) async {
    await _service.resume(hash);
  }

  Future<void> deleteTorrent(String hash, {bool deleteFiles = false}) async {
    await _service.delete(hash, deleteFiles: deleteFiles);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
