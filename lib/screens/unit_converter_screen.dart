import 'package:flutter/material.dart';

import '../data/tutorial_steps_data.dart';
import '../services/tutorial_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';
import '../widgets/tutorial_overlay.dart';

// ---------------------------------------------------------------------------
// Conversion categories and data
// ---------------------------------------------------------------------------

enum _ConvertCategory { length, volume, weight, nailScrew, lumber, angle }

class _Unit {
  const _Unit(this.label, this.symbol, this.toBase);
  final String label;
  final String symbol;
  final double toBase; // multiply to get base unit
}

class _Category {
  const _Category({
    required this.name,
    required this.icon,
    required this.baseLabel,
    required this.units,
  });
  final String name;
  final IconData icon;
  final String baseLabel;
  final List<_Unit> units;
}

const _categories = <_ConvertCategory, _Category>{
  _ConvertCategory.length: _Category(
    name: 'Length',
    icon: Icons.straighten_rounded,
    baseLabel: 'Meter (m)',
    units: [
      _Unit('Millimeter', 'mm', 0.001),
      _Unit('Centimeter', 'cm', 0.01),
      _Unit('Meter', 'm', 1.0),
      _Unit('Kilometer', 'km', 1000.0),
      _Unit('Inch', 'in', 0.0254),
      _Unit('Foot', 'ft', 0.3048),
      _Unit('Yard', 'yd', 0.9144),
    ],
  ),
  _ConvertCategory.volume: _Category(
    name: 'Volume',
    icon: Icons.view_in_ar_rounded,
    baseLabel: 'Liter (L)',
    units: [
      _Unit('Milliliter', 'mL', 0.001),
      _Unit('Liter', 'L', 1.0),
      _Unit('Fluid Ounce', 'fl oz', 0.02957353),
      _Unit('Cup', 'cup', 0.23658824),
      _Unit('Pint', 'pt', 0.47317647),
      _Unit('Quart', 'qt', 0.94635295),
      _Unit('Gallon', 'gal', 3.78541178),
      _Unit('Cubic Centimeter', 'cm³', 0.001),
      _Unit('Cubic Meter', 'm³', 1000.0),
      _Unit('Cubic Inch', 'in³', 0.016387064),
      _Unit('Cubic Foot', 'ft³', 28.316846592),
      _Unit('Cubic Yard', 'yd³', 764.554857984),
      _Unit('Board Foot', 'BF', 2.359737216),
    ],
  ),
  _ConvertCategory.weight: _Category(
    name: 'Weight',
    icon: Icons.scale_rounded,
    baseLabel: 'Kilogram (kg)',
    units: [
      _Unit('Gram', 'g', 0.001),
      _Unit('Kilogram', 'kg', 1.0),
      _Unit('Metric Ton', 't', 1000.0),
      _Unit('Ounce', 'oz', 0.0283495),
      _Unit('Pound', 'lb', 0.453592),
      _Unit('Short Ton (US)', 'ton', 907.185),
    ],
  ),
  _ConvertCategory.lumber: _Category(
    name: 'Lumber',
    icon: Icons.carpenter_rounded,
    baseLabel: 'Board Feet (BF)',
    units: [
      _Unit('Board Feet', 'BF', 1.0),
      _Unit('Lineal Feet', 'LF', 1.0),
      _Unit('Square Feet', 'SF', 1.0),
      _Unit('Cubic Feet', 'CF', 12.0),
      _Unit('Cubic Meter', 'm³', 423.776),
    ],
  ),
  _ConvertCategory.nailScrew: _Category(
    name: 'Nail / Screw',
    icon: Icons.push_pin_rounded,
    baseLabel: 'Millimeter (mm)',
    units: [
      _Unit('Millimeter', 'mm', 1.0),
      _Unit('Inch', 'in', 25.4),
      _Unit(
        'Penny (d) Nail',
        'd',
        19.05,
      ), // approx 6d ≈ 2" = 50.8mm; using 1d ≈ 19.05mm rule-of-thumb (each penny = 1/4")
    ],
  ),
  _ConvertCategory.angle: _Category(
    name: 'Angle',
    icon: Icons.architecture_rounded,
    baseLabel: 'Degree (°)',
    units: [
      _Unit('Degree', '°', 1.0),
      _Unit('Radian', 'rad', 57.2958),
      _Unit('Gradian', 'grad', 0.9),
      _Unit('Percent Slope', '%', 0.572958),
    ],
  ),
};

// ---------------------------------------------------------------------------
// Unit Converter Screen
// ---------------------------------------------------------------------------

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key, this.autoStartTutorial = true});

  final bool autoStartTutorial;

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  bool _showTutorial = false;

  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);

  _ConvertCategory _selectedCategory = _ConvertCategory.length;
  int _fromIndex = 0;
  int _toIndex = 4; // default: mm → in for length
  final _controller = TextEditingController(text: '1');
  String _result = '';

  _Category get _cat => _categories[_selectedCategory]!;

  void _calculate() {
    final input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() => _result = '—');
      return;
    }
    final fromUnit = _cat.units[_fromIndex];
    final toUnit = _cat.units[_toIndex];
    final base = input * fromUnit.toBase;
    final converted = base / toUnit.toBase;
    setState(() {
      if (converted.abs() >= 1000 ||
          (converted != 0 && converted.abs() < 0.001)) {
        _result = converted.toStringAsExponential(4);
      } else {
        _result = _stripTrailingZeros(converted.toStringAsFixed(6));
      }
    });
  }

  String _stripTrailingZeros(String s) {
    if (!s.contains('.')) return s;
    s = s.replaceAll(RegExp(r'0+$'), '');
    if (s.endsWith('.')) s = s.substring(0, s.length - 1);
    return s;
  }

  void _swapUnits() {
    setState(() {
      final tmp = _fromIndex;
      _fromIndex = _toIndex;
      _toIndex = tmp;
    });
    _calculate();
  }

  void _selectCategory(_ConvertCategory cat) {
    setState(() {
      _selectedCategory = cat;
      _fromIndex = 0;
      _toIndex = _categories[cat]!.units.length > 1 ? 1 : 0;
      _controller.text = '1';
      _result = '';
    });
    _calculate();
  }

  @override
  void initState() {
    super.initState();
    _calculate();
    if (widget.autoStartTutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final completed = await TutorialService.instance.isCompleted(TutorialPage.converter);
        if (!completed && mounted) {
          setState(() {
            _showTutorial = true;
          });
        }
      });
    }
  }

  void _finishTutorial() {
    TutorialService.instance.markCompleted(TutorialPage.converter);
    if (mounted) {
      setState(() {
        _showTutorial = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DesignCanvas(
      width: 409,
      height: 849,
      backgroundColor: Colors.white,
      children: [
        // Header
        const Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            width: 409,
            height: 122,
            child: DecoratedBox(decoration: BoxDecoration(color: _navy)),
          ),
        ),
        Positioned(
          left: 18,
          top: 56,
          child: Navigator.of(context).canPop()
              ? IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.calculate_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 68,
          child: Text(
            'Unit Converter',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.60,
            ),
          ),
        ),
        Positioned(
          right: 66,
          top: 62,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() => _showTutorial = true),
              child: const SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          right: 28,
          top: 62,
          child: Icon(Icons.calculate_rounded, color: Colors.white, size: 32),
        ),

        // Category chips
        Positioned(
          left: 0,
          right: 0,
          top: 130,
          child: SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _categories.entries.map((e) {
                final selected = e.key == _selectedCategory;
                return GestureDetector(
                  onTap: () => _selectCategory(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8, top: 8, bottom: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? _accent : const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? _accent : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          e.value.icon,
                          size: 16,
                          color: selected ? _navy : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          e.value.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: selected ? _navy : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Main converter card
        Positioned(
          left: 16,
          right: 16,
          top: 198,
          child: _ConverterCard(
            cat: _cat,
            fromIndex: _fromIndex,
            toIndex: _toIndex,
            controller: _controller,
            result: _result,
            onFromChanged: (i) {
              setState(() => _fromIndex = i);
              _calculate();
            },
            onToChanged: (i) {
              setState(() => _toIndex = i);
              _calculate();
            },
            onInputChanged: (_) => _calculate(),
            onSwap: _swapUnits,
          ),
        ),

        // Quick reference table
        Positioned(
          left: 16,
          right: 16,
          top: 530,
          child: _QuickReferenceCard(cat: _cat),
        ),

        const DashboardBottomNavBar(currentTab: DashboardTab.converter),
        if (_showTutorial)
          TutorialOverlay(
            steps: TutorialStepsData.getStepsFor(TutorialPage.converter),
            onFinish: _finishTutorial,
            onSkip: _finishTutorial,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Converter card widget
// ---------------------------------------------------------------------------

class _ConverterCard extends StatelessWidget {
  const _ConverterCard({
    required this.cat,
    required this.fromIndex,
    required this.toIndex,
    required this.controller,
    required this.result,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onInputChanged,
    required this.onSwap,
  });

  final _Category cat;
  final int fromIndex;
  final int toIndex;
  final TextEditingController controller;
  final String result;
  final ValueChanged<int> onFromChanged;
  final ValueChanged<int> onToChanged;
  final ValueChanged<String> onInputChanged;
  final VoidCallback onSwap;

  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FROM
          Text(
            'From',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _navy.withValues(alpha: 0.15)),
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: onInputChanged,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _navy,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _UnitDropdown(
                units: cat.units,
                selectedIndex: fromIndex,
                onChanged: onFromChanged,
              ),
            ],
          ),

          // Swap button
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: GestureDetector(
                onTap: onSwap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _navy,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _navy.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.swap_vert_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          // TO
          Text(
            'To',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0F3260), Color(0xFF061D3F)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result.isEmpty ? '—' : result,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _UnitDropdown(
                units: cat.units,
                selectedIndex: toIndex,
                onChanged: onToChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Unit dropdown
// ---------------------------------------------------------------------------

class _UnitDropdown extends StatelessWidget {
  const _UnitDropdown({
    required this.units,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<_Unit> units;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<int>(
        value: selectedIndex,
        underline: const SizedBox(),
        dropdownColor: _navy,
        style: const TextStyle(
          color: _accent,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        icon: const Icon(Icons.arrow_drop_down, color: _accent),
        selectedItemBuilder: (BuildContext context) {
          return List.generate(units.length, (i) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                units[i].symbol,
                style: const TextStyle(
                  color: _accent,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            );
          });
        },
        items: List.generate(units.length, (i) {
          return DropdownMenuItem<int>(
            value: i,
            child: Text(
              '${units[i].label} (${units[i].symbol})',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          );
        }),
        onChanged: (i) {
          if (i != null) onChanged(i);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quick reference card
// ---------------------------------------------------------------------------

class _QuickReferenceCard extends StatelessWidget {
  const _QuickReferenceCard({required this.cat});

  final _Category cat;

  static const _navy = Color(0xFF061D3F);

  // Common carpentry conversion pairs per category
  static const _refs = <String, List<(String, String)>>{
    'Length': [
      ('1 ft', '= 12 in  /  30.48 cm'),
      ('1 in', '= 25.4 mm'),
      ('1 m', '≈ 3.281 ft  /  100 cm'),
      ('1 yd', '= 3 ft  /  0.9144 m'),
    ],
    'Volume': [
      ('1 gal', '= 4 qt  /  3.785 L'),
      ('1 qt', '= 2 pt  /  4 cups  /  0.946 L'),
      ('1 pt', '= 2 cups  /  16 fl oz'),
      ('1 cup', '= 8 fl oz  /  236.6 mL'),
      ('1 L', '= 1,000 mL  /  1,000 cm³'),
      ('1 ft³', '= 1,728 in³  /  28.32 L'),
      ('1 m³', '= 1,000 L  /  35.31 ft³'),
      ('1 BF', '= 144 in³  /  2.36 L'),
    ],
    'Weight': [
      ('1 kg', '≈ 2.205 lb'),
      ('1 lb', '= 16 oz  /  453.6 g'),
      ('1 t', '≈ 2,205 lb'),
    ],
    'Lumber': [
      ('1 BF', '= 1 ft × 1 ft × 1 in'),
      ('1 m³', '≈ 424 BF'),
      ('Nom. 2×4', '= actual 1.5"×3.5"'),
    ],
    'Nail / Screw': [
      ('6d nail', '≈ 2" (50.8 mm)'),
      ('8d nail', '≈ 2.5" (63.5 mm)'),
      ('16d nail', '≈ 3.5" (88.9 mm)'),
    ],
    'Angle': [
      ('90°', '= π/2 rad  ≈ 1.5708 rad'),
      ('45°', '= π/4 rad  ≈ 0.7854 rad'),
      ('1°', '≈ 0.01745 rad'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final refs = _refs[cat.name] ?? [];
    if (refs.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: _navy),
              const SizedBox(width: 6),
              const Text(
                'Quick Reference',
                style: TextStyle(
                  color: _navy,
                  fontSize: 13,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...refs.map(
            (ref) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      ref.$1,
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ref.$2,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
