import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/search_criteria.dart';
import '../../application/search_state_notifier.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late int _radius;
  String? _targetDiplomaLevel;

  @override
  void initState() {
    super.initState();
    final currentCriteria = ref.read(searchStateProvider).criteria;
    _radius = currentCriteria.radius;
    _targetDiplomaLevel = currentCriteria.targetDiplomaLevel;
  }

  void _applyFilters() {
    final currentCriteria = ref.read(searchStateProvider).criteria;
    final newCriteria = SearchCriteria(
      latitude: currentCriteria.latitude,
      longitude: currentCriteria.longitude,
      radius: _radius,
      targetDiplomaLevel: _targetDiplomaLevel,
      romes: currentCriteria.romes,
      rncp: currentCriteria.rncp,
      opco: currentCriteria.opco,
      departements: currentCriteria.departements,
      partnersToExclude: currentCriteria.partnersToExclude,
    );

    ref.read(searchStateProvider.notifier).search(newCriteria);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtres',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      'Rayon de recherche',
                      style: theme.textTheme.titleMedium,
                    ),
                    Slider(
                      value: _radius.toDouble(),
                      min: 0,
                      max: 200,
                      divisions: 40,
                      label: '$_radius km',
                      onChanged: (value) {
                        setState(() {
                          _radius = value.toInt();
                        });
                      },
                    ),
                    Text(
                      '$_radius km',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Niveau de diplôme',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String?>(
                      value: _targetDiplomaLevel,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Sélectionner un niveau',
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Tous')),
                        DropdownMenuItem(value: '3', child: Text('CAP/BEP')),
                        DropdownMenuItem(value: '4', child: Text('Bac')),
                        DropdownMenuItem(value: '5', child: Text('Bac+2')),
                        DropdownMenuItem(value: '6', child: Text('Bac+3/4')),
                        DropdownMenuItem(value: '7', child: Text('Bac+5')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _targetDiplomaLevel = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _applyFilters,
                child: const Text('Appliquer les filtres'),
              ),
            ],
          ),
        );
      },
    );
  }
}
