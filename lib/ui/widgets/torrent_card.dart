import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:qbittorrent_api/qbittorrent_api.dart';
import '../../../providers/torrent_provider.dart';

class TorrentCard extends StatelessWidget {
  final TorrentInfo torrent;

  const TorrentCard({super.key, required this.torrent});

  String _formatSpeed(int bytesPerSec) {
    if (bytesPerSec >= 1024 * 1024) {
      return '${(bytesPerSec / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    } else if (bytesPerSec >= 1024) {
      return '${(bytesPerSec / 1024).toStringAsFixed(1)} KB/s';
    } else {
      return '$bytesPerSec B/s';
    }
  }

  String _formatEta(int seconds) {
    if (seconds <= 0) return '∞';
    final d = Duration(seconds: seconds);
    return '${d.inHours}h ${d.inMinutes % 60}m ${d.inSeconds % 60}s';
  }

  String _formatProgress(double progress) =>
      '${(progress * 100).toStringAsFixed(1)}%';

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TorrentProvider>();
    final theme = FluentTheme.of(context);
    final hash = torrent.hash;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Torrent Name
            Text(torrent.name ?? 'Unnamed', style: theme.typography.subtitle),
            const SizedBox(height: 10),

            /// Progress Bar
            ProgressBar(
              value: torrent.progress ?? 0.0,
              backgroundColor: theme.resources.controlFillColorSecondary,
            ),
            const SizedBox(height: 10),

            /// Torrent Info
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                _infoLabel(
                  "Status",
                  torrent.state?.toString().toUpperCase() ?? 'Unknown',
                ),
                _infoLabel(
                  "Progress",
                  _formatProgress(torrent.progress ?? 0.0),
                ),
                _infoLabel("ETA", _formatEta(torrent.eta ?? 0)),
                _infoLabel(
                  "Speed",
                  '⬇ ${_formatSpeed(torrent.dlSpeed ?? 0)} / ⬆ ${_formatSpeed(torrent.upSpeed ?? 0)}',
                ),
                _infoLabel(
                  "Ratio",
                  torrent.ratio?.toStringAsFixed(2) ?? "0.00",
                ),
                _infoLabel("Category", torrent.category ?? "None"),
              ],
            ),

            const SizedBox(height: 12),

            /// Action Buttons
            CommandBar(
              primaryItems: [
                CommandBarButton(
                  icon: const Icon(FluentIcons.pause),
                  onPressed: () => provider.pauseTorrent(hash!),
                  label: const Text('Pause'),
                ),
                CommandBarButton(
                  icon: const Icon(FluentIcons.play),
                  onPressed: () => provider.resumeTorrent(hash!),
                  label: const Text('Resume'),
                ),
                CommandBarButton(
                  icon: const Icon(FluentIcons.delete),
                  onPressed: () => provider.deleteTorrent(hash!),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Button(
        style: ButtonStyle(
          padding: ButtonState.all(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          backgroundColor: ButtonState.resolveWith((states) {
            final theme = FluentTheme.of(context);
            if (states.isDisabled) return null;
            if (states.isPressed) return theme.accentColor.darker;
            if (states.isHovering) return theme.accentColor.lighter;
            return theme.accentColor;
          }),
          foregroundColor: ButtonState.all(Colors.white),
          elevation: ButtonState.all(2.0),
          shape: ButtonState.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        child: Icon(icon, size: 16),
        onPressed: onPressed,
      ),
    );
  }

  Widget _infoLabel(String label, String value) {
    return InfoLabel(label: label, child: Text(value));
  }
}
