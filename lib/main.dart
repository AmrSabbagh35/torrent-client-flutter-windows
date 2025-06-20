import 'package:flurrent/providers/theme_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/torrent_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TorrentProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const App(),
    ),
  );
}
