import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../viewmodel/settings_viewmodel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsViewModelProvider);
    final viewModel = ref.read(settingsViewModelProvider.notifier);

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(16),
      children: [
        Text('Workflow Settings (Days)',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen)),
        const SizedBox(height: 12),
        _buildSlaGrid(settings, viewModel),
        const SizedBox(height: 16),
        Text('Notification Settings',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen)),
        _buildNotificationToggles(settings, viewModel),
        const SizedBox(height: 16),
        AppButton(
          text: 'Save Configuration',
          onPressed: viewModel.saveSettings,
        ),
      ],
    );
  }

  Widget _buildSlaGrid(settings, viewModel) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'Forest Guard',
                hintText: 'e.g. 3',
                keyboardType: TextInputType.number,
                onChanged: viewModel.setSlaGuard,
                controller:
                    TextEditingController(text: settings.slaGuard.toString()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'Range Officer',
                hintText: 'e.g. 5',
                keyboardType: TextInputType.number,
                onChanged: viewModel.setSlaRO,
                controller:
                    TextEditingController(text: settings.slaRO.toString()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'DFO Office',
                hintText: 'e.g. 7',
                keyboardType: TextInputType.number,
                onChanged: viewModel.setSlaDFO,
                controller:
                    TextEditingController(text: settings.slaDFO.toString()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'District Magistrate',
                hintText: 'e.g. 10',
                keyboardType: TextInputType.number,
                onChanged: viewModel.setSlaDM,
                controller:
                    TextEditingController(text: settings.slaDM.toString()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          labelText: 'Treasury/Financial',
          hintText: 'e.g. 2',
          keyboardType: TextInputType.number,
          onChanged: viewModel.setSlaTreasury,
          controller:
              TextEditingController(text: settings.slaTreasury.toString()),
        ),
      ],
    );
  }

  Widget _buildNotificationToggles(settings, viewModel) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title:
                const Text('SMS Notifications', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Send SMS alerts for critical updates',
                style: TextStyle(fontSize: 11)),
            value: settings.enableSMS,
            onChanged: viewModel.toggleSMS,
            activeColor: AppTheme.primaryGreen,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Email Alerts', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Send detailed reports via email',
                style: TextStyle(fontSize: 11)),
            value: settings.enableEmail,
            onChanged: viewModel.toggleEmail,
            activeColor: AppTheme.primaryGreen,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('WhatsApp Integration',
                style: TextStyle(fontSize: 14)),
            subtitle: const Text('Direct messaging for real-time tracking',
                style: TextStyle(fontSize: 11)),
            value: settings.enableWhatsApp,
            onChanged: viewModel.toggleWhatsApp,
            activeColor: AppTheme.primaryGreen,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('SLA Breach Warnings',
                style: TextStyle(fontSize: 14)),
            subtitle: const Text('Automated alerts for pending tasks',
                style: TextStyle(fontSize: 11)),
            value: settings.enableSLABreachAlert,
            onChanged: viewModel.toggleSLABreachAlert,
            activeColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
