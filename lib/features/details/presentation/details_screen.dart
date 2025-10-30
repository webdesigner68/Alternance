import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/badges.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/html_description.dart';
import '../application/details_state_notifier.dart';

class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({required this.offerId, super.key});

  final String offerId;

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(detailsStateProvider(offerId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'offre'),
      ),
      body: _buildBody(context, state),
      bottomNavigationBar: state.job != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildApplyButton(context, state, ref),
              ),
            )
          : null,
    );
  }

  Widget _buildBody(BuildContext context, DetailsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.failure != null) {
      return ErrorView(failure: state.failure!);
    }

    if (state.job == null) {
      return const Center(child: Text('Offre non trouvée'));
    }

    final job = state.job!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.offer.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (job.identifier.partnerLabel != null)
            PartnerBadge(partner: job.identifier.partnerLabel!),
          const SizedBox(height: 16),
          if (job.workplace != null) ...[
            _buildSection(
              context,
              'Entreprise',
              [
                if (job.workplace!.name != null)
                  _buildInfoRow(Icons.business, job.workplace!.name!),
                if (job.workplace!.siret != null)
                  _buildInfoRow(Icons.badge, 'SIRET: ${job.workplace!.siret}'),
                if (job.workplace!.website != null)
                  InkWell(
                    onTap: () => _launchUrl(job.workplace!.website!),
                    child: _buildInfoRow(
                      Icons.language,
                      job.workplace!.website!,
                      isLink: true,
                    ),
                  ),
                if (job.workplace!.headcount != null)
                  _buildInfoRow(Icons.people, job.workplace!.headcount!),
                if (job.workplace!.sector != null)
                  _buildInfoRow(Icons.category, job.workplace!.sector!),
                if (job.workplace!.location?.city != null)
                  _buildInfoRow(
                    Icons.location_on,
                    '${job.workplace!.location!.city}'
                    '${job.workplace!.location!.postcode != null ? " (${job.workplace!.location!.postcode})" : ""}',
                  ),
              ],
            ),
          ],
          if (job.contract != null) ...[
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Contrat',
              [
                _buildInfoRow(Icons.work, job.contract!.type),
                if (job.contract!.startDate != null)
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Début: ${job.contract!.startDate}',
                  ),
                if (job.contract!.durationMonths != null)
                  _buildInfoRow(
                    Icons.timelapse,
                    'Durée: ${job.contract!.durationMonths} mois',
                  ),
                if (job.contract!.workMode != null)
                  WorkModeBadge(mode: job.contract!.workMode!),
              ],
            ),
          ],
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Description',
            [
              if (job.offer.description != null)
                HtmlDescription(htmlContent: job.offer.description!)
              else
                const Text('Aucune description disponible'),
            ],
          ),
          if (job.offer.desiredSkills != null &&
              job.offer.desiredSkills!.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Compétences attendues',
              job.offer.desiredSkills!
                  .map((skill) => _buildBulletPoint(skill))
                  .toList(),
            ),
          ],
          if (job.offer.toBeAcquiredSkills != null &&
              job.offer.toBeAcquiredSkills!.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Compétences à acquérir',
              job.offer.toBeAcquiredSkills!
                  .map((skill) => _buildBulletPoint(skill))
                  .toList(),
            ),
          ],
          if (job.offer.accessConditions != null) ...[
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Conditions d\'accès',
              [Text(job.offer.accessConditions!)],
            ),
          ],
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Informations complémentaires',
            [
              if (job.offer.positions != null)
                _buildInfoRow(
                  Icons.person_add,
                  'Postes: ${job.offer.positions}',
                ),
              if (job.offer.romes != null)
                _buildInfoRow(
                  Icons.code,
                  'ROME: ${job.offer.romes!.join(", ")}',
                ),
              if (job.offer.targetDiplomaLevel != null)
                DiplomaLevelBadge(level: job.offer.targetDiplomaLevel!),
              if (job.offer.status != null)
                _buildInfoRow(Icons.info, 'Statut: ${job.offer.status}'),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                decoration: isLink ? TextDecoration.underline : null,
                color: isLink ? Colors.blue : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildApplyButton(
    BuildContext context,
    DetailsState state,
    WidgetRef ref,
  ) {
    final job = state.job!;
    final repository = ref.watch(
      (ref) => ref.read((ref) => null),
    );

    if (job.apply?.recipientId != null) {
      return FilledButton.icon(
        onPressed: () => context.push('/apply/${job.identifier.id}'),
        icon: const Icon(Icons.send),
        label: const Text('Postuler en ligne'),
      );
    } else if (job.apply?.url != null) {
      return FilledButton.icon(
        onPressed: () async {
          final shouldOpen = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Ouvrir le navigateur'),
              content: const Text(
                'Vous allez être redirigé vers un site externe '
                'pour postuler.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Annuler'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Continuer'),
                ),
              ],
            ),
          );

          if (shouldOpen == true) {
            _launchUrl(job.apply!.url!);
          }
        },
        icon: const Icon(Icons.open_in_browser),
        label: const Text('Postuler (site externe)'),
      );
    }

    return const SizedBox.shrink();
  }
}
