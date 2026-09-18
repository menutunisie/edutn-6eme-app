import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/l10n/generated/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/app_badge.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/error_state_widget.dart';
import '../../../../../shared/widgets/loading_state_widget.dart';
import '../../data/content_repository.dart';
import '../../data/models/admin_lesson_detail.dart';
import '../../data/models/content_status.dart';
import '../../data/models/lesson_content_section.dart';

/// Detail (lecture seule) d'une Lesson : ses phases pedagogiques
/// (content_sections), dans l'ordre, une AppCard par phase. Pas d'edition
/// a cette etape.
class AdminLessonDetailScreen extends ConsumerWidget {
  const AdminLessonDetailScreen({required this.lessonId, super.key});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(lessonDetailProvider(lessonId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          detailAsync.valueOrNull?.titleFr ??
              detailAsync.valueOrNull?.titleAr ??
              l10n.adminContentTitle,
        ),
      ),
      body: detailAsync.when(
        loading: () => const LoadingStateWidget(),
        error: (error, _) => ErrorStateWidget(
          message: l10n.contentLoadError,
          onRetry: () => ref.invalidate(lessonDetailProvider(lessonId)),
        ),
        data: (lesson) => _LessonDetailBody(lesson: lesson),
      ),
    );
  }
}

class _LessonDetailBody extends StatelessWidget {
  const _LessonDetailBody({required this.lesson});

  final AdminLessonDetail lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final sections = [...?lesson.contentSections]..sort((a, b) => a.order.compareTo(b.order));
    final (statusLabel, statusVariant) = contentStatusBadge(l10n, lesson.status);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  lesson.titleAr ?? '—',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AppBadge(label: statusLabel, variant: statusVariant),
          ],
        ),
        if (lesson.descriptionShort != null) ...[
          const SizedBox(height: 8),
          Text(
            lesson.descriptionShort!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.textTertiary),
          ),
        ],
        const SizedBox(height: 20),
        if (sections.isEmpty)
          EmptyStateWidget(message: l10n.noContentSectionsMessage)
        else
          for (final section in sections) ...[
            _SectionCard(section: section),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final LessonContentSection section;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${section.order} · ${section.phaseKey}',
                  style: TextStyle(
                    color: colors.textTertiary,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              section.titleAr,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (section.titleFr != null) ...[
            const SizedBox(height: 2),
            Text(
              section.titleFr!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.textTertiary),
            ),
          ],
          const SizedBox(height: 10),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              section.bodyAr,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          if (section.bodyFr != null) ...[
            const SizedBox(height: 6),
            Text(section.bodyFr!, style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (section.mediaNote != null) ...[
            const SizedBox(height: 12),
            _MediaNotePlaceholder(note: section.mediaNote!),
          ],
        ],
      ),
    );
  }
}

/// Encart clairement distinct d'un vrai visuel : bordure pointillee + icone
/// image + libelle explicite "Schéma à intégrer", pour ne jamais laisser
/// croire qu'un asset existe deja.
class _MediaNotePlaceholder extends StatelessWidget {
  const _MediaNotePlaceholder({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return CustomPaint(
      painter: _DashedBorderPainter(color: colors.borderStrong),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.image_outlined, color: colors.textTertiary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mediaPlaceholderLabel,
                    style: TextStyle(fontWeight: FontWeight.w600, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(note, style: TextStyle(color: colors.textTertiary, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(6),
    );
    final path = Path()..addRRect(rrect);
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => oldDelegate.color != color;
}
