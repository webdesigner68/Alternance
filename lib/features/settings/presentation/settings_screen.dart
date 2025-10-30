import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/providers/app_providers.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isTestingHealth = false;
  String? _healthResult;

  Future<void> _testHealth() async {
    setState(() {
      _isTestingHealth = true;
      _healthResult = null;
    });

    try {
      final healthUseCase = ref.read(pingHealthUseCaseProvider);
      final health = await healthUseCase();

      setState(() {
        _healthResult = '✅ Service opérationnel\n'
            'Version: ${health.version ?? "N/A"}\n'
            'Env: ${health.env ?? "N/A"}';
        _isTestingHealth = false;
      });
    } catch (e) {
      setState(() {
        _healthResult = '❌ Service indisponible\n$e';
        _isTestingHealth = false;
      });
    }
  }

  Future<void> _clearAllData() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer toutes les données'),
        content: const Text(
          'Êtes-vous sûr de vouloir effacer toutes vos données ? '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );

    if (shouldClear == true && mounted) {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Données effacées')),
        );
        context.go('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final repository = ref.watch(jobRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text('Configurer la clé API'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/onboarding'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Thème'),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('Système'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Clair'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Sombre'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).state = value;
                }
              },
            ),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.warning_amber),
            title: const Text('Mode dégradé (Legacy)'),
            subtitle: const Text('Utiliser l\'API legacy'),
            value: repository.isLegacyMode,
            onChanged: (value) {
              repository.setLegacyMode(value);
              setState(() {});
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text('Test de santé API'),
            trailing: _isTestingHealth
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),
            onTap: _isTestingHealth ? null : _testHealth,
          ),
          if (_healthResult != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                color: _healthResult!.startsWith('✅')
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _healthResult!,
                    style: TextStyle(
                      color: _healthResult!.startsWith('✅')
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
            ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
            title: Text(
              'Effacer toutes les données',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: _clearAllData,
          ),
          const Divider(),
          const AboutListTile(
            icon: Icon(Icons.info),
            applicationName: 'La Bonne Alternance',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2025 Mission Apprentissage',
            aboutBoxChildren: [
              SizedBox(height: 16),
              Text(
                'Application Flutter pour rechercher des offres d\'alternance '
                'via l\'API La Bonne Alternance.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
