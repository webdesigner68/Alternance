import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/models/search_criteria.dart';
import '../../../widgets/offer_card.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/skeleton_loading.dart';
import '../../../widgets/badges.dart';
import '../../../core/providers/app_providers.dart';
import '../application/search_state_notifier.dart';
import 'widgets/filter_bottom_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger initial search
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchNearMe();
    });
  }

  Future<void> _searchNearMe() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _searchFranceWide();
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final criteria = SearchCriteria(
        latitude: position.latitude,
        longitude: position.longitude,
        radius: 30,
      );
      ref.read(searchStateProvider.notifier).search(criteria);
    } catch (e) {
      _searchFranceWide();
    }
  }

  void _searchFranceWide() {
    final criteria = const SearchCriteria();
    ref.read(searchStateProvider.notifier).search(criteria);
  }

  void _showFilters() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchStateProvider);
    final repository = ref.watch(jobRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche d\'alternances'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
            tooltip: 'Filtres',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: 'Paramètres',
          ),
        ],
      ),
      body: Column(
        children: [
          if (repository.isLegacyMode) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Row(
                children: [
                  const LegacyModeBadge(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Données limitées. Configurez votre clé API v2.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/onboarding'),
                    child: const Text('Configurer'),
                  ),
                ],
              ),
            ),
          ],
          if (state.response?.warnings != null &&
              state.response!.warnings!.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Text(
                state.response!.warnings!.join('\n'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
          Expanded(
            child: _buildBody(state),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _searchNearMe,
        icon: const Icon(Icons.my_location),
        label: const Text('Autour de moi'),
      ),
    );
  }

  Widget _buildBody(SearchState state) {
    if (state.isLoading) {
      return const SkeletonList();
    }

    if (state.failure != null) {
      return ErrorView(
        failure: state.failure!,
        onRetry: _searchNearMe,
      );
    }

    if (state.response == null || state.response!.jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune offre trouvée',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Essayez de modifier vos critères de recherche',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _searchNearMe(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.response!.jobs.length,
        itemBuilder: (context, index) {
          final job = state.response!.jobs[index];
          return OfferCard(
            job: job,
            onTap: () => context.push('/offer/${job.identifier.id}'),
          );
        },
      ),
    );
  }
}
