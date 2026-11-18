import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../widgets/control_widgets.dart';

enum _FlexPreset { standard, subtle, uniform, pronounced, custom }

enum _MorphPreset { plain, fluid, anchoredPop, droplet, calm, customSpring }

/// Tab 2: Complete interactive playground for:
/// - LiquidGlassTouch, LiquidGlassFlex, LiquidGlassFlexAdvanced
/// - LiquidGlassMorph, LiquidGlassMorphMotion, LiquidGlassMorphAdvanced,
///   LiquidGlassMorphShared
class TouchMorphPage extends StatefulWidget {
  const TouchMorphPage({super.key});

  @override
  State<TouchMorphPage> createState() => _TouchMorphPageState();
}

class _TouchMorphPageState extends State<TouchMorphPage> {
  // ── Touch / Flex state ──
  _FlexPreset _flexPreset = _FlexPreset.pronounced;
  double _stretch = 18;
  double _squeeze = 0.70;
  double _lean = 0.50;
  double _grip = 0.75;
  bool _compressInward = true;
  double _holdScale = 0.04;
  double _tapScale = 0.03;
  double _maxPull = 44;
  Axis? _lockAxis;

  // LiquidGlassFlexAdvanced
  double _childFollow = 1.0;
  double _refractionBoost = 0.18;
  double _magnificationBoost = 0.05;
  double _stiffness = 300;
  double _damping = 22;
  double _releaseDamping = 15;

  // ── Morph state ──
  bool _morphExpanded = false;
  int _morphSettledCount = 0;
  _MorphPreset _morphPreset = _MorphPreset.fluid;
  Alignment _morphAlignment = Alignment.center;
  double _morphSmoothness = 42;
  double _morphOpacity = 1.0;
  bool _morphDebugClip = false;
  bool _morphUseTouch = true;

  // Custom Spring + LiquidGlassMorphAdvanced
  double _springDurationMs = 450;
  double _springBounce = 0.30;
  double _morphStretch = 0.65;
  bool _morphBlended = true;
  double _leadBounce = 0.10;
  double _followDelay = 0.04;
  double _seedScale = 0.85;
  double _linger = 0.12;
  double _drainSpeed = 1.5;
  double _drainInward = 0.35;
  bool _sourceFollows = false;
  double _neckRamp = 24;
  double _contentBlur = 8;
  double _thickenBlur = 0.35;
  double _thickenRefraction = 0.30;

  LiquidGlassFlex get _currentFlex => switch (_flexPreset) {
        _FlexPreset.standard => const LiquidGlassFlex(),
        _FlexPreset.subtle => const LiquidGlassFlex.subtle(),
        _FlexPreset.uniform => const LiquidGlassFlex.uniform(),
        _FlexPreset.pronounced => const LiquidGlassFlex.pronounced(),
        _FlexPreset.custom => LiquidGlassFlex(
            stretch: _stretch,
            squeeze: _squeeze,
            lean: _lean,
            grip: _grip,
            compressInward: _compressInward,
            holdScale: _holdScale,
            tapScale: _tapScale,
            maxPull: _maxPull,
            lockAxis: _lockAxis,
            advanced: LiquidGlassFlexAdvanced(
              childFollow: _childFollow,
              refractionBoost: _refractionBoost,
              magnificationBoost: _magnificationBoost,
              stiffness: _stiffness,
              damping: _damping,
              releaseDamping: _releaseDamping,
            ),
          ),
      };

  LiquidGlassMorphMotion get _currentMorphMotion => switch (_morphPreset) {
        _MorphPreset.plain => LiquidGlassMorphMotion.plain,
        _MorphPreset.fluid => LiquidGlassMorphMotion.fluid,
        _MorphPreset.anchoredPop => LiquidGlassMorphMotion.anchoredPop,
        _MorphPreset.droplet => LiquidGlassMorphMotion.droplet,
        _MorphPreset.calm => LiquidGlassMorphMotion.calm,
        _MorphPreset.customSpring => LiquidGlassMorphMotion.spring(
            duration: Duration(milliseconds: _springDurationMs.round()),
            bounce: _springBounce,
            stretch: _morphStretch,
            anchor: Alignment.center,
            blended: _morphBlended,
            advanced: LiquidGlassMorphAdvanced(
              leadBounce: _leadBounce,
              followDelay: _followDelay,
              seedScale: _seedScale,
              linger: _linger,
              drainSpeed: _drainSpeed,
              drainInward: _drainInward,
              sourceFollows: _sourceFollows,
              neckRamp: _neckRamp,
              contentOutEnd: 0.40,
              contentInStart: 0.30,
              contentInEnd: 0.80,
              newScaleFrom: 0.90,
              oldScaleTo: 0.92,
              contentBlur: _contentBlur,
              contentFollow: 0.0,
              contentSlide: 0,
              thickenBlur: _thickenBlur,
              thickenRefraction: _thickenRefraction,
            ),
          ),
      };

  void _applyFlexPreset(_FlexPreset preset) {
    setState(() {
      _flexPreset = preset;
      final LiquidGlassFlex f = _currentFlex;
      _stretch = f.stretch;
      _squeeze = f.squeeze;
      _lean = f.lean;
      _grip = f.grip;
      _compressInward = f.compressInward;
      _holdScale = f.holdScale;
      _tapScale = f.tapScale;
      _maxPull = f.maxPull;
      _lockAxis = f.lockAxis;
      _childFollow = f.childFollow;
      _refractionBoost = f.refractionBoost;
      _magnificationBoost = f.magnificationBoost;
      _stiffness = f.stiffness;
      _damping = f.damping;
      _releaseDamping = f.releaseDamping;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top + 82;
    final double bottomInset = MediaQuery.paddingOf(context).bottom + 110;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, topInset, 16, bottomInset),
      children: [
        // ── 1. Interactive Soft-Body Touch Flex Lens ──
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18, top: 6),
            child: SizedBox(
              width: 260,
              height: 120,
              child: LiquidGlassLens(
                touch: LiquidGlassTouch.flexing(_currentFlex),
                style: const LiquidGlassStyle(
                  shape: LiquidGlassShape.continuousRoundedRectangle(
                    cornerRadius: 34,
                  ),
                  refractionIndex: 1.09,
                  refractionWidth: 20,
                  dispersion: 1.2,
                  color: Color(0x20FFFFFF),
                  blur: 1.5,
                  shadow: LiquidGlassShadow(blur: 12, opacity: 0.25),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app_rounded,
                          color: Colors.white, size: 28),
                      SizedBox(height: 6),
                      Text(
                        'Press, Pull & Flick Me',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'LiquidGlassTouch + LiquidGlassFlex',
                        style: TextStyle(color: Colors.white70, fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        ControlPanel(
          title: 'LiquidGlassTouch & LiquidGlassFlex',
          subtitle:
              'Presets + all 9 flex properties + all 6 LiquidGlassFlexAdvanced properties',
          children: [
            ChipChoiceRow<_FlexPreset>(
              label: 'Preset',
              value: _flexPreset,
              options: const [
                (_FlexPreset.standard, 'default'),
                (_FlexPreset.subtle, '.subtle()'),
                (_FlexPreset.uniform, '.uniform()'),
                (_FlexPreset.pronounced, '.pronounced()'),
                (_FlexPreset.custom, 'Custom'),
              ],
              onChanged: _applyFlexPreset,
            ),
            if (_flexPreset == _FlexPreset.custom) ...[
              LabeledSlider(
                label: 'stretch',
                value: _stretch,
                min: 0,
                max: 40,
                decimals: 1,
                suffix: ' px',
                onChanged: (v) => setState(() => _stretch = v),
              ),
              LabeledSlider(
                label: 'squeeze (volume preservation)',
                value: _squeeze,
                min: 0,
                max: 1.2,
                onChanged: (v) => setState(() => _squeeze = v),
              ),
              LabeledSlider(
                label: 'lean',
                value: _lean,
                min: 0,
                max: 1.5,
                onChanged: (v) => setState(() => _lean = v),
              ),
              LabeledSlider(
                label: 'grip (grab localization)',
                value: _grip,
                min: 0,
                max: 1,
                onChanged: (v) => setState(() => _grip = v),
              ),
              LabeledSwitch(
                label: 'compressInward',
                value: _compressInward,
                onChanged: (v) => setState(() => _compressInward = v),
              ),
              LabeledSlider(
                label: 'holdScale',
                value: _holdScale,
                min: -0.1,
                max: 0.15,
                decimals: 3,
                onChanged: (v) => setState(() => _holdScale = v),
              ),
              LabeledSlider(
                label: 'tapScale',
                value: _tapScale,
                min: -0.1,
                max: 0.15,
                decimals: 3,
                onChanged: (v) => setState(() => _tapScale = v),
              ),
              LabeledSlider(
                label: 'maxPull',
                value: _maxPull,
                min: 12,
                max: 120,
                decimals: 0,
                suffix: ' px',
                onChanged: (v) => setState(() => _maxPull = v),
              ),
              ChipChoiceRow<Axis?>(
                label: 'lockAxis',
                value: _lockAxis,
                options: const [
                  (null, 'Free (null)'),
                  (Axis.horizontal, 'Axis.horizontal'),
                  (Axis.vertical, 'Axis.vertical'),
                ],
                onChanged: (v) => setState(() => _lockAxis = v),
              ),
              const Divider(),
              const Text(
                'LiquidGlassFlexAdvanced',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              LabeledSlider(
                label: 'childFollow',
                value: _childFollow,
                min: 0,
                max: 1,
                onChanged: (v) => setState(() => _childFollow = v),
              ),
              LabeledSlider(
                label: 'refractionBoost',
                value: _refractionBoost,
                min: 0,
                max: 0.5,
                onChanged: (v) => setState(() => _refractionBoost = v),
              ),
              LabeledSlider(
                label: 'magnificationBoost',
                value: _magnificationBoost,
                min: 0,
                max: 0.3,
                onChanged: (v) => setState(() => _magnificationBoost = v),
              ),
              LabeledSlider(
                label: 'stiffness',
                value: _stiffness,
                min: 80,
                max: 600,
                decimals: 0,
                onChanged: (v) => setState(() => _stiffness = v),
              ),
              LabeledSlider(
                label: 'damping',
                value: _damping,
                min: 6,
                max: 50,
                decimals: 1,
                onChanged: (v) => setState(() => _damping = v),
              ),
              LabeledSlider(
                label: 'releaseDamping',
                value: _releaseDamping,
                min: 4,
                max: 40,
                decimals: 1,
                onChanged: (v) => setState(() => _releaseDamping = v),
              ),
            ],
          ],
        ),

        // ── 2. LiquidGlassMorph Stage ──
        Container(
          height: 250,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white24),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: LiquidGlassMorph(
                  alignment: _morphAlignment,
                  motion: _currentMorphMotion,
                  smoothness: _morphSmoothness,
                  opacity: _morphOpacity,
                  debugClipBounds: _morphDebugClip,
                  touch: _morphUseTouch
                      ? const LiquidGlassTouch.flexing(LiquidGlassFlex.subtle())
                      : null,
                  onEnd: () => setState(() => _morphSettledCount++),
                  style: LiquidGlassStyle(
                    shape: LiquidGlassShape.continuousRoundedRectangle(
                      cornerRadius: _morphExpanded ? 28 : 30,
                    ),
                    color: const Color(0x28FFFFFF),
                    blur: 2.5,
                    refractionIndex: 1.07,
                    refractionWidth: 16,
                    shadow: const LiquidGlassShadow(blur: 10, opacity: 0.25),
                  ),
                  child: _morphExpanded
                      ? _ExpandedMorphCard(
                          key: const ValueKey('expanded_card'),
                          onClose: () => setState(() => _morphExpanded = false),
                        )
                      : _CompactMorphPill(
                          key: const ValueKey('compact_pill'),
                          onOpen: () => setState(() => _morphExpanded = true),
                        ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Text(
                  'Tap glass to morph • onEnd: $_morphSettledCount',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
              ),
            ],
          ),
        ),

        ControlPanel(
          title: 'LiquidGlassMorph & LiquidGlassMorphMotion',
          subtitle:
              'Presets, alignment, smoothness, opacity, debugClipBounds, LiquidGlassMorphShared & Advanced',
          children: [
            ChipChoiceRow<_MorphPreset>(
              label: 'LiquidGlassMorphMotion preset',
              value: _morphPreset,
              options: const [
                (_MorphPreset.plain, 'plain'),
                (_MorphPreset.fluid, 'fluid'),
                (_MorphPreset.anchoredPop, 'anchoredPop'),
                (_MorphPreset.droplet, 'droplet'),
                (_MorphPreset.calm, 'calm'),
                (_MorphPreset.customSpring, '.spring() + Advanced'),
              ],
              onChanged: (v) => setState(() => _morphPreset = v),
            ),
            ChipChoiceRow<Alignment>(
              label: 'alignment (anchor edge/corner)',
              value: _morphAlignment,
              options: const [
                (Alignment.topLeft, 'topLeft'),
                (Alignment.center, 'center'),
                (Alignment.centerLeft, 'centerLeft'),
                (Alignment.bottomRight, 'bottomRight'),
              ],
              onChanged: (v) => setState(() => _morphAlignment = v),
            ),
            LabeledSlider(
              label: 'smoothness (neck radius)',
              value: _morphSmoothness,
              min: 0,
              max: 90,
              decimals: 0,
              suffix: ' px',
              onChanged: (v) => setState(() => _morphSmoothness = v),
            ),
            LabeledSlider(
              label: 'opacity',
              value: _morphOpacity,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _morphOpacity = v),
            ),
            LabeledSwitch(
              label: 'touch (LiquidGlassFlex.subtle on morph)',
              value: _morphUseTouch,
              onChanged: (v) => setState(() => _morphUseTouch = v),
            ),
            LabeledSwitch(
              label: 'debugClipBounds',
              subtitle: 'Draws magenta outline around blender backdrop clip',
              value: _morphDebugClip,
              onChanged: (v) => setState(() => _morphDebugClip = v),
            ),
            if (_morphPreset == _MorphPreset.customSpring) ...[
              const Divider(),
              const Text(
                'LiquidGlassMorphMotion.spring & LiquidGlassMorphAdvanced',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              LabeledSlider(
                label: 'spring duration',
                value: _springDurationMs,
                min: 200,
                max: 1200,
                decimals: 0,
                suffix: ' ms',
                onChanged: (v) => setState(() => _springDurationMs = v),
              ),
              LabeledSlider(
                label: 'spring bounce',
                value: _springBounce,
                min: 0,
                max: 0.65,
                onChanged: (v) => setState(() => _springBounce = v),
              ),
              LabeledSlider(
                label: 'stretch',
                value: _morphStretch,
                min: 0,
                max: 1,
                onChanged: (v) => setState(() => _morphStretch = v),
              ),
              LabeledSwitch(
                label: 'blended (2-blob metaball vs single lens)',
                value: _morphBlended,
                onChanged: (v) => setState(() => _morphBlended = v),
              ),
              LabeledSlider(
                label: 'leadBounce',
                value: _leadBounce,
                min: 0,
                max: 0.4,
                onChanged: (v) => setState(() => _leadBounce = v),
              ),
              LabeledSlider(
                label: 'followDelay',
                value: _followDelay,
                min: 0,
                max: 0.25,
                suffix: ' s',
                onChanged: (v) => setState(() => _followDelay = v),
              ),
              LabeledSlider(
                label: 'seedScale',
                value: _seedScale,
                min: 0.2,
                max: 1.0,
                onChanged: (v) => setState(() => _seedScale = v),
              ),
              LabeledSlider(
                label: 'linger',
                value: _linger,
                min: 0,
                max: 0.35,
                suffix: ' s',
                onChanged: (v) => setState(() => _linger = v),
              ),
              LabeledSlider(
                label: 'drainSpeed',
                value: _drainSpeed,
                min: 0.5,
                max: 3.0,
                onChanged: (v) => setState(() => _drainSpeed = v),
              ),
              LabeledSlider(
                label: 'drainInward',
                value: _drainInward,
                min: 0,
                max: 1,
                onChanged: (v) => setState(() => _drainInward = v),
              ),
              LabeledSwitch(
                label: 'sourceFollows',
                value: _sourceFollows,
                onChanged: (v) => setState(() => _sourceFollows = v),
              ),
              LabeledSlider(
                label: 'neckRamp',
                value: _neckRamp,
                min: 4,
                max: 60,
                decimals: 0,
                suffix: ' px',
                onChanged: (v) => setState(() => _neckRamp = v),
              ),
              LabeledSlider(
                label: 'contentBlur',
                value: _contentBlur,
                min: 0,
                max: 16,
                decimals: 1,
                onChanged: (v) => setState(() => _contentBlur = v),
              ),
              LabeledSlider(
                label: 'thickenBlur',
                value: _thickenBlur,
                min: 0,
                max: 1.5,
                onChanged: (v) => setState(() => _thickenBlur = v),
              ),
              LabeledSlider(
                label: 'thickenRefraction',
                value: _thickenRefraction,
                min: 0,
                max: 1.5,
                onChanged: (v) => setState(() => _thickenRefraction = v),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _CompactMorphPill extends StatelessWidget {
  final VoidCallback onOpen;
  const _CompactMorphPill({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpen,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LiquidGlassMorphShared(
              tag: 'shared_spark',
              child: Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 22),
            ),
            SizedBox(width: 8),
            Text(
              'Open Menu',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedMorphCard extends StatelessWidget {
  final VoidCallback onClose;
  const _ExpandedMorphCard({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClose,
      child: SizedBox(
        width: 240,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const LiquidGlassMorphShared(
                    tag: 'shared_spark',
                    child: Icon(Icons.auto_awesome_rounded,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'LiquidGlassMorph',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: onClose,
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white70, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Shared icon flies smoothly via LiquidGlassMorphShared(tag: "shared_spark"). Tap anywhere to fold back.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
