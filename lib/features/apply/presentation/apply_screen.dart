import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/apply_request.dart';
import '../application/apply_state_notifier.dart';
import '../../details/application/details_state_notifier.dart';

class ApplyScreen extends ConsumerStatefulWidget {
  const ApplyScreen({required this.offerId, super.key});

  final String offerId;

  @override
  ConsumerState<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends ConsumerState<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  File? _cvFile;
  String? _cvFileName;
  String? _cvBase64;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _clearSensitiveData();
    super.dispose();
  }

  void _clearSensitiveData() {
    _cvFile = null;
    _cvFileName = null;
    _cvBase64 = null;
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _messageController.clear();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final bytes = await file.readAsBytes();
        final base64 = base64Encode(bytes);

        setState(() {
          _cvFile = file;
          _cvFileName = result.files.single.name;
          _cvBase64 = base64;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sélection du fichier: $e')),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_cvBase64 == null || _cvFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un CV')),
      );
      return;
    }

    final detailsState = ref.read(detailsStateProvider(widget.offerId));
    final recipientId = detailsState.job?.apply?.recipientId;

    if (recipientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de postuler: informations manquantes'),
        ),
      );
      return;
    }

    final request = ApplyRequest(
      applicantFirstName: _firstNameController.text.trim(),
      applicantLastName: _lastNameController.text.trim(),
      applicantEmail: _emailController.text.trim(),
      applicantPhone: _phoneController.text.trim(),
      applicantAttachmentName: _cvFileName!,
      applicantAttachmentContent: _cvBase64!,
      recipientId: recipientId,
      applicantMessage: _messageController.text.trim().isNotEmpty
          ? _messageController.text.trim()
          : null,
    );

    await ref.read(applyStateProvider.notifier).submit(request);
  }

  @override
  Widget build(BuildContext context) {
    final applyState = ref.watch(applyStateProvider);
    final theme = Theme.of(context);

    ref.listen<ApplyState>(applyStateProvider, (previous, next) {
      if (next.isSuccess) {
        _clearSensitiveData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Candidature envoyée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            context.go('/search');
          }
        });
      } else if (next.failure != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur: ${next.failure!.when(
                    network: (msg, _, __) => msg,
                    unauthorized: (msg) => msg,
                    invalidResponse: (msg, _, __) => msg,
                    validation: (msg, _) => msg,
                    notFound: (msg) => msg,
                    unknown: (msg, _) => msg,
                  )}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Postuler'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Informations personnelles',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Prénom *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    Validators.validateName(value, fieldName: 'Prénom'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    Validators.validateName(value, fieldName: 'Nom'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: Validators.validateEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: Validators.validatePhone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),
              Text(
                'CV',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text(_cvFileName ?? 'Sélectionner un CV (PDF, DOC)'),
              ),
              if (_cvFileName != null) ...[
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.description),
                    title: Text(_cvFileName!),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _cvFile = null;
                          _cvFileName = null;
                          _cvBase64 = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'Message (optionnel)',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Votre message',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: applyState.isSubmitting ? null : _submit,
                icon: applyState.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: const Text('Envoyer ma candidature'),
              ),
              const SizedBox(height: 16),
              Text(
                '* Champs obligatoires\n\n'
                'Vos données seront supprimées après l\'envoi.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
