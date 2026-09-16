import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/l10n/generated/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/models/user_role.dart';
import '../../../../../shared/widgets/app_badge.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../data/admin_user_repository.dart';
import '../../data/models/admin_user.dart';

final _adminUsersProvider = FutureProvider.autoDispose<List<AdminUser>>((ref) {
  return ref.watch(adminUserRepositoryProvider).listUsers();
});

/// Ecran minimal (ADMIN uniquement) : liste des utilisateurs + creation.
/// Pas de design final a ce stade, juste fonctionnel pour valider le flux.
class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final usersAsync = ref.watch(_adminUsersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminUsersTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateUserDialog(context, ref),
        icon: const Icon(Icons.person_add),
        label: Text(l10n.createUserButton),
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.loadErrorMessage(error.toString()))),
        data: (users) {
          if (users.isEmpty) {
            return Center(
              child: Text(l10n.noUsersMessage, style: TextStyle(color: colors.textTertiary)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: colors.primarySoft,
                  foregroundColor: colors.primaryHover,
                  child: Text(user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?'),
                ),
                title: Text(user.fullName),
                subtitle: Text('${user.email} · ${roleLabel(l10n, user.role)}'),
                trailing: user.isActive
                    ? AppBadge(
                        label: l10n.activeLabel,
                        variant: AppBadgeVariant.success,
                        icon: Icons.check_circle_outline,
                      )
                    : AppBadge(
                        label: l10n.inactiveLabel,
                        variant: AppBadgeVariant.error,
                        icon: Icons.cancel_outlined,
                      ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openCreateUserDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(context: context, builder: (context) => const _CreateUserDialog());
    ref.invalidate(_adminUsersProvider);
  }
}

class _CreateUserDialog extends ConsumerStatefulWidget {
  const _CreateUserDialog();

  @override
  ConsumerState<_CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends ConsumerState<_CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _role = UserRole.student;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(adminUserRepositoryProvider)
          .createUser(
            email: _emailController.text.trim(),
            fullName: _fullNameController.text.trim(),
            password: _passwordController.text,
            role: _role,
          );
      if (mounted) Navigator.of(context).pop();
    } on DioException catch (error) {
      setState(() {
        _errorMessage = error.response?.statusCode == 409
            ? l10n.duplicateEmailError
            : l10n.createUserError;
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return AlertDialog(
      title: Text(l10n.createUserDialogTitle),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: l10n.emailLabel),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    (value == null || !value.contains('@')) ? l10n.emailInvalid : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: l10n.fullNameLabel),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? l10n.fullNameRequired : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: l10n.temporaryPasswordLabel),
                obscureText: true,
                validator: (value) =>
                    (value == null || value.length < 8) ? l10n.passwordMinLength : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<UserRole>(
                initialValue: _role,
                decoration: InputDecoration(labelText: l10n.roleFieldLabel),
                items: UserRole.values
                    .map(
                      (role) => DropdownMenuItem(value: role, child: Text(roleLabel(l10n, role))),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _role = value ?? _role),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(_errorMessage!, style: TextStyle(color: colors.red)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancelButton),
        ),
        AppButton(
          label: l10n.createButton,
          isLoading: _isSubmitting,
          onPressed: _isSubmitting ? null : () => _submit(l10n),
        ),
      ],
    );
  }
}
