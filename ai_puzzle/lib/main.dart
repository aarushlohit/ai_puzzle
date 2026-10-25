import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/models/puzzle_model.dart';
import 'data/repositories/puzzle_repository.dart';
import 'data/database/local_storage_service.dart';
import 'services/puzzle_ai_service.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_screen.dart';
import 'features/explore/explore_screen.dart';
import 'features/daily_challenge/daily_challenge_screen.dart';
import 'features/progress/progress_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/gameplay/level_select_screen.dart';
import 'features/gameplay/gameplay_screen.dart';
import 'features/visualizer/algorithm_visualizer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await LocalStorageService.init();
  final repository = PuzzleRepository();
  const aiService = PureAlgorithmicAIService();

  runApp(PuzzleverseApp(
    storage: storage,
    repository: repository,
    aiService: aiService,
  ));
}

class PuzzleverseApp extends StatefulWidget {
  final LocalStorageService storage;
  final PuzzleRepository repository;
  final PuzzleAIService aiService;

  const PuzzleverseApp({
    super.key,
    required this.storage,
    required this.repository,
    required this.aiService,
  });

  @override
  State<PuzzleverseApp> createState() => _PuzzleverseAppState();
}

class _PuzzleverseAppState extends State<PuzzleverseApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    final mode = widget.storage.themeMode;
    if (mode == 'light') {
      _themeMode = ThemeMode.light;
    } else if (mode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
  }

  void _onThemeChanged(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzleverse AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: MainNavigationShell(
        storage: widget.storage,
        repository: widget.repository,
        aiService: widget.aiService,
        onThemeChanged: _onThemeChanged,
      ),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  final LocalStorageService storage;
  final PuzzleRepository repository;
  final PuzzleAIService aiService;
  final Function(ThemeMode) onThemeChanged;

  const MainNavigationShell({
    super.key,
    required this.storage,
    required this.repository,
    required this.aiService,
    required this.onThemeChanged,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _showOnboarding = !widget.storage.isOnboardingCompleted;
  }

  void _finishOnboarding() {
    widget.storage.setOnboardingCompleted(true);
    setState(() => _showOnboarding = false);
  }

  void _navigateToPuzzle(PuzzleModel puzzle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameplayScreen(
          puzzle: puzzle,
          aiService: widget.aiService,
          storage: widget.storage,
          onExit: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _navigateToCategory(PuzzleCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LevelSelectScreen(
          category: category,
          repository: widget.repository,
          onSelectPuzzle: (puzzle) {
            Navigator.pop(context);
            _navigateToPuzzle(puzzle);
          },
        ),
      ),
    );
  }

  void _openVisualizer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AlgorithmVisualizerScreen(),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          key: const ValueKey('home_screen'),
          storage: widget.storage,
          onSelectCategory: _navigateToCategory,
          onDailyChallenge: () => setState(() => _currentIndex = 2),
          onOpenVisualizer: _openVisualizer,
        );
      case 1:
        return ExploreScreen(
          key: const ValueKey('explore_screen'),
          onSelectCategory: _navigateToCategory,
        );
      case 2:
        return DailyChallengeScreen(
          key: const ValueKey('daily_challenge_screen'),
          repository: widget.repository,
          onStartChallenge: _navigateToPuzzle,
        );
      case 3:
        return ProgressScreen(
          key: const ValueKey('progress_screen'),
          storage: widget.storage,
        );
      case 4:
      default:
        return SettingsScreen(
          key: const ValueKey('settings_screen'),
          storage: widget.storage,
          onThemeChanged: widget.onThemeChanged,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(onFinish: _finishOnboarding);
    }

    return Column(
      children: [
        Expanded(
          child: KeyedSubtree(
            key: ValueKey<int>(_currentIndex),
            child: _buildCurrentScreen(),
          ),
        ),
        NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.star_outline_rounded),
              selectedIcon: Icon(Icons.star_rounded),
              label: 'Daily',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_rounded),
              label: 'Progress',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ],
    );
  }
}
