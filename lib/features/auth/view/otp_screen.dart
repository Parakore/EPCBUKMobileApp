import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_otp_field.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/providers.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String userId;

  const OTPScreen({super.key, required this.userId});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  String? _otp;
  int _timer = 60;
  Timer? _countdown;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer == 0) {
        setState(() => timer.cancel());
      } else {
        setState(() => _timer--);
      }
    });
  }

  @override
  void dispose() {
    _countdown?.cancel();
    super.dispose();
  }

  void _onVerify() async {
    if (_otp == null || _otp!.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    final success =
        await ref.read(authViewModelProvider.notifier).verifyOtp(_otp!);
    if (success && mounted) {
      context.go('/home/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.primaryGreen,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.security_outlined,
                      size: 64, color: AppTheme.primaryGreen),
                ),
              ).animate().fadeIn().scale(),
              const SizedBox(height: 24),
              Text(
                'Security Verification',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 8),
              Text(
                'A 6-digit OTP has been sent to your registered credentials ending with ****${widget.userId.substring(widget.userId.length - 4 > 0 ? widget.userId.length - 4 : 0)}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 48),

              // OTP Entry
              AppOTPField(
                length: 6,
                onCompleted: (otp) => setState(() => _otp = otp),
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 40),

              // Verify Button
              AppButton(
                text: 'VERIFY & LOGIN',
                isLoading: authState.isLoading,
                onPressed: _onVerify,
              ),

              const SizedBox(height: 24),

              // Resend Timer
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Didn\'t receive OTP? '),
                    if (_timer > 0)
                      Text(
                        'Resend in ${_timer}s',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen),
                      )
                    else
                      TextButton(
                        onPressed: () {
                          setState(() => _timer = 60);
                          _startTimer();
                          // Trigger resend logic
                        },
                        child: const Text('Resend Now'),
                      ),
                  ],
                ),
              ),

              if (authState.error != null) ...[
                const SizedBox(height: 16),
                Text(
                  authState.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
