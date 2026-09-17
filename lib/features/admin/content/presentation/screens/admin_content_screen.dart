import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/l10n/generated/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/subject_colors.dart';
import '../../../../../shared/widgets/app_badge.dart';
import '../../../../../shared/widgets/app_card.dart';
import '../../../../../shared/widgets/empty_state_widget.dart';
import '../../../../../shared/widgets/error_state_widget.dart';
import '../../../../../shared/widgets/loading_state_widget.dart';
import '../../data/content_repository.dart';
import '../../data/models/admin_lesson.dart';
import '../../data/models/admin_subject.dart';
import '../../data/models/admin_term.dart';
import '../../data/models/admin_unit.dart';
import '../../data/models/content_status.dart';
import '../../data/models/subject_display.dart';

/// Ecran admin "Gestion de contenu" : lecture seule de la hierarchie
/// Matiere -> Trimestre -> Unite -> Lecon, avec statut visible via
/// AppBadge. Aucune creation/edition/suppression a cette etape.
///
/// Chargement paresseux : chaque niveau (Term/Unit/Lesson) n'est fetch
/// qu'a la premiere ouverture de son parent (voir _expanded dans chaque
/// *Tile ci-dessous), pas au chargement initial de l'ecran.
class AdminContentScreen extends ConsumerWidget {
  const AdminContentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subjectsAsync = ref.watch(subjectsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminContentTitle)),
      body: subjectsAsync.when(
        loading: () => const LoadingStateWidget(),
        error: (error, _) => ErrorStateWidget(
          message: l10n.contentLoadError,
          onRetry: () => ref.invalidate(subjectsProvider),
        ),
        data: (subjects) {
          if (subjects.isEmpty) {
            return EmptyStateWidget(message: l10n.noSubjectsMessage);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: subjects.length,
            itemBuilder: (context, index) => _SubjectTile(subject: subjects[index]),
          );
        },
      ),
    );
  }
}

class _SubjectTile extends ConsumerStatefulWidget {
  const _SubjectTile({required this.subject});

  final AdminSubject subject;

  @override
  ConsumerState<_SubjectTile> createState() => _SubjectTileState();
}

class _SubjectTileState extends ConsumerState<_SubjectTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subjectId = subjectIdFromApiCode(widget.subject.code);
    final accentColor = subjectId?.color.accent ?? colors.primary;
    final lightBackground = subjectId?.color.lightBackground ?? colors.primarySoft;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: ExpansionTile(
          onExpansionChanged: (value) => setState(() => _expanded = value),
          leading: CircleAvatar(
            backgroundColor: lightBackground,
            foregroundColor: accentColor,
            child: Icon(subjectIconFromApiCode(widget.subject.code)),
          ),
          title: Text(widget.subject.nameFr),
          subtitle: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(widget.subject.nameAr, textAlign: TextAlign.start),
          ),
          children: [if (_expanded) _TermsSection(subjectId: widget.subject.id)],
        ),
      ),
    );
  }
}

class _TermsSection extends ConsumerWidget {
  const _TermsSection({required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final termsAsync = ref.watch(termsProvider(subjectId));

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: termsAsync.when(
        loading: () => const LoadingStateWidget(),
        error: (error, _) => ErrorStateWidget(
          message: l10n.contentLoadError,
          onRetry: () => ref.invalidate(termsProvider(subjectId)),
        ),
        data: (terms) {
          if (terms.isEmpty) {
            return EmptyStateWidget(message: l10n.noTermsMessage);
          }
          return Column(children: [for (final term in terms) _TermTile(term: term)]);
        },
      ),
    );
  }
}

class _TermTile extends ConsumerStatefulWidget {
  const _TermTile({required this.term});

  final AdminTerm term;

  @override
  ConsumerState<_TermTile> createState() => _TermTileState();
}

class _TermTileState extends ConsumerState<_TermTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        onExpansionChanged: (value) => setState(() => _expanded = value),
        title: Text(widget.term.nameFr),
        children: [if (_expanded) _UnitsSection(termId: widget.term.id)],
      ),
    );
  }
}

class _UnitsSection extends ConsumerWidget {
  const _UnitsSection({required this.termId});

  final String termId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unitsAsync = ref.watch(unitsProvider(termId));

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: unitsAsync.when(
        loading: () => const LoadingStateWidget(),
        error: (error, _) => ErrorStateWidget(
          message: l10n.contentLoadError,
          onRetry: () => ref.invalidate(unitsProvider(termId)),
        ),
        data: (units) {
          if (units.isEmpty) {
            return EmptyStateWidget(message: l10n.noUnitsMessage);
          }
          return Column(children: [for (final unit in units) _UnitTile(unit: unit)]);
        },
      ),
    );
  }
}

class _UnitTile extends ConsumerStatefulWidget {
  const _UnitTile({required this.unit});

  final AdminUnit unit;

  @override
  ConsumerState<_UnitTile> createState() => _UnitTileState();
}

class _UnitTileState extends ConsumerState<_UnitTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final (label, variant) = contentStatusBadge(l10n, widget.unit.status);
    final titleFr = widget.unit.titleFr;
    final titleAr = widget.unit.titleAr;

    // Pas de placeholder trompeur : si aucune traduction FR officielle
    // n'est encore disponible (title_fr null), on affiche le titre arabe
    // comme intitule principal (en RTL) et on le signale explicitement via
    // un badge, plutot que d'inventer ou de masquer l'absence de titre FR.
    final Widget titleWidget = titleFr != null
        ? Text(titleFr)
        : titleAr != null
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: Text(titleAr, textAlign: TextAlign.start),
          )
        : Text(
            l10n.titleFrUnavailable,
            style: TextStyle(color: colors.textDisabled, fontStyle: FontStyle.italic),
          );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        onExpansionChanged: (value) => setState(() => _expanded = value),
        title: Row(
          children: [
            Expanded(child: titleWidget),
            if (titleFr == null) ...[
              const SizedBox(width: 8),
              AppBadge(label: l10n.titleFrUnavailable, variant: AppBadgeVariant.warning),
            ],
            const SizedBox(width: 8),
            AppBadge(label: label, variant: variant),
          ],
        ),
        subtitle: (titleFr != null && titleAr != null)
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(titleAr, textAlign: TextAlign.start),
                ),
              )
            : null,
        children: [if (_expanded) _LessonsSection(unitId: widget.unit.id)],
      ),
    );
  }
}

class _LessonsSection extends ConsumerWidget {
  const _LessonsSection({required this.unitId});

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lessonsAsync = ref.watch(lessonsProvider(unitId));

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: lessonsAsync.when(
        loading: () => const LoadingStateWidget(),
        error: (error, _) => ErrorStateWidget(
          message: l10n.contentLoadError,
          onRetry: () => ref.invalidate(lessonsProvider(unitId)),
        ),
        data: (lessons) {
          if (lessons.isEmpty) {
            return EmptyStateWidget(message: l10n.noLessonsMessage);
          }
          return Column(children: [for (final lesson in lessons) _LessonRow(lesson: lesson)]);
        },
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  const _LessonRow({required this.lesson});

  final AdminLesson lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final (label, variant) = contentStatusBadge(l10n, lesson.status);
    final titleFr = lesson.titleFr;
    final titleAr = lesson.titleAr;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (titleFr != null) Text(titleFr),
                if (titleAr != null)
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      titleAr,
                      textAlign: TextAlign.start,
                      style: titleFr != null
                          ? TextStyle(color: colors.textSecondary, fontSize: 13)
                          : null,
                    ),
                  ),
                if (titleFr == null && titleAr == null)
                  Text('—', style: TextStyle(color: colors.textDisabled)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppBadge(label: label, variant: variant),
        ],
      ),
    );
  }
}
