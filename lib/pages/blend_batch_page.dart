import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../widgets/control_widgets.dart';
import '../widgets/showcase_background.dart';

/// Tab 3: Complete interactive playground for:
/// - LiquidGlassBlender (smoothness 0=group..100=metaball, useEngineBlur,
///   debugClipBounds, opacity, 2..8 lenses)
/// - LiquidGlassBatch & LiquidGlassBatch.exclude (enabled, mode, blurMethod,
///   shaderBlurDispersion)
/// - LiquidGlassEngine (liteGlassOnSkia, liteGlassOnImpeller, liteGlass)
/// - LiquidGlassConfiguration (all package-wide static switches & overrides)
/// - LiquidGlassView & LiquidGlassViewController (captureOnce, start/stop
///   realtime, pixelRatio, realTimeCapture, useSync, regionCapture, refreshRate)
class BlendBatchPage extends StatefulWidget {
  final VoidCallback onGlobalConfigChanged;

  const BlendBatchPage({
    super.key,
    required this.onGlobalConfigChanged,
  });

  @override
  State<BlendBatchPage> createState() => _BlendBatchPageState();
}

class _BlendBatchPageState extends State<BlendBatchPage> {
  // ── LiquidGlassBlender ──
  double _smoothness = 54;
  bool _useEngineBlur = true;
  bool _debugClipBounds = false;
  double _blenderOpacity = 1.0;
  int _lensCount = 3;

  final List<Offset> _positions = [
    const Offset(24, 24),
    const Offset(130, 56),
    const Offset(78, 124),
    const Offset(210, 30),
    const Offset(196, 130),
    const Offset(22, 146),
    const Offset(132, 152),
    const Offset(236, 86),
  ];

  static const List<(Size, LiquidGlassShape, IconData)> _lensSpecs = [
    (
      Size(130, 82),
      LiquidGlassShape.continuousRoundedRectangle(cornerRadius: 28),
      Icons.water_drop_rounded,
    ),
    (
      Size(86, 86),
      LiquidGlassShape.roundedRectangle(cornerRadius: 43),
      Icons.favorite_rounded,
    ),
    (
      Size(96, 86),
      LiquidGlassShape.squircle(cornerRadius: 30),
      Icons.bolt_rounded,
    ),
    (
      Size(76, 76),
      LiquidGlassShape.roundedRectangle(cornerRadius: 38),
      Icons.star_rounded,
    ),
    (
      Size(92, 68),
      LiquidGlassShape.continuousRoundedRectangle(cornerRadius: 24),
      Icons.bubble_chart_rounded,
    ),
    (
      Size(72, 72),
      LiquidGlassShape.squircle(cornerRadius: 22),
      Icons.lens_blur_rounded,
    ),
    (
      Size(84, 64),
      LiquidGlassShape.roundedRectangle(cornerRadius: 32),
      Icons.blur_on_rounded,
    ),
    (
      Size(70, 70),
      LiquidGlassShape.continuousRoundedRectangle(cornerRadius: 35),
      Icons.auto_awesome_rounded,
    ),
  ];

  // ── LiquidGlassBatch ──
  bool _batchEnabled = true;
  LiquidGlassBatchMode _batchMode = LiquidGlassBatchMode.separatePass;
  LiquidGlassBlurMethod _batchBlurMethod = LiquidGlassBlurMethod.engine;
  bool _batchShaderBlurDispersion = false;

  // ── LiquidGlassView + Controller (dedicated Skia/Impeller demo box) ──
  final LiquidGlassViewController _viewController = LiquidGlassViewController();
  double _viewPixelRatio = 0.8;
  bool _viewRealTimeCapture = true;
  bool _viewUseSync = true;
  bool _viewRegionCapture = false;
  LiquidGlassRefreshRate _viewRefreshRate =
      LiquidGlassRefreshRate.deviceRefreshRate;
  int _captureCount = 0;

  // ── Global Configuration overrides ──
  bool _useBlurOverride = false;
  double _blurOverrideValue = 4.0;
  bool _useDispersionOverride = false;
  double _dispersionOverrideValue = 2.0;
  bool _useShadowColorOverride = false;

  void _syncGlobalConfig() {
    LiquidGlassConfiguration.blurOverride =
        _useBlurOverride ? _blurOverrideValue : null;
    LiquidGlassConfiguration.dispersionOverride =
        _useDispersionOverride ? _dispersionOverrideValue : null;
    LiquidGlassConfiguration.shadowColorOverrideLight =
        _useShadowColorOverride ? const Color(0xFF1D4ED8) : null;
    LiquidGlassConfiguration.shadowColorOverrideDark =
        _useShadowColorOverride ? const Color(0xFF9333EA) : null;
    widget.onGlobalConfigChanged();
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top + 82;
    final double bottomInset = MediaQuery.paddingOf(context).bottom + 110;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, topInset, 16, bottomInset),
      children: [
        // ── 1. Interactive LiquidGlassBlender Arena ──
        Container(
          height: 255,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                Positioned.fill(
                  child: LiquidGlassBlender(
                    smoothness: _smoothness,
                    useEngineBlur: _useEngineBlur,
                    debugClipBounds: _debugClipBounds,
                    opacity: _blenderOpacity,
                    style: const LiquidGlassStyle(
                      shape: LiquidGlassShape.continuousRoundedRectangle(
                        cornerRadius: 32,
                      ),
                      color: Color(0x18FFFFFF),
                      saturation: 1.1,
                      blur: 2.5,
                      refractionIndex: 1.09,
                      refractionWidth: 18,
                      dispersion: 1.1,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        for (int i = 0; i < _lensCount; i++)
                          Positioned(
                            left: _positions[i].dx,
                            top: _positions[i].dy,
                            width: _lensSpecs[i].$1.width,
                            height: _lensSpecs[i].$1.height,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanUpdate: (e) {
                                setState(() {
                                  _positions[i] += e.delta;
                                });
                              },
                              child: LiquidGlassLens(
                                style: LiquidGlassStyle(shape: _lensSpecs[i].$2),
                                child: Center(
                                  child: Icon(
                                    _lensSpecs[i].$3,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 10,
                  child: IgnorePointer(
                    child: Text(
                      _smoothness == 0
                          ? 'Group Mode (smoothness: 0) — Drag shapes'
                          : 'Metaball Blend ($_lensCount/${LiquidGlassBlender.maxLensCount}) — Drag shapes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        ControlPanel(
          title: 'LiquidGlassBlender',
          subtitle:
              'smoothness (0 = group mode), useEngineBlur, debugClipBounds, opacity, 2..8 members',
          children: [
            LabeledSlider(
              label: 'smoothness (0 = LiquidGlassGroup mode)',
              value: _smoothness,
              min: 0,
              max: 100,
              decimals: 0,
              suffix: ' px',
              onChanged: (v) => setState(() => _smoothness = v),
            ),
            LabeledSlider(
              label: 'Member lenses (2 to maxLensCount = 8)',
              value: _lensCount.toDouble(),
              min: LiquidGlassBlender.minLensCount.toDouble(),
              max: LiquidGlassBlender.maxLensCount.toDouble(),
              divisions:
                  LiquidGlassBlender.maxLensCount - LiquidGlassBlender.minLensCount,
              decimals: 0,
              onChanged: (v) => setState(() => _lensCount = v.round()),
            ),
            LabeledSlider(
              label: 'opacity',
              value: _blenderOpacity,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _blenderOpacity = v),
            ),
            LabeledSwitch(
              label: 'useEngineBlur (Impeller)',
              value: _useEngineBlur,
              onChanged: (v) => setState(() => _useEngineBlur = v),
            ),
            LabeledSwitch(
              label: 'debugClipBounds (magenta outline)',
              value: _debugClipBounds,
              onChanged: (v) => setState(() => _debugClipBounds = v),
            ),
          ],
        ),

        // ── 2. LiquidGlassBatch + LiquidGlassBatch.exclude ──
        ControlPanel(
          title: 'LiquidGlassBatch & LiquidGlassBatch.exclude',
          subtitle: 'Many lenses sharing ONE backdrop read (Impeller)',
          children: [
            LiquidGlassBatch(
              enabled: _batchEnabled,
              mode: _batchMode,
              blurMethod: _batchBlurMethod,
              shaderBlurDispersion: _batchShaderBlurDispersion,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (int i = 1; i <= 5; i++)
                    SizedBox(
                      width: 92,
                      height: 52,
                      child: LiquidGlassLens(
                        style: LiquidGlassStyle(
                          shape: LiquidGlassShape.continuousRoundedRectangle(
                            cornerRadius: 16,
                          ),
                          blur: 2.5,
                          dispersion: 1.4,
                          color: const Color(0x20FFFFFF),
                        ),
                        child: Center(
                          child: Text(
                            'Batched #$i',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  LiquidGlassBatch.exclude(
                    child: SizedBox(
                      width: 112,
                      height: 52,
                      child: LiquidGlassLens(
                        style: const LiquidGlassStyle(
                          shape: LiquidGlassShape.squircle(cornerRadius: 16),
                          blur: 2.5,
                          color: Color(0x3838BDF8),
                        ),
                        child: const Center(
                          child: Text(
                            'Excluded Lens',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            LabeledSwitch(
              label: 'enabled',
              value: _batchEnabled,
              onChanged: (v) => setState(() => _batchEnabled = v),
            ),
            ChipChoiceRow<LiquidGlassBatchMode>(
              label: 'mode (LiquidGlassBatchMode)',
              value: _batchMode,
              options: const [
                (LiquidGlassBatchMode.separatePass, 'separatePass'),
                (LiquidGlassBatchMode.singlePass, 'singlePass'),
              ],
              onChanged: (v) => setState(() => _batchMode = v),
            ),
            ChipChoiceRow<LiquidGlassBlurMethod>(
              label: 'blurMethod (LiquidGlassBlurMethod)',
              value: _batchBlurMethod,
              options: const [
                (LiquidGlassBlurMethod.engine, 'engine'),
                (LiquidGlassBlurMethod.shader, 'shader'),
              ],
              onChanged: (v) => setState(() => _batchBlurMethod = v),
            ),
            LabeledSwitch(
              label: 'shaderBlurDispersion',
              value: _batchShaderBlurDispersion,
              onChanged: (v) => setState(() => _batchShaderBlurDispersion = v),
            ),
          ],
        ),

        // ── 3. LiquidGlassView & LiquidGlassViewController ──
        ControlPanel(
          title: 'LiquidGlassView & LiquidGlassViewController',
          subtitle:
              'pixelRatio, realTimeCapture, useSync, regionCapture, refreshRate, captureOnce()',
          children: [
            SizedBox(
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: LiquidGlassView(
                  controller: _viewController,
                  pixelRatio: _viewPixelRatio,
                  realTimeCapture: _viewRealTimeCapture,
                  useSync: _viewUseSync,
                  regionCapture: _viewRegionCapture,
                  refreshRate: _viewRefreshRate,
                  batch: _batchEnabled,
                  batchMode: _batchMode,
                  backgroundWidget: const ShowcaseBackground(
                    style: ShowcaseBackdropStyle.geometricGrid,
                    darkTheme: true,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 210,
                      height: 68,
                      child: LiquidGlassLens(
                        style: const LiquidGlassStyle(
                          shape: LiquidGlassShape.continuousRoundedRectangle(
                            cornerRadius: 22,
                          ),
                          refractionIndex: 1.09,
                          refractionWidth: 18,
                          color: Color(0x1EFFFFFF),
                        ),
                        child: Center(
                          child: Text(
                            'View Lens • captures: $_captureCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: () async {
                    await _viewController.captureOnce();
                    if (mounted) setState(() => _captureCount++);
                  },
                  child: const Text('captureOnce()'),
                ),
                OutlinedButton(
                  onPressed: () {
                    _viewController.startRealtimeCapture();
                    setState(() => _viewRealTimeCapture = true);
                  },
                  child: const Text('startRealtimeCapture()'),
                ),
                OutlinedButton(
                  onPressed: () {
                    _viewController.stopRealtimeCapture();
                    setState(() => _viewRealTimeCapture = false);
                  },
                  child: const Text('stopRealtimeCapture()'),
                ),
              ],
            ),
            LabeledSlider(
              label: 'pixelRatio',
              value: _viewPixelRatio,
              min: 0.2,
              max: 1.0,
              onChanged: (v) => setState(() => _viewPixelRatio = v),
            ),
            LabeledSwitch(
              label: 'realTimeCapture',
              value: _viewRealTimeCapture,
              onChanged: (v) => setState(() => _viewRealTimeCapture = v),
            ),
            LabeledSwitch(
              label: 'useSync',
              value: _viewUseSync,
              onChanged: (v) => setState(() => _viewUseSync = v),
            ),
            LabeledSwitch(
              label: 'regionCapture (Skia sync path)',
              value: _viewRegionCapture,
              onChanged: (v) => setState(() => _viewRegionCapture = v),
            ),
            ChipChoiceRow<LiquidGlassRefreshRate>(
              label: 'refreshRate (LiquidGlassRefreshRate)',
              value: _viewRefreshRate,
              options: const [
                (LiquidGlassRefreshRate.low, 'low'),
                (LiquidGlassRefreshRate.medium, 'medium'),
                (LiquidGlassRefreshRate.high, 'high'),
                (
                  LiquidGlassRefreshRate.deviceRefreshRate,
                  'deviceRefreshRate'
                ),
              ],
              onChanged: (v) => setState(() => _viewRefreshRate = v),
            ),
          ],
        ),

        // ── 4. LiquidGlassEngine & LiquidGlassConfiguration ──
        ControlPanel(
          title: 'LiquidGlassEngine & LiquidGlassConfiguration',
          subtitle:
              'Global package switches (active liteGlass: ${LiquidGlassEngine.liteGlass})',
          children: [
            LabeledSwitch(
              label: 'LiquidGlassEngine.liteGlassOnImpeller',
              value: LiquidGlassEngine.liteGlassOnImpeller,
              onChanged: (v) {
                setState(() => LiquidGlassEngine.liteGlassOnImpeller = v);
                widget.onGlobalConfigChanged();
              },
            ),
            LabeledSwitch(
              label: 'LiquidGlassEngine.liteGlassOnSkia',
              value: LiquidGlassEngine.liteGlassOnSkia,
              onChanged: (v) {
                setState(() => LiquidGlassEngine.liteGlassOnSkia = v);
                widget.onGlobalConfigChanged();
              },
            ),
            const Divider(),
            ChipChoiceRow<LiquidGlassBlurMethod>(
              label: 'Configuration.blurMethod',
              value: LiquidGlassConfiguration.blurMethod,
              options: const [
                (LiquidGlassBlurMethod.engine, 'engine'),
                (LiquidGlassBlurMethod.shader, 'shader'),
              ],
              onChanged: (v) {
                setState(() => LiquidGlassConfiguration.blurMethod = v);
                widget.onGlobalConfigChanged();
              },
            ),
            ChipChoiceRow<LiquidGlassBlurMethod>(
              label: 'Configuration.batchBlurMethod',
              value: LiquidGlassConfiguration.batchBlurMethod,
              options: const [
                (LiquidGlassBlurMethod.engine, 'engine'),
                (LiquidGlassBlurMethod.shader, 'shader'),
              ],
              onChanged: (v) {
                setState(() => LiquidGlassConfiguration.batchBlurMethod = v);
                widget.onGlobalConfigChanged();
              },
            ),
            ChipChoiceRow<LiquidGlassBatchMode>(
              label: 'Configuration.batchMode',
              value: LiquidGlassConfiguration.batchMode,
              options: const [
                (LiquidGlassBatchMode.separatePass, 'separatePass'),
                (LiquidGlassBatchMode.singlePass, 'singlePass'),
              ],
              onChanged: (v) {
                setState(() => LiquidGlassConfiguration.batchMode = v);
                widget.onGlobalConfigChanged();
              },
            ),
            LabeledSwitch(
              label: 'Configuration.shaderBlurDispersion',
              value: LiquidGlassConfiguration.shaderBlurDispersion,
              onChanged: (v) {
                setState(
                    () => LiquidGlassConfiguration.shaderBlurDispersion = v);
                widget.onGlobalConfigChanged();
              },
            ),
            LabeledSwitch(
              label: 'Configuration.batchShaderBlurDispersion',
              value: LiquidGlassConfiguration.batchShaderBlurDispersion,
              onChanged: (v) {
                setState(() =>
                    LiquidGlassConfiguration.batchShaderBlurDispersion = v);
                widget.onGlobalConfigChanged();
              },
            ),
            LabeledSwitch(
              label: 'Configuration.shapeCache',
              subtitle: 'Bakes static outlines into a texture on Impeller',
              value: LiquidGlassConfiguration.shapeCache,
              onChanged: (v) {
                setState(() => LiquidGlassConfiguration.shapeCache = v);
                widget.onGlobalConfigChanged();
              },
            ),
            LabeledSwitch(
              label: 'Configuration.rimLiftOnDark',
              subtitle: 'Keep glow visible over dark backdrops',
              value: LiquidGlassConfiguration.rimLiftOnDark,
              onChanged: (v) {
                setState(() => LiquidGlassConfiguration.rimLiftOnDark = v);
                widget.onGlobalConfigChanged();
              },
            ),
            LabeledSwitch(
              label: 'Configuration.blurOverride',
              value: _useBlurOverride,
              onChanged: (v) {
                setState(() => _useBlurOverride = v);
                _syncGlobalConfig();
              },
            ),
            if (_useBlurOverride)
              LabeledSlider(
                label: 'blurOverride value',
                value: _blurOverrideValue,
                min: 0,
                max: 12,
                decimals: 1,
                onChanged: (v) {
                  setState(() => _blurOverrideValue = v);
                  _syncGlobalConfig();
                },
              ),
            LabeledSwitch(
              label: 'Configuration.dispersionOverride',
              value: _useDispersionOverride,
              onChanged: (v) {
                setState(() => _useDispersionOverride = v);
                _syncGlobalConfig();
              },
            ),
            if (_useDispersionOverride)
              LabeledSlider(
                label: 'dispersionOverride value',
                value: _dispersionOverrideValue,
                min: 0,
                max: 10,
                decimals: 1,
                onChanged: (v) {
                  setState(() => _dispersionOverrideValue = v);
                  _syncGlobalConfig();
                },
              ),
            LabeledSwitch(
              label: 'Configuration.shadowColorOverrideLight / Dark',
              subtitle: 'Overrides glass shadow color globally (blue / purple)',
              value: _useShadowColorOverride,
              onChanged: (v) {
                setState(() => _useShadowColorOverride = v);
                _syncGlobalConfig();
              },
            ),
          ],
        ),
      ],
    );
  }
}
