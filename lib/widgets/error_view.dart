import 'package:flutter/material.dart';
import '../core/errors/failures.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.failure,
    this.onRetry,
    super.key,
  });

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIcon(),
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _getTitle(),
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getMessage(),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    return failure.when(
      network: (_, __, ___) => Icons.wifi_off,
      unauthorized: (_) => Icons.lock_outline,
      invalidResponse: (_, __, ___) => Icons.error_outline,
      validation: (_, __) => Icons.warning_amber_rounded,
      notFound: (_) => Icons.search_off,
      unknown: (_, __) => Icons.error_outline,
    );
  }

  String _getTitle() {
    return failure.when(
      network: (_, __, ___) => 'Erreur réseau',
      unauthorized: (_) => 'Non autorisé',
      invalidResponse: (_, __, ___) => 'Réponse invalide',
      validation: (_, __) => 'Erreur de validation',
      notFound: (_) => 'Non trouvé',
      unknown: (_, __) => 'Erreur',
    );
  }

  String _getMessage() {
    return failure.when(
      network: (msg, _, __) => msg,
      unauthorized: (msg) => msg,
      invalidResponse: (msg, _, __) => msg,
      validation: (msg, _) => msg,
      notFound: (msg) => msg,
      unknown: (msg, _) => msg,
    );
  }
}
