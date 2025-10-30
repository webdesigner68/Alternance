import 'package:flutter/material.dart';
import '../data/models/job.dart';
import 'badges.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    required this.job,
    this.onTap,
    super.key,
  });

  final Job job;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.offer.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (job.workplace?.name != null) ...[
                Text(
                  job.workplace!.name!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              if (job.workplace?.location?.city != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      job.workplace!.location!.city!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (job.contract?.type != null)
                    ContractTypeBadge(type: job.contract!.type),
                  if (job.contract?.workMode != null)
                    WorkModeBadge(mode: job.contract!.workMode!),
                  if (job.offer.targetDiplomaLevel != null)
                    DiplomaLevelBadge(level: job.offer.targetDiplomaLevel!),
                  PartnerBadge(
                    partner: job.identifier.partnerLabel ?? 'LBA',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
