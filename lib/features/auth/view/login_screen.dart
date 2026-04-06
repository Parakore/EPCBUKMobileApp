import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../providers/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;

  final List<String> _roles = [
    'Administrator',
    'Forest Officer',
    'Field Executive',
    'Department User'
  ];

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authViewModelProvider.notifier).login(
            role: _selectedRole!,
            userId: _userIdController.text,
            password: _passwordController.text,
          );

      if (success && mounted) {
        context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // Logo Placeholder
                  const Icon(Icons.forest, size: 80, color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    'EPCBUK Mobile App',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Environment Management System',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 48),

                  // Role Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    hint: const Text('Select User Role'),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_outlined),
                    ),
                    items: _roles.map((role) {
                      return DropdownMenuItem(value: role, child: Text(role));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedRole = val),
                    validator: (val) =>
                        val == null ? 'Please select a role' : null,
                  ),
                  const SizedBox(height: 16),

                  // User ID
                  AppTextField(
                    labelText: 'User ID / Aadhaar',
                    hintText: 'Enter your ID',
                    controller: _userIdController,
                    prefixIcon: const Icon(Icons.badge_outlined),
                    validator: (val) =>
                        val!.isEmpty ? 'User ID is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  AppTextField(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (val) =>
                        val!.isEmpty ? 'Password is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // CAPTCHA Placeholder
                  _buildCaptchaUI(),
                  const SizedBox(height: 24),

                  // Login Button
                  AppButton(
                    text: 'Verify & Get OTP',
                    isLoading: authState.isLoading,
                    onPressed: _onLogin,
                  ),

                  if (authState.error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      authState.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],

                  const SizedBox(height: 40),
                  Text(
                    '© 2026 Environment Protection Agency',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaptchaUI() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '8 + 5 = ?', // Simple math captcha mock
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const SizedBox(
            width: 80,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Result',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
