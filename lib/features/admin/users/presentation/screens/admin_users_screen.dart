import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/models/user_role.dart';
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
    final usersAsync = ref.watch(_adminUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des utilisateurs')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateUserDialog(context, ref),
        icon: const Icon(Icons.person_add),
        label: const Text('Créer un utilisateur'),
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur de chargement : $error')),
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('Aucun utilisateur pour le moment.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?'),
                ),
                title: Text(user.fullName),
                subtitle: Text('${user.email} · ${user.role.label}'),
                trailing: Icon(
                  user.isActive ? Icons.check_circle : Icons.cancel,
                  color: user.isActive ? Colors.green : Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openCreateUserDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const _CreateUserDialog(),
    );
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

  Future<void> _submit() async {
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
            ? 'Cet email est déjà utilisé.'
            : "Impossible de créer l'utilisateur.";
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Créer un utilisateur'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => (value == null || !value.contains('@'))
                    ? 'Email invalide'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Nom complet'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Nom requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mot de passe provisoire'),
                obscureText: true,
                validator: (value) =>
                    (value == null || value.length < 8) ? '8 caractères minimum' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<UserRole>(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Rôle'),
                items: UserRole.values
                    .map((role) => DropdownMenuItem(value: role, child: Text(role.label)))
                    .toList(),
                onChanged: (value) => setState(() => _role = value ?? _role),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Créer'),
        ),
      ],
    );
  }
}
