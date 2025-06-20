import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/process_run.dart';
import 'package:qbittorrent_api/qbittorrent_api.dart';

class QBittorrentService {
  late final QBittorrentApiV2 _client;
  bool _initialized = false;

  List<TorrentInfo> currentTorrents = [];
  StreamSubscription<dynamic>? _subscription;

  Future<void> initialize() async {
    print('[QBittorrentService] Initializing...');
    final qbProcess = await Process.run('tasklist', []);

    if (!qbProcess.stdout.toString().contains('qbittorrent.exe')) {
      print('[QBittorrentService] qBittorrent is not running. Launching it...');
      try {
        await run(
          r'start "" "C:\Program Files\qBittorrent\qbittorrent.exe"',
          runInShell: true,
        );
        await Future.delayed(Duration(seconds: 2)); // Give it time to boot
      } catch (e) {
        print('[QBittorrentService] ❌ Failed to launch qBittorrent: $e');
        rethrow;
      }
    } else {
      print('[QBittorrentService] qBittorrent is already running.');
    }

    // Proceed with login
    try {
      await _client.auth.login(username: 'admin', password: 'adminadmin');
      print('[QBittorrentService] ✅ Login successful');
    } catch (e) {
      print('[QBittorrentService] ❌ Login failed: $e');
      rethrow;
    }
  }

  void startSync({
    required Duration interval,
    required Function(List<TorrentInfo>) onData,
  }) {
    _subscription = _client.sync
        .subscribeMainData(interval: interval)
        .listen(
          (data) {
            currentTorrents = data.torrents?.values.toList() ?? [];
            onData(currentTorrents);
          },
          onError: (error) {
            debugPrint('[Sync Error] $error');
          },
          cancelOnError: false,
        );
  }

  Future<void> addMagnet(String magnetUrl) async {
    final torrents = NewTorrents.urls(urls: [magnetUrl]);
    await _client.torrents.addNewTorrents(torrents: torrents);
  }

  Future<void> pause(String hash) async {
    await _client.torrents.pauseTorrents(torrents: Torrents(hashes: [hash]));
  }

  Future<void> resume(String hash) async {
    await _client.torrents.resumeTorrents(torrents: Torrents(hashes: [hash]));
  }

  Future<void> delete(String hash, {bool deleteFiles = false}) async {
    await _client.torrents.deleteTorrents(
      torrents: Torrents(hashes: [hash]),
      deleteFiles: deleteFiles,
    );
  }

  void dispose() {
    _subscription?.cancel();
    _client.auth.logout();
  }

  QBittorrentApiV2 get client => _client;
  bool get isInitialized => _initialized;
}
