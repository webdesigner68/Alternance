import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_config.dart';
import '../../../core/providers/app_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _apiKeyController = TextEditingController();
  bool _useAuthorizationHeader = false;
  bool _isTestingKey = false;
  String? _testResult;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _testApiKey() async {
    setState(() {
      _isTestingKey = true;
      _testResult = null;
    });

    try {
      final config = await ref.read(appConfigProvider.future);
      await config.updateApiKey(_apiKeyController.text);
      await config.updateAuthHeaderType(_useAuthorizationHeader);

      // Test with health check
      final healthUseCase = ref.read(pingHealthUseCaseProvider);
      final health = await healthUseCase();

      setState(() {
        _testResult = '✅ Clé API valide ! Version: ${health.version ?? "N/A"}';
        _isTestingKey = false;
      });

      // Navigate to search after 1 second
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.go('/search');
      }
    } catch (e) {
      setState(() {
        _testResult = '❌ Clé invalide ou service indisponible.\n'
            'Vérifiez votre clé ou contactez le support.';
        _isTestingKey = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission localisation accordée')),
      );
    }
  }

  Future<void> _openApiDocumentation() async {
    final uri = Uri.parse('https://mission-apprentissage.gitbook.io/api/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.work_outline,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'La Bonne Alternance',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Recherchez des offres d\'alternance',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              'Clé API',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'Votre clé API',
                hintText: 'Collez votre clé API ici',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.key),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Utiliser Authorization: Api-Key'),
              subtitle: const Text('Décochez pour X-Api-Key'),
              value: _useAuthorizationHeader,
              onChanged: (value) {
                setState(() {
                  _useAuthorizationHeader = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isTestingKey ? null : _testApiKey,
              icon: _isTestingKey
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle),
              label: const Text('Tester la clé'),
            ),
            if (_testResult != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _testResult!.startsWith('✅')
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _testResult!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _testResult!.startsWith('✅')
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _openApiDocumentation,
              icon: const Icon(Icons.help_outline),
              label: const Text('Comment obtenir une clé API ?'),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Permissions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Localisation'),
              subtitle: const Text('Pour rechercher autour de vous'),
              trailing: TextButton(
                onPressed: _requestLocationPermission,
                child: const Text('Autoriser'),
              ),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.go('/search'),
              child: const Text('Passer cette étape'),
            ),
          ],
        ),
      ),
    );
  }
}
