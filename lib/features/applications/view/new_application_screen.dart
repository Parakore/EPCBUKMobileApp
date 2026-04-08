import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_section_header.dart';
import '../../../core/widgets/app_dropdown_field.dart';
import '../../../core/widgets/app_upload_field.dart';
import '../../../core/widgets/app_detail_row.dart';
import '../../../core/widgets/glass_card.dart';
import '../viewmodel/new_application_viewmodel.dart';
import '../model/new_application_state.dart';

class NewApplicationScreen extends ConsumerStatefulWidget {
  const NewApplicationScreen({super.key});

  @override
  ConsumerState<NewApplicationScreen> createState() => _NewApplicationScreenState();
}

class _NewApplicationScreenState extends ConsumerState<NewApplicationScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStepTapped(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    ref.read(newApplicationViewModelProvider.notifier).setStep(step);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newApplicationViewModelProvider);
    final viewModel = ref.read(newApplicationViewModelProvider.notifier);

    // Sync page controller with state if needed (e.g. on external state change)
    if (_pageController.hasClients && _pageController.page?.round() != state.currentStep) {
      _pageController.animateToPage(
        state.currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return Scaffold(
      appBar: const AppAppBar(title: 'New Application'),
      body: Column(
        children: [
          _StepIndicator(
            currentStep: state.currentStep,
            onStepTapped: _onStepTapped,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _PersonalDetailsStep(state: state, viewModel: viewModel),
                _LandDetailsStep(state: state, viewModel: viewModel),
                _TreeDetailsStep(state: state, viewModel: viewModel),
                _DocumentsStep(state: state, viewModel: viewModel),
                _ReviewStep(state: state, viewModel: viewModel),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomActions(
        state: state,
        onBack: viewModel.prevStep,
        onNext: viewModel.nextStep,
        onSubmit: () async {
          await viewModel.submitApplication();
          if (context.mounted) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Application submitted successfully!')),
            );
          }
        },
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final Function(int) onStepTapped;

  const _StepIndicator({required this.currentStep, required this.onStepTapped});

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Personal',
      'Land',
      'Trees',
      'Docs',
      'Review',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(steps.length, (index) {
          final isActive = index <= currentStep;
          final isCurrent = index == currentStep;

          return GestureDetector(
            onTap: () => onStepTapped(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppTheme.forestGreen
                        : (isActive ? AppTheme.forestGreen.withValues(alpha: 0.2) : Colors.grey[200]),
                    shape: BoxShape.circle,
                    border: isCurrent ? Border.all(color: AppTheme.forestGreen, width: 2) : null,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrent ? Colors.white : (isActive ? AppTheme.forestGreen : Colors.grey[500]),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  steps[index],
                  style: TextStyle(
                    fontSize: 10,
                    color: isCurrent ? AppTheme.forestGreen : Colors.grey[500],
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _PersonalDetailsStep extends StatelessWidget {
  final NewApplicationState state;
  final NewApplicationViewModel viewModel;

  const _PersonalDetailsStep({required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const AppSectionHeader(icon: Icons.person, title: 'Personal / Project Details'),
        const SizedBox(height: 20),
        AppDropdownField<String>(
          label: 'Applicant Type',
          value: state.applicantDetails.type,
          items: const [
            'Individual / Citizen',
            'Government Project',
            'Private Organization',
            'PSU / Utility'
          ],
          itemLabelBuilder: (val) => val,
          onChanged: (val) => viewModel.updateApplicantField(type: val!),
        ),
        const SizedBox(height: 16),
        AppTextField(
          labelText: 'Full Name / Organization',
          hintText: 'Enter full name or organization',
          onChanged: (val) => viewModel.updateApplicantField(fullName: val),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'Aadhaar Number',
                hintText: '12-digit Aadhaar',
                keyboardType: TextInputType.number,
                onChanged: (val) => viewModel.updateApplicantField(aadhaar: val),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: AppButton(
                text: 'Verify',
                variant: ButtonVariant.outline,
                onPressed: () => viewModel.simulateAadhaarVerify(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          labelText: 'Mobile Number',
          hintText: '+91 XXXXXXXXXX',
          keyboardType: TextInputType.phone,
          onChanged: (val) => viewModel.updateApplicantField(mobile: val),
        ),
        const SizedBox(height: 16),
        AppTextField(
          labelText: 'Email Address',
          hintText: 'email@example.com',
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) => viewModel.updateApplicantField(email: val),
        ),
        const SizedBox(height: 16),
        AppDropdownField<String>(
          label: 'Purpose of Cutting',
          value: state.applicantDetails.purpose,
          items: const [
            'Road/Highway Construction',
            'Irrigation/Dam Project',
            'Building Construction',
            'Power Line/Utility',
            'Agricultural Clearing',
            'Storm/Disaster (Tree Fallen)',
            'Other',
          ],
          itemLabelBuilder: (val) => val,
          onChanged: (val) => viewModel.updateApplicantField(purpose: val!),
        ),
      ],
    );
  }
}

class _LandDetailsStep extends StatelessWidget {
  final NewApplicationState state;
  final NewApplicationViewModel viewModel;

  const _LandDetailsStep({required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const AppSectionHeader(icon: Icons.map, title: 'Land & Location Details'),
        const SizedBox(height: 20),
        AppDropdownField<String>(
          label: 'District',
          value: state.landDetails.district,
          items: const [
            'Dehradun',
            'Haridwar',
            'Pauri Garhwal',
            'Tehri Garhwal',
            'Uttarkashi',
            'Chamoli',
            'Nainital',
          ],
          itemLabelBuilder: (val) => val,
          onChanged: (val) => viewModel.updateLandField(district: val!),
        ),
        const SizedBox(height: 16),
        AppTextField(
          labelText: 'Block / Tehsil',
          onChanged: (val) => viewModel.updateLandField(block: val),
        ),
        const SizedBox(height: 16),
        AppTextField(
          labelText: 'Village / Location',
          onChanged: (val) => viewModel.updateLandField(village: val),
        ),
        const SizedBox(height: 16),
        AppTextField(
          labelText: 'Khasra / Survey Number',
          onChanged: (val) => viewModel.updateLandField(khasra: val),
        ),
        const SizedBox(height: 16),
        AppDropdownField<String>(
          label: 'Land Type',
          value: state.landDetails.landType,
          items: const [
            'Private Land',
            'Revenue Land',
            'Forest Land',
            'Protected Forest',
            'Road/Government Land'
          ],
          itemLabelBuilder: (val) => val,
          onChanged: (val) => viewModel.updateLandField(landType: val!),
        ),
        const SizedBox(height: 16),
        AppTextField(
          labelText: 'Area (in hectares)',
          keyboardType: TextInputType.number,
          onChanged: (val) => viewModel.updateLandField(area: double.tryParse(val)),
        ),
        const SizedBox(height: 24),
        const Text(
          'GPS Coordinates',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.forestGreen),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'Latitude',
                hintText: state.landDetails.latitude?.toString() ?? 'e.g. 30.3165',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'Longitude',
                hintText: state.landDetails.longitude?.toString() ?? 'e.g. 78.0322',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppButton(
          text: 'Auto Capture GPS',
          icon: const Icon(Icons.location_searching),
          variant: ButtonVariant.outline,
          onPressed: () => viewModel.simulateGPSCapture(),
        ),
      ],
    );
  }
}

class _TreeDetailsStep extends StatelessWidget {
  final NewApplicationState state;
  final NewApplicationViewModel viewModel;

  const _TreeDetailsStep({required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppSectionHeader(icon: Icons.park, title: 'Tree Details'),
            TextButton.icon(
              onPressed: viewModel.addTree,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Tree'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...state.trees.asMap().entries.map((entry) {
          final index = entry.key;
          final tree = entry.value;
          return _TreeItemCard(
            index: index,
            tree: tree,
            onUpdate: (newTree) => viewModel.updateTree(index, newTree),
            onRemove: () => viewModel.removeTree(index),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _DocumentsStep extends StatelessWidget {
  final NewApplicationState state;
  final NewApplicationViewModel viewModel;

  const _DocumentsStep({required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const AppSectionHeader(icon: Icons.file_present, title: 'Document Upload'),
        const SizedBox(height: 20),
        AppUploadField(
          label: 'Land Ownership Proof (Khatauni)',
          fileName: state.documents['land_proof'],
          onTap: () => viewModel.updateDocument('land_proof', 'khatauni_v2.pdf'),
        ),
        const SizedBox(height: 16),
        AppUploadField(
          label: 'Project Approval Letter',
          fileName: state.documents['project_approval'],
          onTap: () => viewModel.updateDocument('project_approval', 'approval_letter.pdf'),
        ),
        const SizedBox(height: 16),
        AppUploadField(
          label: 'Site Photographs',
          fileName: state.documents['site_photos'],
          onTap: () => viewModel.updateDocument('site_photos', 'site_img_001.jpg'),
        ),
        const SizedBox(height: 16),
        AppUploadField(
          label: 'NOC from Revenue Dept',
          fileName: state.documents['noc_revenue'],
          onTap: () => viewModel.updateDocument('noc_revenue', 'revenue_noc_signed.pdf'),
        ),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final NewApplicationState state;
  final NewApplicationViewModel viewModel;

  const _ReviewStep({required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const AppSectionHeader(icon: Icons.fact_check, title: 'Review & Submit'),
        const SizedBox(height: 20),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDetailRow(
                layout: DetailRowLayout.spaceBetween,
                label: 'Applicant',
                value: state.applicantDetails.fullName,
              ),
              AppDetailRow(
                layout: DetailRowLayout.spaceBetween,
                label: 'Type',
                value: state.applicantDetails.type,
              ),
              AppDetailRow(
                layout: DetailRowLayout.spaceBetween,
                label: 'Mobile',
                value: state.applicantDetails.mobile,
              ),
              const Divider(),
              AppDetailRow(
                layout: DetailRowLayout.spaceBetween,
                label: 'District',
                value: state.landDetails.district,
              ),
              AppDetailRow(
                layout: DetailRowLayout.spaceBetween,
                label: 'Village',
                value: state.landDetails.village,
              ),
              AppDetailRow(
                layout: DetailRowLayout.spaceBetween,
                label: 'Area',
                value: '${state.landDetails.area} Ha',
              ),
              const Divider(),
              AppDetailRow(
                layout: DetailRowLayout.spaceBetween,
                label: 'Trees Added',
                value: '${state.trees.length}',
              ),
              AppDetailRow(
                layout: DetailRowLayout.spaceBetween,
                label: 'Docs Uploaded',
                value: '${state.documents.values.where((e) => e != null).length}/4',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.amber),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Please ensure all information is correct before submitting. Applications cannot be edited after submission.',
                  style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TreeItemCard extends StatelessWidget {
  final int index;
  final TreeDetail tree;
  final Function(TreeDetail) onUpdate;
  final VoidCallback onRemove;

  const _TreeItemCard({
    required this.index,
    required this.tree,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tree #${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.forestGreen)),
                IconButton(onPressed: onRemove, icon: const Icon(Icons.delete_outline, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 12),
            AppDropdownField<String>(
              label: 'Species',
              value: tree.species,
              items: const ['Teak (Tectona grandis)', 'Sal (Shorea robusta)', 'Chir Pine', 'Oak', 'Other'],
              itemLabelBuilder: (val) => val,
              onChanged: (val) => onUpdate(tree.copyWith(species: val!)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    labelText: 'GBH (cm)',
                    keyboardType: TextInputType.number,
                    onChanged: (val) => onUpdate(tree.copyWith(gbh: double.tryParse(val) ?? 0)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    labelText: 'Height (m)',
                    keyboardType: TextInputType.number,
                    onChanged: (val) => onUpdate(tree.copyWith(height: double.tryParse(val) ?? 0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final NewApplicationState state;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  const _BottomActions({
    required this.state,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          if (state.currentStep > 0) ...[
            Expanded(
              child: AppButton(
                text: 'Back',
                variant: ButtonVariant.outline,
                onPressed: onBack,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: AppButton(
              text: state.currentStep == 4 ? 'Submit Application' : 'Next Step',
              isLoading: state.isSubmitting,
              onPressed: state.currentStep == 4 ? onSubmit : onNext,
            ),
          ),
        ],
      ),
    );
  }
}
