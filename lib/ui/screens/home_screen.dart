import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:qbittorrent_api/qbittorrent_api.dart';
import '../../providers/theme_provider.dart';
import '../../providers/torrent_provider.dart';
import '../widgets/torrent_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<TorrentInfo> _filterTorrents(List<TorrentInfo> torrents, String group) {
    switch (group) {
      case 'downloading':
        return torrents
            .where(
              (t) =>
                  t.state == TorrentState.downloading ||
                  t.state == TorrentState.metaDL ||
                  t.state == TorrentState.stalledDL ||
                  t.progress! < 1.0,
            )
            .toList();

      case 'completed':
        return torrents
            .where(
              (t) =>
                  t.state == TorrentState.uploading ||
                  t.state == TorrentState.stalledUP ||
                  t.state == TorrentState.uploading ||
                  t.progress == 1.0,
            )
            .toList();

      default:
        return torrents;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TorrentProvider>();
    final theme = FluentTheme.of(context);
    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and theme toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(FluentIcons.download, size: 20),
                  const SizedBox(width: 8),
                  Text('Torrents', style: theme.typography.title),
                ],
              ),
              ToggleSwitch(
                checked:
                    context.watch<ThemeProvider>().themeMode == ThemeMode.dark,
                onChanged: (_) => context.read<ThemeProvider>().toggleTheme(),
                content: const Text('Dark Mode'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Add magnet card
          Card(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add New Magnet', style: theme.typography.subtitle),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextBox(
                        controller: controller,
                        placeholder: 'Paste magnet URL here...',
                        decoration: WidgetStateProperty.all(
                          BoxDecoration(borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      child: const Text('Add'),
                      onPressed: () async {
                        final url = controller.text.trim();
                        if (url.isNotEmpty) {
                          await provider.addMagnet(url);
                          controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Torrent list section
          Expanded(
            child:
                provider.isLoading
                    ? const Center(child: ProgressRing())
                    : provider.error.isNotEmpty
                    ? Center(
                      child: Text(
                        provider.error,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                    : provider.torrents.isEmpty
                    ? const Center(child: Text('No torrents available.'))
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_filterTorrents(
                          provider.torrents,
                          'downloading',
                        ).isNotEmpty) ...[
                          Row(
                            children: const [
                              Icon(FluentIcons.cloud_download),
                              SizedBox(width: 8),
                              Text(
                                'Downloading',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.separated(
                              itemCount:
                                  _filterTorrents(
                                    provider.torrents,
                                    'downloading',
                                  ).length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final torrent =
                                    _filterTorrents(
                                      provider.torrents,
                                      'downloading',
                                    )[index];
                                return TorrentCard(torrent: torrent);
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        if (_filterTorrents(
                          provider.torrents,
                          'completed',
                        ).isNotEmpty) ...[
                          Row(
                            children: const [
                              Icon(FluentIcons.completed),
                              SizedBox(width: 8),
                              Text(
                                'Completed',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.separated(
                              itemCount:
                                  _filterTorrents(
                                    provider.torrents,
                                    'completed',
                                  ).length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final torrent =
                                    _filterTorrents(
                                      provider.torrents,
                                      'completed',
                                    )[index];
                                return TorrentCard(torrent: torrent);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
