import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/providers.dart';
import 'otp_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  String? _selectedRole;

  final List<String> _roles = [
    'Administrator',
    'Forest Officer',
    'Field Executive',
    'Department User',
    'Applicant',
    'Nodal Officer',
    'Member Secretary',
    'Public User'
  ];

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a user role')),
        );
        return;
      }

      // Step 1: Send OTP
      final success = await ref.read(authViewModelProvider.notifier).sendOtp(
            role: _selectedRole!,
            userId: _userIdController.text,
            password: _passwordController.text,
          );

      if (success && mounted) {
        // Navigate to OTP Screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTPScreen(userId: _userIdController.text),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient and Design
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryGreen.withOpacity(0.08),
                  Colors.white,
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.park,
                            size: 64, color: AppTheme.primaryGreen),
                      ),
                    ).animate().fadeIn().scale(),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to UTCMS',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                    ).animate().fadeIn(delay: 200.ms),
                    Text(
                      'Uarakhand Tree Compensation Management System',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 40),

                    // Role Selection
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Select User Role',
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      items: _roles.map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedRole = val),
                    ),
                    const SizedBox(height: 20),

                    // User ID
                    AppTextField(
                      labelText: 'User ID / Aadhaar / Email',
                      hintText: 'Enter your credentials',
                      controller: _userIdController,
                      prefixIcon: const Icon(Icons.account_circle_outlined),
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),

                    // Password
                    AppTextField(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_open_outlined),
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),

                    // CAPTCHA
                    _buildCaptchaUI(),
                    const SizedBox(height: 32),

                    // Action Button
                    AppButton(
                      text: 'SEND OTP',
                      isLoading: authState.isLoading,
                      onPressed: _onLogin,
                    ),

                    if (authState.error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        authState.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 13),
                      ),
                    ],

                    const SizedBox(height: 48),
                    const Text(
                      '© 2026 Environment Protection Agency, UK',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptchaUI() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Text(
              'X 9 4 L 2', // Mock CAPTCHA
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh, size: 20),
            color: AppTheme.primaryGreen,
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _captchaController,
              decoration: const InputDecoration(
                hintText: 'Result',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
