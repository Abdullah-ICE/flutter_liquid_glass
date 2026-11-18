import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../widgets/control_widgets.dart';

/// Tab 4: Complete interactive playground for:
/// - LiquidGlassAdaptivity (all properties + .none opt-out)
/// - LiquidGlassAdaptiveSampling (pixelRatio, frameLimit, minimumRegionSamples)
/// - LiquidGlassAdaptiveArea (systemChrome, debugBounds, publish link)
/// - LiquidGlassAdaptivityLink (external follower lens)
/// - LiquidGlassAdaptivityController (enable, disable, adaptOnce)
/// - LiquidGlassAdaptiveContent (child + custom builder)
/// - LiquidGlassScrollEdge (top/bottom, soft/hard, blur, curve, blurCurve)
class AdaptivityEdgePage extends StatefulWidget {
  const AdaptivityEdgePage({super.key});

  @override
  State<AdaptivityEdgePage> createState() => _AdaptivityEdgePageState();
}

class _AdaptivityEdgePageState extends State<AdaptivityEdgePage> {
  final LiquidGlassAdaptivityLink _sharedLink = LiquidGlassAdaptivityLink();
  final LiquidGlassAdaptivityController _adaptController =
      LiquidGlassAdaptivityController(enabled: true);

  // ── LiquidGlassAdaptivity ──
  Brightness? _permanentBrightness;
  LiquidGlassBrightnessFallback _brightnessFallback =
      LiquidGlassBrightnessFallback.appTheme;
  bool _continuousGlassColor = false;
  double _darkBelow = 0.55;
  double _lightAbove = 0.65;
  double _durationMs = 300;

  // ── LiquidGlassAdaptiveArea ──
  LiquidGlassSystemChrome _systemChrome = LiquidGlassSystemChrome.none;
  bool _areaDebugBounds = false;

  // ── LiquidGlassAdaptiveSampling ──
  double _samplePixelRatio = 0.05;
  double _sampleFrameLimit = 8;
  int _minRegionSamples = 8;

  // ── LiquidGlassScrollEdge ──
  LiquidGlassScrollEdgeStyle _edgeStyle = LiquidGlassScrollEdgeStyle.soft;
  double _edgeBlur = 5.0;
  double _edgeHeight = 96.0;
  bool _edgeUseAdaptive = true;

  @override
  void dispose() {
    _sharedLink.dispose();
    _adaptController.dispose();
    super.dispose();
  }

  LiquidGlassAdaptivity get _baseAdaptivity => LiquidGlassAdaptivity(
        glassColorOnDark: const Color(0x40000000),
        contentColorOnDark: Colors.white,
        glassColorOnLight: const Color(0x66FFFFFF),
        contentColorOnLight: const Color(0xFF1C1C1E),
        duration: Duration(milliseconds: _durationMs.round()),
        permanentBrightness: _permanentBrightness,
        initialBrightness: Brightness.dark,
        brightnessFallback: _brightnessFallback,
        controller: _adaptController,
        darkBelow: _darkBelow,
        lightAbove: _lightAbove,
        continuousGlassColor: _continuousGlassColor,
      );

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top + 82;
    final double bottomInset = MediaQuery.paddingOf(context).bottom + 110;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, topInset, 16, bottomInset),
      children: [
        // ── Live Scrollable Adaptivity & ScrollEdge Stage ──
        Container(
          height: 360,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: LiquidGlassView(
              adaptiveSampling: LiquidGlassAdaptiveSampling(
                pixelRatio: _samplePixelRatio,
                frameLimit: _sampleFrameLimit,
                minimumRegionSamples: _minRegionSamples,
              ),
              backgroundWidget: ListView(
                padding: EdgeInsets.zero,
                children: const [
                  _BandCard(
                    title: 'DARK BAND #1 — Scroll up & down!',
                    subtitle: 'Glass turns smoked dark, text turns crisp white',
                    bg: Color(0xFF0B0F1A),
                    fg: Colors.white,
                    accent: Color(0xFF38BDF8),
                  ),
                  _BandCard(
                    title: 'BRIGHT BAND #2 — White Paper',
                    subtitle: 'Glass turns milky light, text flips to dark ink',
                    bg: Color(0xFFF8FAFC),
                    fg: Color(0xFF0F172A),
                    accent: Color(0xFFEC4899),
                  ),
                  _BandCard(
                    title: 'DEEP NIGHT BAND #3',
                    subtitle: 'Scroll slowly to watch continuousGlassColor glide',
                    bg: Color(0xFF18181B),
                    fg: Colors.white,
                    accent: Color(0xFF10B981),
                  ),
                  _BandCard(
                    title: 'WARM DAYLIGHT BAND #4',
                    subtitle: 'Soft pastel cream triggers light verdict',
                    bg: Color(0xFFFEF3C7),
                    fg: Color(0xFF451A03),
                    accent: Color(0xFFF59E0B),
                  ),
                  _BandCard(
                    title: 'MID-GREY HYSTERESIS TEST #5',
                    subtitle: 'Tests darkBelow..lightAbove anti-strobe band',
                    bg: Color(0xFF888888),
                    fg: Colors.white,
                    accent: Color(0xFFA855F7),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Top Scroll Edge
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: _edgeHeight,
                    child: LiquidGlassScrollEdge(
                      edge: LiquidGlassEdge.top,
                      height: _edgeHeight,
                      color: const Color(0x88000000),
                      adaptivity: _edgeUseAdaptive ? _baseAdaptivity : null,
                      blur: _edgeBlur,
                      curve: Curves.easeInOut,
                      blurCurve: LiquidGlassScrollEdge.defaultBlurCurve,
                      style: _edgeStyle,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: LiquidGlassAdaptiveContent(
                            adaptivity: _baseAdaptivity,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.layers_rounded, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Top LiquidGlassScrollEdge + AdaptiveContent',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Adaptive Area (publishes to _sharedLink)
                  Positioned(
                    left: 14,
                    top: 56,
                    right: 14,
                    child: IgnorePointer(
                      child: LiquidGlassAdaptiveArea(
                        adaptivity: _baseAdaptivity.copyWith(link: _sharedLink),
                        systemChrome: _systemChrome,
                        debugBounds: _areaDebugBounds,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 54,
                                child: LiquidGlassLens(
                                  style: const LiquidGlassStyle(
                                    shape: LiquidGlassShape
                                        .continuousRoundedRectangle(
                                      cornerRadius: 18,
                                    ),
                                    blur: 2.5,
                                  ),
                                  child: const Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.brightness_auto_rounded,
                                            size: 18),
                                        SizedBox(width: 6),
                                        Text(
                                          'Inside Area',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Opt-out via LiquidGlassAdaptivity.none
                            SizedBox(
                              width: 112,
                              height: 54,
                              child: LiquidGlassLens(
                                style: const LiquidGlassStyle(
                                  shape: LiquidGlassShape
                                      .continuousRoundedRectangle(
                                    cornerRadius: 18,
                                  ),
                                  color: Color(0x660EA5E9),
                                  blur: 2.0,
                                  adaptivity: LiquidGlassAdaptivity.none,
                                ),
                                child: const Center(
                                  child: Text(
                                    '.none Opt-Out',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom Scroll Edge + External Link Follower + Builder AdaptiveContent
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: _edgeHeight + 24,
                    child: LiquidGlassScrollEdge(
                      edge: LiquidGlassEdge.bottom,
                      color: const Color(0x88000000),
                      adaptivity: _edgeUseAdaptive ? _baseAdaptivity : null,
                      blur: _edgeBlur,
                      style: _edgeStyle,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                          child: Row(
                            children: [
                              // Follower via LiquidGlassAdaptivityLink (outside area!)
                              Expanded(
                                child: IgnorePointer(
                                  child: SizedBox(
                                    height: 48,
                                    child: LiquidGlassLens(
                                      style: LiquidGlassStyle(
                                        shape: const LiquidGlassShape
                                            .continuousRoundedRectangle(
                                          cornerRadius: 16,
                                        ),
                                        blur: 2.5,
                                        adaptivity: _baseAdaptivity.copyWith(
                                          link: _sharedLink,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Linked Follower (mirrors Area)',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Custom builder LiquidGlassAdaptiveContent
                              IgnorePointer(
                                child: LiquidGlassAdaptiveContent(
                                  adaptivity: _baseAdaptivity,
                                  builder: (context, color, brightness) =>
                                      Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                          color: color.withValues(alpha: 0.5)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          brightness == Brightness.dark
                                              ? Icons.dark_mode_rounded
                                              : Icons.light_mode_rounded,
                                          color: color,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          brightness.name.toUpperCase(),
                                          style: TextStyle(
                                            color: color,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Controller Controls ──
        ControlPanel(
          title: 'LiquidGlassAdaptivityController',
          subtitle: 'Pause/resume continuous sampling or trigger adaptOnce()',
          children: [
            ListenableBuilder(
              listenable: _adaptController,
              builder: (context, _) => Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton.tonal(
                    onPressed: _adaptController.enabled
                        ? _adaptController.disable
                        : _adaptController.enable,
                    child: Text(
                      _adaptController.enabled
                          ? 'disable() — Pause'
                          : 'enable() — Resume',
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _adaptController.enabled
                        ? null
                        : _adaptController.adaptOnce,
                    child: Text(
                      'adaptOnce() (gen: ${_adaptController.refreshGeneration})',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ── LiquidGlassAdaptivity & Area Controls ──
        ControlPanel(
          title: 'LiquidGlassAdaptivity & LiquidGlassAdaptiveArea',
          subtitle:
              'permanentBrightness, continuousGlassColor, thresholds, duration, fallback, systemChrome',
          children: [
            ChipChoiceRow<Brightness?>(
              label: 'permanentBrightness (manual override)',
              value: _permanentBrightness,
              options: const [
                (null, 'Auto Sample'),
                (Brightness.dark, 'Brightness.dark'),
                (Brightness.light, 'Brightness.light'),
              ],
              onChanged: (v) => setState(() => _permanentBrightness = v),
            ),
            LabeledSwitch(
              label: 'continuousGlassColor',
              subtitle:
                  'Glides glass tint continuously along CIE L* lightness',
              value: _continuousGlassColor,
              onChanged: (v) => setState(() => _continuousGlassColor = v),
            ),
            LabeledSlider(
              label: 'darkBelow threshold',
              value: _darkBelow,
              min: 0.1,
              max: _lightAbove,
              onChanged: (v) => setState(() => _darkBelow = v),
            ),
            LabeledSlider(
              label: 'lightAbove threshold',
              value: _lightAbove,
              min: _darkBelow,
              max: 0.9,
              onChanged: (v) => setState(() => _lightAbove = v),
            ),
            LabeledSlider(
              label: 'duration',
              value: _durationMs,
              min: 50,
              max: 1000,
              decimals: 0,
              suffix: ' ms',
              onChanged: (v) => setState(() => _durationMs = v),
            ),
            ChipChoiceRow<LiquidGlassBrightnessFallback>(
              label: 'brightnessFallback',
              value: _brightnessFallback,
              options: const [
                (LiquidGlassBrightnessFallback.appTheme, 'appTheme'),
                (LiquidGlassBrightnessFallback.platform, 'platform'),
              ],
              onChanged: (v) => setState(() => _brightnessFallback = v),
            ),
            ChipChoiceRow<LiquidGlassSystemChrome>(
              label: 'Area.systemChrome (LiquidGlassSystemChrome)',
              value: _systemChrome,
              options: const [
                (LiquidGlassSystemChrome.none, 'none'),
                (LiquidGlassSystemChrome.statusBar, 'statusBar'),
                (LiquidGlassSystemChrome.navigationBar, 'navigationBar'),
                (LiquidGlassSystemChrome.both, 'both'),
              ],
              onChanged: (v) => setState(() => _systemChrome = v),
            ),
            LabeledSwitch(
              label: 'Area.debugBounds (cyan outline)',
              value: _areaDebugBounds,
              onChanged: (v) => setState(() => _areaDebugBounds = v),
            ),
          ],
        ),

        // ── LiquidGlassScrollEdge & AdaptiveSampling ──
        ControlPanel(
          title: 'LiquidGlassScrollEdge & LiquidGlassAdaptiveSampling',
          subtitle: 'style (soft/hard), blur, height, sampling tuning',
          children: [
            ChipChoiceRow<LiquidGlassScrollEdgeStyle>(
              label: 'ScrollEdge.style',
              value: _edgeStyle,
              options: const [
                (LiquidGlassScrollEdgeStyle.soft, 'soft (feathered)'),
                (LiquidGlassScrollEdgeStyle.hard, 'hard (uniform)'),
              ],
              onChanged: (v) => setState(() => _edgeStyle = v),
            ),
            LabeledSwitch(
              label: 'ScrollEdge adaptive tint',
              value: _edgeUseAdaptive,
              onChanged: (v) => setState(() => _edgeUseAdaptive = v),
            ),
            LabeledSlider(
              label: 'ScrollEdge.blur',
              value: _edgeBlur,
              min: 0,
              max: 14,
              decimals: 1,
              onChanged: (v) => setState(() => _edgeBlur = v),
            ),
            LabeledSlider(
              label: 'ScrollEdge.height',
              value: _edgeHeight,
              min: 48,
              max: 140,
              decimals: 0,
              suffix: ' px',
              onChanged: (v) => setState(() => _edgeHeight = v),
            ),
            const Divider(),
            LabeledSlider(
              label: 'AdaptiveSampling.pixelRatio',
              value: _samplePixelRatio,
              min: 0.02,
              max: 0.25,
              onChanged: (v) => setState(() => _samplePixelRatio = v),
            ),
            LabeledSlider(
              label: 'AdaptiveSampling.frameLimit',
              value: _sampleFrameLimit,
              min: 1,
              max: 24,
              decimals: 0,
              suffix: ' fps',
              onChanged: (v) => setState(() => _sampleFrameLimit = v),
            ),
            LabeledSlider(
              label: 'AdaptiveSampling.minimumRegionSamples',
              value: _minRegionSamples.toDouble(),
              min: 2,
              max: 24,
              divisions: 22,
              decimals: 0,
              onChanged: (v) => setState(() => _minRegionSamples = v.round()),
            ),
          ],
        ),
      ],
    );
  }
}

class _BandCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bg;
  final Color fg;
  final Color accent;

  const _BandCard({
    required this.title,
    required this.subtitle,
    required this.bg,
    required this.fg,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: bg,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 6,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: fg,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: fg.withValues(alpha: 0.72),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
