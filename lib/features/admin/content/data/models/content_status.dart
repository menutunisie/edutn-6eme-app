import '../../../../../core/l10n/generated/app_localizations.dart';
import '../../../../../shared/widgets/app_badge.dart';

/// Miroir de `ValidationStatus` cote API (app/models/enums.py).
enum ContentStatus { draft, toReview, published, archived }

ContentStatus contentStatusFromApi(String value) => switch (value) {
  'brouillon' => ContentStatus.draft,
  'a_verifier' => ContentStatus.toReview,
  'publie' => ContentStatus.published,
  'archive' => ContentStatus.archived,
  _ => throw ArgumentError('Statut de contenu API inconnu: $value'),
};

/// Libelle + variante de badge, tels que specifies : Brouillon/À vérifier en
/// warning, Publié en success, Archivé en info.
(String, AppBadgeVariant) contentStatusBadge(AppLocalizations l10n, ContentStatus status) =>
    switch (status) {
      ContentStatus.draft => (l10n.statusDraft, AppBadgeVariant.warning),
      ContentStatus.toReview => (l10n.statusToReview, AppBadgeVariant.warning),
      ContentStatus.published => (l10n.statusPublished, AppBadgeVariant.success),
      ContentStatus.archived => (l10n.statusArchived, AppBadgeVariant.info),
    };
