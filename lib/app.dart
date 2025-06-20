import 'package:fluent_ui/fluent_ui.dart';
import 'package:flurrent/ui/screens/navigation_shell.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FluentApp(
      title: 'qBittorrent Fluent App',
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(brightness: Brightness.light),
      darkTheme: FluentThemeData(brightness: Brightness.dark),
      home: const NavigationShell(),
    );
  }
}
