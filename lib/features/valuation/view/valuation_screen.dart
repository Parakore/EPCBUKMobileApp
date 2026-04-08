import 'package:epcbuk_mobile_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../model/valuation_state.dart';
import '../repository/valuation_repository.dart';

class ValuationScreen extends ConsumerWidget {
  const ValuationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(valuationProvider);
    final viewModel = ref.read(valuationProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Parameter Input Card
          GlassCard(
            title: 'Tree Parameters',
            child: Column(
              children: [
                _DropdownRow<String>(
                  label: 'Tree Species',
                  value: state.species.id,
                  items: ValuationRepository.speciesList.map((s) {
                    return DropdownMenuItem(value: s.id, child: Text(s.name));
                  }).toList(),
                  onChanged: (val) => viewModel.updateSpecies(val!),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        labelText: 'GBH (cm)',
                        hintText: 'e.g. 120',
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            viewModel.updateGBH(double.tryParse(val) ?? 0),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppTextField(
                        labelText: 'Height (m)',
                        hintText: 'e.g. 18',
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            viewModel.updateHeight(double.tryParse(val) ?? 0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        labelText: 'Age (years)',
                        hintText: 'e.g. 30',
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            viewModel.updateAge(double.tryParse(val) ?? 0),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DropdownRow<LocationFactor>(
                        label: 'Location Sensitivity',
                        value: state.location,
                        items: LocationFactor.values.map((l) {
                          return DropdownMenuItem(
                              value: l, child: Text(l.label));
                        }).toList(),
                        onChanged: (val) => viewModel.updateLocation(val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        labelText: 'Market Rate (₹/m³)',
                        hintText: 'e.g. 32000',
                        keyboardType: TextInputType.number,
                        onChanged: (val) => viewModel
                            .updateMarketRate(double.tryParse(val) ?? 0),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppTextField(
                        labelText: 'Number of Trees',
                        hintText: 'e.g. 1',
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            viewModel.updateNumTrees(int.tryParse(val) ?? 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Formula Visual
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.greenPale.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: AppTheme.greenMid.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📐 Embedded Formula Engine',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.greenDark)),
                const SizedBox(height: 12),
                const _FormulaText('📐 Volume = (GBH² / 4π) × Height'),
                const _FormulaText('💰 Timber Value = Volume × Market Rate'),
                const _FormulaText(
                    '🌿 Env Cost = Base Rate × Age Factor × Eco Factor'),
                const _FormulaText(
                    '🌳 NPV = Std Rate × Age Multiplier × Location Factor'),
                const _FormulaText('🌱 Afforestation = Timber Value × 0.30'),
                const Divider(height: 16, color: AppTheme.greenMid),
                const _FormulaText(
                    '🏆 Total = Timber + Env + NPV + Afforestation',
                    isBold: true),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Results Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.greenDark, AppTheme.greenMain],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: AppTheme.greenDark.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.receipt_long, color: AppTheme.goldLight),
                    SizedBox(width: 8),
                    Text('Compensation Breakdown',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 20),
                _ResultLine(
                    label: 'Tree Volume',
                    value: '${state.volume.toStringAsFixed(4)} m³'),
                _ResultLine(
                    label: 'Timber Value',
                    value: '₹ ${state.timberValue.toStringAsFixed(0)}'),
                _ResultLine(
                    label: 'Env. Compensation',
                    value: '₹ ${state.envCost.toStringAsFixed(0)}'),
                _ResultLine(
                    label: 'NPV Collection',
                    value: '₹ ${state.npv.toStringAsFixed(0)}'),
                _ResultLine(
                    label: 'Afforestation Cost',
                    value: '₹ ${state.afforestation.toStringAsFixed(0)}'),
                const Divider(color: Colors.white24, height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL COMPENSATION',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    Text('₹ ${state.total.toStringAsFixed(0)}',
                        style: TextStyle(
                            color: AppTheme.goldLight,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Rajdhani')),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Generate Valuation Report'),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.greenDark),
          ),
        ],
      ),
    );
  }
}

class _DropdownRow<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;

  const _DropdownRow({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.greenDark.withValues(alpha: 0.8),
                letterSpacing: 1,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultLine extends StatelessWidget {
  final String label;
  final String value;

  const _ResultLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _FormulaText extends StatelessWidget {
  final String text;
  final bool isBold;

  const _FormulaText(this.text, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontFamily: 'monospace',
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isBold ? AppTheme.greenDark : Colors.black87,
        ),
      ),
    );
  }
}
