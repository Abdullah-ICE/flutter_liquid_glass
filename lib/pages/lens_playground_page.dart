import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../widgets/control_widgets.dart';

/// Tab 1: Complete interactive playground for:
/// - LiquidGlassLens (visibility, opacity, honorBackdropAlpha, style)
/// - LiquidGlassStyle (refractionIndex, refractionWidth, magnification,
///   dispersion, saturation, blur, color, liteGlass, shadow)
/// - LiquidGlassShape (roundedRectangle, squircle, continuousRoundedRectangle,
///   cornerRadius, clipQuality)
/// - LiquidGlassLight.specular & LiquidGlassLight.glow (every parameter)
/// - LiquidGlassShadow (via style.shadow + standalone wrapper)
/// - LiquidGlassLite (standalone shader-free surface)
/// - LiquidGlassDraggable (enabled, initialOffset, onChanged)
class LensPlaygroundPage extends StatefulWidget {
  const LensPlaygroundPage({super.key});

  @override
  State<LensPlaygroundPage> createState() => _LensPlaygroundPageState();
}

class _LensPlaygroundPageState extends State<LensPlaygroundPage> {
  // ── LiquidGlassLens ──
  bool _visibility = true;
  double _opacity = 1.0;
  bool _honorBackdropAlpha = false;
  bool _draggableEnabled = true;
  Offset _dragOffset = Offset.zero;

  // ── LiquidGlassShape ──
  LiquidGlassCornerStyle _cornerStyle =
      LiquidGlassCornerStyle.continuousRoundedRectangle;
  double _cornerRadius = 36;
  LiquidGlassClipQuality _clipQuality = LiquidGlassClipQuality.roundedRectangle;

  // ── LiquidGlassStyle (Refraction & Fill) ──
  double _refractionIndex = 1.08;
  double _refractionWidth = 22;
  double _magnification = 1.05;
  double _dispersion = 1.3;
  double _saturation = 1.1;
  double _blur = 1.5;
  Color _tintColor = const Color(0x1EFFFFFF);
  bool _liteGlass = false;

  // ── Specular Light ──
  double _specThickness = 5.0;
  double _specSharpness = 0.5;
  double _specAngle = 39.0;
  double _specSpread = 0.9;
  double _specIntensity = 1.0;
  double _specOppositeIntensity = 1.0;
  Color? _specColor;

  // ── Glow Light ──
  bool _glowEnabled = true;
  double _glowThickness = 10.0;
  double _glowAngle = 129.0;
  double _glowSpread = 0.5;
  double _glowIntensity = 0.85;
  double _glowOppositeIntensity = 1.0;
  Color? _glowColor;

  // ── LiquidGlassShadow ──
  bool _shadowEnabled = true;
  double _shadowBlur = 8.0;
  double _shadowOpacity = 0.28;
  Color _shadowColor = Colors.black;
  double _shadowOffsetY = 10.0;
  double _shadowInset = 0.0;
  bool _shadowInsideGlass = true;

  // ── LiquidGlassLite (Standalone) ──
  double _liteBorderAlpha = 1.0;
  double _liteBlur = 4.0;
  double _liteMagnification = 1.05;
  double _liteScaleX = 1.0;
  double _liteScaleY = 1.0;

  LiquidGlassShape get _shape => LiquidGlassShape(
        cornerStyle: _cornerStyle,
        cornerRadius: _cornerRadius,
        clipQuality: _clipQuality,
      );

  LiquidGlassLight get _specular => LiquidGlassLight.specular(
        thickness: _specThickness,
        sharpness: _specSharpness,
        angle: _specAngle,
        spread: _specSpread,
        intensity: _specIntensity,
        oppositeIntensity: _specOppositeIntensity,
        color: _specColor,
      );

  LiquidGlassLight? get _glow => _glowEnabled
      ? LiquidGlassLight.glow(
          thickness: _glowThickness,
          angle: _glowAngle,
          spread: _glowSpread,
          intensity: _glowIntensity,
          oppositeIntensity: _glowOppositeIntensity,
          color: _glowColor,
        )
      : null;

  LiquidGlassShadow? get _shadow => _shadowEnabled
      ? LiquidGlassShadow(
          blur: _shadowBlur,
          opacity: _shadowOpacity,
          color: _shadowColor,
          offset: Offset(0, _shadowOffsetY),
          cornerRadius: _cornerRadius,
          inset: _shadowInset,
          visible: _shadowEnabled,
          insideGlass: _shadowInsideGlass,
        )
      : null;

  LiquidGlassStyle get _style => LiquidGlassStyle(
        shape: _shape,
        specular: _specular,
        glow: _glow,
        refractionIndex: _refractionIndex,
        refractionWidth: _refractionWidth,
        magnification: _magnification,
        dispersion: _dispersion,
        saturation: _saturation,
        blur: _blur,
        color: _tintColor,
        shadow: _shadow,
        liteGlass: _liteGlass,
      );

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top + 82;
    final double bottomInset = MediaQuery.paddingOf(context).bottom + 110;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, topInset, 16, bottomInset),
      children: [
        // ── Live Lens Stage (Draggable) ──
        SizedBox(
          height: 210,
          child: Center(
            child: LiquidGlassDraggable(
              enabled: _draggableEnabled,
              initialOffset: Offset.zero,
              onChanged: (off) => setState(() => _dragOffset = off),
              child: SizedBox(
                width: 280,
                height: 150,
                child: LiquidGlassLens(
                  style: _style,
                  visibility: _visibility,
                  opacity: _opacity,
                  honorBackdropAlpha: _honorBackdropAlpha,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _liteGlass ? 'LiquidGlassLens (Lite)' : 'LiquidGlassLens',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(blurRadius: 6, color: Colors.black54),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _draggableEnabled
                              ? 'Drag me • offset (${_dragOffset.dx.round()}, ${_dragOffset.dy.round()})'
                              : 'Draggable disabled',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Standalone LiquidGlassLite + Standalone LiquidGlassShadow ──
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: LiquidGlassShadow(
              blur: _shadowBlur,
              opacity: _shadowOpacity,
              color: _shadowColor,
              offset: Offset(0, _shadowOffsetY),
              cornerRadius: 24,
              scale: Offset(_liteScaleX, _liteScaleY),
              inset: _shadowInset,
              visible: _shadowEnabled,
              insideGlass: _shadowInsideGlass,
              child: SizedBox(
                width: 280,
                height: 84,
                child: LiquidGlassLite(
                  shape: LiquidGlassShape(
                    cornerStyle: _cornerStyle,
                    cornerRadius: 24,
                    clipQuality: _clipQuality,
                  ),
                  specular: _specular,
                  glow: _glow,
                  borderAlpha: _liteBorderAlpha,
                  blur: _liteBlur,
                  magnification: _liteMagnification,
                  color: _tintColor,
                  shapeScale: Offset(_liteScaleX, _liteScaleY),
                  child: const Center(
                    child: Text(
                      'Standalone LiquidGlassLite + LiquidGlassShadow',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── 1. Lens & Draggable ──
        ControlPanel(
          title: 'LiquidGlassLens & LiquidGlassDraggable',
          subtitle: 'visibility, opacity, honorBackdropAlpha, liteGlass, draggable',
          children: [
            LabeledSwitch(
              label: 'visibility',
              subtitle: 'Instant show/hide (no backdrop cost when false)',
              value: _visibility,
              onChanged: (v) => setState(() => _visibility = v),
            ),
            LabeledSlider(
              label: 'opacity',
              value: _opacity,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _opacity = v),
            ),
            LabeledSwitch(
              label: 'style.liteGlass',
              subtitle: 'Shader-free frost + tint + painted rim for this lens',
              value: _liteGlass,
              onChanged: (v) => setState(() => _liteGlass = v),
            ),
            LabeledSwitch(
              label: 'honorBackdropAlpha (Skia)',
              value: _honorBackdropAlpha,
              onChanged: (v) => setState(() => _honorBackdropAlpha = v),
            ),
            LabeledSwitch(
              label: 'LiquidGlassDraggable.enabled',
              value: _draggableEnabled,
              onChanged: (v) => setState(() => _draggableEnabled = v),
            ),
          ],
        ),

        // ── 2. LiquidGlassShape ──
        ControlPanel(
          title: 'LiquidGlassShape',
          subtitle: 'cornerStyle, cornerRadius, clipQuality',
          children: [
            ChipChoiceRow<LiquidGlassCornerStyle>(
              label: 'cornerStyle',
              value: _cornerStyle,
              options: const [
                (LiquidGlassCornerStyle.roundedRectangle, 'roundedRectangle'),
                (LiquidGlassCornerStyle.squircle, 'squircle'),
                (
                  LiquidGlassCornerStyle.continuousRoundedRectangle,
                  'continuousRoundedRect'
                ),
              ],
              onChanged: (v) => setState(() => _cornerStyle = v),
            ),
            LabeledSlider(
              label: 'cornerRadius',
              value: _cornerRadius,
              min: 0,
              max: 75,
              decimals: 0,
              suffix: ' px',
              onChanged: (v) => setState(() => _cornerRadius = v),
            ),
            ChipChoiceRow<LiquidGlassClipQuality>(
              label: 'clipQuality',
              value: _clipQuality,
              options: const [
                (LiquidGlassClipQuality.roundedRectangle, 'roundedRectangle'),
                (LiquidGlassClipQuality.exact, 'exact'),
              ],
              onChanged: (v) => setState(() => _clipQuality = v),
            ),
          ],
        ),

        // ── 3. Refraction & Appearance ──
        ControlPanel(
          title: 'LiquidGlassStyle — Refraction & Fill',
          subtitle:
              'refractionIndex, refractionWidth, magnification, dispersion, saturation, blur, color',
          children: [
            LabeledSlider(
              label: 'refractionIndex',
              value: _refractionIndex,
              min: 1.0,
              max: 1.6,
              decimals: 3,
              onChanged: (v) => setState(() => _refractionIndex = v),
            ),
            LabeledSlider(
              label: 'refractionWidth',
              value: _refractionWidth,
              min: 0,
              max: 60,
              decimals: 1,
              suffix: ' px',
              onChanged: (v) => setState(() => _refractionWidth = v),
            ),
            LabeledSlider(
              label: 'magnification',
              value: _magnification,
              min: 0.7,
              max: 1.5,
              decimals: 2,
              suffix: 'x',
              onChanged: (v) => setState(() => _magnification = v),
            ),
            LabeledSlider(
              label: 'dispersion (chromatic fringe)',
              value: _dispersion,
              min: 0,
              max: 13,
              decimals: 2,
              suffix: ' px',
              onChanged: (v) => setState(() => _dispersion = v),
            ),
            LabeledSlider(
              label: 'saturation',
              value: _saturation,
              min: 0,
              max: 2.5,
              decimals: 2,
              onChanged: (v) => setState(() => _saturation = v),
            ),
            LabeledSlider(
              label: 'blur (Gaussian sigma)',
              value: _blur,
              min: 0,
              max: 14,
              decimals: 1,
              onChanged: (v) => setState(() => _blur = v),
            ),
            ColorSwatchRow(
              label: 'color (tint)',
              value: _tintColor,
              swatches: const [
                (Colors.transparent, 'Clear'),
                (Color(0x1EFFFFFF), 'Frost'),
                (Color(0x40000000), 'Smoke'),
                (Color(0x4038BDF8), 'Cyan'),
                (Color(0x40EC4899), 'Pink'),
                (Color(0x40F59E0B), 'Amber'),
              ],
              onChanged: (c) =>
                  setState(() => _tintColor = c ?? Colors.transparent),
            ),
          ],
        ),

        // ── 4. Specular Light ──
        ControlPanel(
          title: 'LiquidGlassLight.specular',
          subtitle:
              'thickness, sharpness, angle, spread, intensity, oppositeIntensity, color',
          children: [
            LabeledSlider(
              label: 'thickness',
              value: _specThickness,
              min: 0,
              max: 20,
              decimals: 1,
              suffix: ' px',
              onChanged: (v) => setState(() => _specThickness = v),
            ),
            LabeledSlider(
              label: 'sharpness',
              value: _specSharpness,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _specSharpness = v),
            ),
            LabeledSlider(
              label: 'angle',
              value: _specAngle,
              min: 0,
              max: 360,
              decimals: 0,
              suffix: '°',
              onChanged: (v) => setState(() => _specAngle = v),
            ),
            LabeledSlider(
              label: 'spread',
              value: _specSpread,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _specSpread = v),
            ),
            LabeledSlider(
              label: 'intensity',
              value: _specIntensity,
              min: 0,
              max: 3,
              onChanged: (v) => setState(() => _specIntensity = v),
            ),
            LabeledSlider(
              label: 'oppositeIntensity',
              value: _specOppositeIntensity,
              min: 0,
              max: 2,
              onChanged: (v) => setState(() => _specOppositeIntensity = v),
            ),
            ColorSwatchRow(
              label: 'specular.color (null = auto backdrop color)',
              value: _specColor,
              swatches: const [
                (null, 'Auto'),
                (Colors.white, 'White'),
                (Color(0xFFFF3B30), 'Red'),
                (Color(0xFF38BDF8), 'Sky'),
                (Color(0xFFFBBF24), 'Gold'),
              ],
              onChanged: (c) => setState(() => _specColor = c),
            ),
          ],
        ),

        // ── 5. Glow Light ──
        ControlPanel(
          title: 'LiquidGlassLight.glow',
          subtitle:
              'thickness, angle, spread, intensity, oppositeIntensity, color',
          trailing: Switch.adaptive(
            value: _glowEnabled,
            onChanged: (v) => setState(() => _glowEnabled = v),
          ),
          children: _glowEnabled
              ? [
                  LabeledSlider(
                    label: 'thickness',
                    value: _glowThickness,
                    min: 0,
                    max: 28,
                    decimals: 1,
                    suffix: ' px',
                    onChanged: (v) => setState(() => _glowThickness = v),
                  ),
                  LabeledSlider(
                    label: 'angle',
                    value: _glowAngle,
                    min: 0,
                    max: 360,
                    decimals: 0,
                    suffix: '°',
                    onChanged: (v) => setState(() => _glowAngle = v),
                  ),
                  LabeledSlider(
                    label: 'spread',
                    value: _glowSpread,
                    min: 0,
                    max: 1,
                    onChanged: (v) => setState(() => _glowSpread = v),
                  ),
                  LabeledSlider(
                    label: 'intensity',
                    value: _glowIntensity,
                    min: 0,
                    max: 3,
                    onChanged: (v) => setState(() => _glowIntensity = v),
                  ),
                  LabeledSlider(
                    label: 'oppositeIntensity',
                    value: _glowOppositeIntensity,
                    min: 0,
                    max: 2,
                    onChanged: (v) => setState(() => _glowOppositeIntensity = v),
                  ),
                  ColorSwatchRow(
                    label: 'glow.color (null = auto backdrop color)',
                    value: _glowColor,
                    swatches: const [
                      (null, 'Auto'),
                      (Colors.white, 'White'),
                      (Color(0xFF34D399), 'Emerald'),
                      (Color(0xFFA855F7), 'Violet'),
                      (Color(0xFFF43F5E), 'Rose'),
                    ],
                    onChanged: (c) => setState(() => _glowColor = c),
                  ),
                ]
              : const [Text('Glow disabled (null)', style: TextStyle(fontSize: 12))],
        ),

        // ── 6. LiquidGlassShadow ──
        ControlPanel(
          title: 'LiquidGlassShadow',
          subtitle: 'blur, opacity, color, offset, inset, visible, insideGlass',
          trailing: Switch.adaptive(
            value: _shadowEnabled,
            onChanged: (v) => setState(() => _shadowEnabled = v),
          ),
          children: _shadowEnabled
              ? [
                  LabeledSlider(
                    label: 'blur',
                    value: _shadowBlur,
                    min: 0,
                    max: 30,
                    decimals: 1,
                    onChanged: (v) => setState(() => _shadowBlur = v),
                  ),
                  LabeledSlider(
                    label: 'opacity',
                    value: _shadowOpacity,
                    min: 0,
                    max: 0.8,
                    onChanged: (v) => setState(() => _shadowOpacity = v),
                  ),
                  LabeledSlider(
                    label: 'offset.dy',
                    value: _shadowOffsetY,
                    min: -10,
                    max: 30,
                    decimals: 1,
                    suffix: ' px',
                    onChanged: (v) => setState(() => _shadowOffsetY = v),
                  ),
                  LabeledSlider(
                    label: 'inset',
                    value: _shadowInset,
                    min: 0,
                    max: 16,
                    decimals: 1,
                    suffix: ' px',
                    onChanged: (v) => setState(() => _shadowInset = v),
                  ),
                  LabeledSwitch(
                    label: 'insideGlass',
                    subtitle: 'true = behind glass, false = exterior-only over glass',
                    value: _shadowInsideGlass,
                    onChanged: (v) => setState(() => _shadowInsideGlass = v),
                  ),
                  ColorSwatchRow(
                    label: 'shadow.color',
                    value: _shadowColor,
                    swatches: const [
                      (Colors.black, 'Black'),
                      (Color(0xFF1E3A8A), 'Navy'),
                      (Color(0xFF581C87), 'Purple'),
                      (Color(0xFF7C2D12), 'Rust'),
                    ],
                    onChanged: (c) =>
                        setState(() => _shadowColor = c ?? Colors.black),
                  ),
                ]
              : const [Text('Shadow disabled', style: TextStyle(fontSize: 12))],
        ),

        // ── 7. LiquidGlassLite Controls ──
        ControlPanel(
          title: 'LiquidGlassLite (Standalone)',
          subtitle: 'borderAlpha, blur, magnification, shapeScale',
          children: [
            LabeledSlider(
              label: 'borderAlpha',
              value: _liteBorderAlpha,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _liteBorderAlpha = v),
            ),
            LabeledSlider(
              label: 'blur',
              value: _liteBlur,
              min: 0,
              max: 15,
              decimals: 1,
              onChanged: (v) => setState(() => _liteBlur = v),
            ),
            LabeledSlider(
              label: 'magnification',
              value: _liteMagnification,
              min: 0.8,
              max: 1.4,
              onChanged: (v) => setState(() => _liteMagnification = v),
            ),
            LabeledSlider(
              label: 'shapeScale.dx',
              value: _liteScaleX,
              min: 0.7,
              max: 1.3,
              onChanged: (v) => setState(() => _liteScaleX = v),
            ),
            LabeledSlider(
              label: 'shapeScale.dy',
              value: _liteScaleY,
              min: 0.7,
              max: 1.3,
              onChanged: (v) => setState(() => _liteScaleY = v),
            ),
          ],
        ),
      ],
    );
  }
}
