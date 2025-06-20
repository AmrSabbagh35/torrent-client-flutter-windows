import 'package:fluent_ui/fluent_ui.dart';
import 'package:flurrent/ui/screens/home_screen.dart';
import 'package:flurrent/ui/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int index = 0;

  final pages = const [HomeScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text('Flurrent — qBittorrent Client'),
        leading: SizedBox(),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (i) => setState(() => index = i),
        displayMode: PaneDisplayMode.auto,
        items: [
          PaneItem(
            icon: Icon(FluentIcons.download),
            title: Text('Torrents'),
            body: HomeScreen(),
          ),
          PaneItem(
            icon: Icon(FluentIcons.settings),
            title: Text('Settings'),
            body: SettingsScreen(),
          ),
        ],
      ),
    );
  }
}
