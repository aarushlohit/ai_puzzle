import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final LocalStorageService storage;
  final Function(ThemeMode) onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.storage,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _themeMode;
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.storage.themeMode;
  }

  void _changeTheme(String mode) {
    setState(() => _themeMode = mode);
    widget.storage.setThemeMode(mode);

    if (mode == 'light') {
      widget.onThemeChanged(ThemeMode.light);
    } else if (mode == 'dark') {
      widget.onThemeChanged(ThemeMode.dark);
    } else {
      widget.onThemeChanged(ThemeMode.system);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Theme Selection
          Text(
            'Appearance',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.accentPurple,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _themeOptionTile('system', 'System Default'),
                const Divider(height: 1),
                _themeOptionTile('light', 'Light Theme'),
                const Divider(height: 1),
                _themeOptionTile('dark', 'Dark Theme'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Toggles
          Text(
            'Experience & Feedback',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.accentPurple,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Sound Effects'),
                  subtitle: const Text('Tactile acoustic response'),
                  value: _soundEnabled,
                  onChanged: (v) => setState(() => _soundEnabled = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Haptic Vibration'),
                  subtitle: const Text('Tactile response on moves and buttons'),
                  value: _hapticsEnabled,
                  onChanged: (v) => setState(() => _hapticsEnabled = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Academic & AI Status
          Text(
            'AI Architecture & Solvers',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.accentPurple,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.hub_outlined, color: AppColors.accentPurple),
                      SizedBox(width: 8),
                      Text(
                        '100% Offline Intelligent Solvers',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All solvers (BFS, DFS, A*, IDA*, Recursive Backtracking) run purely on-device in pure Dart. No external cloud dependencies or API keys required.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Reset Progress
          OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  title: const Text('Reset All Progress?'),
                  content: const Text('This will reset your solved puzzles, streaks, and XP to 0.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await widget.storage.resetProgress();
                        if (dialogCtx.mounted) {
                          Navigator.pop(dialogCtx);
                        }
                        if (mounted) {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Progress has been reset.')),
                          );
                          setState(() {});
                        }
                      },
                      child: const Text('Reset', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error, width: 1.5),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                inherit: true,
              ),
            ),
            child: const Text('Reset Player Progress'),
          ),
        ],
      ),
    );
  }

  Widget _themeOptionTile(String value, String title) {
    final isSelected = _themeMode == value;
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.accentPurple) : null,
      onTap: () => _changeTheme(value),
    );
  }
}
