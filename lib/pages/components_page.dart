import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../widgets/control_widgets.dart';

/// Tab 5: Complete interactive showcase of every drop-in component:
/// - LiquidGlassSlider + LiquidGlassSliderLayout + LiquidGlassLensMotionSpec
/// - LiquidGlassSwitch + LiquidGlassSwitchLayout
/// - LiquidGlassButton (standard, custom child, flexing touch)
/// - LiquidGlassFab & LiquidGlassFab.extended
/// - LiquidGlassMotionPill (standalone interactive drag track)
/// - showLiquidGlassDialog, LiquidGlassAlertDialog, LiquidGlassDialog
/// - showLiquidGlassSheet, LiquidGlassSheet (floating, attached, expandable)
/// - Live LiquidGlassTabBar & LiquidGlassScaffold chrome controls
class ComponentsPage extends StatefulWidget {
  final LiquidGlassPillMode pillMode;
  final bool confinePillToBar;
  final bool enableSwell;
  final bool enableMagnifierPill;
  final Axis tabItemAxis;
  final bool tabBarJoinBatch;
  final ValueChanged<LiquidGlassPillMode> onPillModeChanged;
  final ValueChanged<bool> onConfinePillChanged;
  final ValueChanged<bool> onEnableSwellChanged;
  final ValueChanged<bool> onEnableMagnifierChanged;
  final ValueChanged<Axis> onTabItemAxisChanged;
  final ValueChanged<bool> onTabBarJoinBatchChanged;

  const ComponentsPage({
    super.key,
    required this.pillMode,
    required this.confinePillToBar,
    required this.enableSwell,
    required this.enableMagnifierPill,
    required this.tabItemAxis,
    required this.tabBarJoinBatch,
    required this.onPillModeChanged,
    required this.onConfinePillChanged,
    required this.onEnableSwellChanged,
    required this.onEnableMagnifierChanged,
    required this.onTabItemAxisChanged,
    required this.onTabBarJoinBatchChanged,
  });

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  // ── Slider ──
  double _sliderValue = 0.62;
  String _sliderEvent = 'Idle';
  bool _sliderContinuous = true;
  double _motionMaxDeform = 0.30;
  double _motionSensitivity = 0.00007;

  // ── Switch ──
  bool _switchA = true;
  bool _switchB = false;
  bool _reserveSwellRoom = false;

  // ── Buttons / FAB ──
  int _buttonTaps = 0;
  bool _buttonsVisible = true;

  // ── Standalone LiquidGlassMotionPill ──
  Offset _pillCenter = const Offset(140, 44);
  bool _pillActive = false;
  bool _pillGlassVisible = false;

  // ── Dialog / Sheet options ──
  bool _modalBatch = false;
  bool _sheetGrabber = true;
  bool _sheetAvoidKeyboard = true;

  void _openAlertDialog() {
    showLiquidGlassDialog<bool>(
      context: context,
      batch: _modalBatch,
      builder: (ctx) => LiquidGlassAlertDialog(
        icon: const Icon(Icons.auto_awesome_rounded),
        iconColor: const Color(0xFF38BDF8),
        title: const Text('LiquidGlassAlertDialog'),
        content: const Text(
          'Presented via showLiquidGlassDialog with tuned scale transition, '
          'custom icon, scrollable support, and optional scaffold batching.',
        ),
        scrollable: true,
        actions: [
          LiquidGlassButton(
            label: 'Cancel',
            height: 42,
            touch: const LiquidGlassTouch.flexing(LiquidGlassFlex.subtle()),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          LiquidGlassButton(
            label: 'Confirm',
            height: 42,
            touch: const LiquidGlassTouch.flexing(LiquidGlassFlex.pronounced()),
            style: LiquidGlassButton.defaultStyle.copyWith(
              color: const Color(0x700EA5E9),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
  }

  void _openCustomDialog() {
    showLiquidGlassDialog<void>(
      context: context,
      batch: _modalBatch,
      builder: (ctx) => LiquidGlassDialog(
        width: 320,
        padding: const EdgeInsets.all(22),
        alignment: Alignment.center,
        style: LiquidGlassDialog.defaultStyle.copyWith(
          shape: const LiquidGlassShape.squircle(cornerRadius: 32),
          blur: 4,
          dispersion: 1.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.diamond_rounded, color: Colors.amber, size: 36),
            const SizedBox(height: 10),
            const Text(
              'Custom LiquidGlassDialog',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Uses LiquidGlassDialog directly with squircle shape & chromatic dispersion.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            LiquidGlassButton(
              label: 'Close',
              height: 42,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void _openSheet(LiquidGlassSheetAnchor anchor) {
    showLiquidGlassSheet<void>(
      context: context,
      anchor: anchor,
      grabber: _sheetGrabber,
      avoidKeyboard: _sheetAvoidKeyboard,
      isScrollControlled: true,
      batch: _modalBatch,
      touch: const LiquidGlassTouch.flexing(LiquidGlassFlex.subtle()),
      header: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
        child: Row(
          children: [
            const Icon(Icons.layers_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'LiquidGlassSheet (${anchor.name})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      style: LiquidGlassSheet.defaultStyle.copyWith(
        color: const Color(0x34FFFFFF),
        blur: 4,
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Supports floating & attached anchors, grabber, header, touch flex, '
            'scaffold batching, and automatic keyboard avoidance.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 14),
          TextField(
            decoration: InputDecoration(
              hintText: 'Test avoidKeyboard here...',
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          LiquidGlassButton(
            label: 'Done',
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _openExpandableSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.88,
        snap: true,
        snapSizes: const [0.45, 0.88],
        builder: (ctx, scrollController) => LiquidGlassSheet(
          anchor: LiquidGlassSheetAnchor.attached,
          grabber: true,
          grabberSize: const Size(44, 5),
          safeArea: true,
          header: const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Text(
              'Expandable DraggableScrollableSheet',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: 15,
            itemBuilder: (_, i) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white24,
                child: Text('${i + 1}'),
              ),
              title: Text('Glass Sheet Row #${i + 1}'),
              subtitle: const Text('Drag up to expand to 88% height'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top + 82;
    final double bottomInset = MediaQuery.paddingOf(context).bottom + 110;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, topInset, 16, bottomInset),
      children: [
        // ── 1. LiquidGlassSlider ──
        ControlPanel(
          title: 'LiquidGlassSlider & LiquidGlassSliderLayout',
          subtitle:
              'value: ${_sliderValue.toStringAsFixed(2)} • event: $_sliderEvent',
          children: [
            Center(
              child: LiquidGlassSlider(
                value: _sliderValue,
                minimumValue: 0,
                maximumValue: 1,
                isContinuous: _sliderContinuous,
                activeColor: const Color(0xFF0088FF),
                inactiveColor: Colors.white24,
                thumbColor: Colors.white,
                width: 316,
                layout: const LiquidGlassSliderLayout(
                  trackHeight: 7,
                  thumbWidth: 38,
                  thumbHeight: 24,
                  liftedThumbWidth: 58,
                  liftedThumbHeight: 38,
                  iconSize: 20,
                  iconGap: 10,
                ),
                motion: LiquidGlassLensMotionSpec(
                  sampleWindow: 0.3,
                  sensitivity: _motionSensitivity,
                  maxDeformation: _motionMaxDeform,
                  responseTime: 0.18,
                ),
                minimumIcon: const Icon(Icons.volume_mute_rounded,
                    color: Colors.white70),
                maximumIcon: const Icon(Icons.volume_up_rounded,
                    color: Colors.white),
                style: LiquidGlassSlider.defaultStyle.copyWith(
                  dispersion: 1.2,
                ),
                onChangeStart: (v) =>
                    setState(() => _sliderEvent = 'Start (${v.toStringAsFixed(2)})'),
                onChanged: (v) => setState(() {
                  _sliderValue = v;
                  _sliderEvent = 'Changed (${v.toStringAsFixed(2)})';
                }),
                onChangeEnd: (v) =>
                    setState(() => _sliderEvent = 'End (${v.toStringAsFixed(2)})'),
              ),
            ),
            LabeledSwitch(
              label: 'isContinuous',
              value: _sliderContinuous,
              onChanged: (v) => setState(() => _sliderContinuous = v),
            ),
            LabeledSlider(
              label: 'motion.maxDeformation',
              value: _motionMaxDeform,
              min: 0,
              max: 0.5,
              onChanged: (v) => setState(() => _motionMaxDeform = v),
            ),
            LabeledSlider(
              label: 'motion.sensitivity (×1e-5)',
              value: _motionSensitivity * 1e5,
              min: 0,
              max: 15,
              decimals: 1,
              onChanged: (v) => setState(() => _motionSensitivity = v / 1e5),
            ),
          ],
        ),

        // ── 2. LiquidGlassSwitch ──
        ControlPanel(
          title: 'LiquidGlassSwitch & LiquidGlassSwitchLayout',
          subtitle:
              'Drag, tap, or overshoot the thumb — refracts its own track on all engines',
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    LiquidGlassSwitch(
                      value: _switchA,
                      activeColor: const Color(0xFF34C759),
                      inactiveColor: Colors.white24,
                      thumbColor: Colors.white,
                      reserveSwellRoom: _reserveSwellRoom,
                      onChanged: (v) => setState(() => _switchA = v),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Default (${_switchA ? "ON" : "OFF"})',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    LiquidGlassSwitch(
                      value: _switchB,
                      activeColor: const Color(0xFF0A84FF),
                      inactiveColor: Colors.white24,
                      thumbColor: Colors.white,
                      reserveSwellRoom: _reserveSwellRoom,
                      layout: const LiquidGlassSwitchLayout(
                        width: 78,
                        height: 34,
                        padding: 2.5,
                        thumbWidth: 44,
                        thumbHeight: 29,
                        expandedThumbWidth: 66,
                        expandedThumbHeight: 44,
                        pinchedHeight: 26,
                        overshootRoom: 22,
                      ),
                      style: LiquidGlassSwitch.defaultStyle.copyWith(
                        dispersion: 1.5,
                      ),
                      onChanged: (v) => setState(() => _switchB = v),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Custom Layout (${_switchB ? "ON" : "OFF"})',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            LabeledSwitch(
              label: 'reserveSwellRoom',
              subtitle: 'Reserves layout bounds so clipping parents do not cut swell',
              value: _reserveSwellRoom,
              onChanged: (v) => setState(() => _reserveSwellRoom = v),
            ),
          ],
        ),

        // ── 3. Standalone LiquidGlassMotionPill ──
        ControlPanel(
          title: 'LiquidGlassMotionPill (Standalone)',
          subtitle:
              'Drag horizontally below • glassVisible: $_pillGlassVisible',
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final double maxW = constraints.maxWidth;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (d) => setState(() {
                    _pillActive = true;
                    _pillCenter = Offset(
                      d.localPosition.dx.clamp(40, maxW - 40),
                      44,
                    );
                  }),
                  onPanUpdate: (d) => setState(() {
                    _pillCenter = Offset(
                      (_pillCenter.dx + d.delta.dx).clamp(40, maxW - 40),
                      44,
                    );
                  }),
                  onPanEnd: (_) => setState(() => _pillActive = false),
                  onPanCancel: () => setState(() => _pillActive = false),
                  child: Container(
                    height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0EA5E9),
                          Color(0xFF8B5CF6),
                          Color(0xFFEC4899),
                        ],
                      ),
                    ),
                    child: LiquidGlassMotionPill(
                      center: Offset(_pillCenter.dx.clamp(40, maxW - 40), 44),
                      active: _pillActive,
                      restSize: const Size(52, 32),
                      activeSize: const Size(86, 52),
                      motion: const LiquidGlassLensMotionSpec(
                        maxDeformation: 0.32,
                      ),
                      cover: const ColoredBox(color: Colors.white),
                      shadow: const LiquidGlassShadow(
                        blur: 8,
                        opacity: 0.30,
                        inset: 2,
                      ),
                      onGlassVisibilityChanged: (vis) {
                        if (_pillGlassVisible != vis && mounted) {
                          setState(() => _pillGlassVisible = vis);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        // ── 4. LiquidGlassButton & LiquidGlassFab ──
        ControlPanel(
          title: 'LiquidGlassButton & LiquidGlassFab',
          subtitle: 'Standard, custom child, flexing touch, circular & extended FAB (taps: $_buttonTaps)',
          trailing: Switch.adaptive(
            value: _buttonsVisible,
            onChanged: (v) => setState(() => _buttonsVisible = v),
          ),
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                LiquidGlassButton(
                  label: 'Glass Button',
                  icon: Icons.bolt_rounded,
                  visibility: _buttonsVisible,
                  touch: const LiquidGlassTouch.flexing(
                      LiquidGlassFlex.pronounced()),
                  onPressed: () => setState(() => _buttonTaps++),
                ),
                LiquidGlassButton(
                  visibility: _buttonsVisible,
                  height: 48,
                  touch: const LiquidGlassTouch.flexing(LiquidGlassFlex()),
                  style: LiquidGlassButton.defaultStyle.copyWith(
                    color: const Color(0x550EA5E9),
                  ),
                  onPressed: () => setState(() => _buttonTaps++),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      SizedBox(width: 6),
                      Text('Custom Child'),
                    ],
                  ),
                ),
                LiquidGlassFab(
                  icon: Icons.add_rounded,
                  tooltip: 'Circular LiquidGlassFab',
                  heroTag: 'demo_fab_circle',
                  visibility: _buttonsVisible,
                  onPressed: () => setState(() => _buttonTaps++),
                ),
                LiquidGlassFab.extended(
                  icon: Icons.edit_rounded,
                  label: const Text('Compose'),
                  tooltip: 'Extended LiquidGlassFab',
                  heroTag: 'demo_fab_extended',
                  visibility: _buttonsVisible,
                  onPressed: () => setState(() => _buttonTaps++),
                ),
              ],
            ),
          ],
        ),

        // ── 5. Dialogs & Sheets ──
        ControlPanel(
          title: 'LiquidGlassDialog & LiquidGlassSheet',
          subtitle:
              'showLiquidGlassDialog, showLiquidGlassSheet (floating/attached/expandable)',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: _openAlertDialog,
                  child: const Text('AlertDialog'),
                ),
                FilledButton.tonal(
                  onPressed: _openCustomDialog,
                  child: const Text('Custom Dialog'),
                ),
                FilledButton.tonal(
                  onPressed: () => _openSheet(LiquidGlassSheetAnchor.floating),
                  child: const Text('Floating Sheet'),
                ),
                FilledButton.tonal(
                  onPressed: () => _openSheet(LiquidGlassSheetAnchor.attached),
                  child: const Text('Attached Sheet'),
                ),
                OutlinedButton(
                  onPressed: _openExpandableSheet,
                  child: const Text('Expandable Sheet'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LabeledSwitch(
              label: 'Join scaffold chrome batch (batch: true)',
              value: _modalBatch,
              onChanged: (v) => setState(() => _modalBatch = v),
            ),
            LabeledSwitch(
              label: 'Sheet grabber',
              value: _sheetGrabber,
              onChanged: (v) => setState(() => _sheetGrabber = v),
            ),
            LabeledSwitch(
              label: 'Sheet avoidKeyboard',
              value: _sheetAvoidKeyboard,
              onChanged: (v) => setState(() => _sheetAvoidKeyboard = v),
            ),
          ],
        ),

        // ── 6. Live LiquidGlassTabBar Controls ──
        ControlPanel(
          title: 'Live LiquidGlassTabBar Controls',
          subtitle:
              'Mutate the live bottom LiquidGlassTabBar on this LiquidGlassScaffold',
          children: [
            ChipChoiceRow<LiquidGlassPillMode>(
              label: 'pillStyle.mode (LiquidGlassPillMode)',
              value: widget.pillMode,
              options: const [
                (LiquidGlassPillMode.both, 'both'),
                (LiquidGlassPillMode.impellerOnly, 'impellerOnly'),
                (LiquidGlassPillMode.none, 'none'),
              ],
              onChanged: widget.onPillModeChanged,
            ),
            ChipChoiceRow<Axis>(
              label: 'itemStyle.axis',
              value: widget.tabItemAxis,
              options: const [
                (Axis.vertical, 'Axis.vertical'),
                (Axis.horizontal, 'Axis.horizontal'),
              ],
              onChanged: widget.onTabItemAxisChanged,
            ),
            LabeledSwitch(
              label: 'pillStyle.confineToBar',
              value: widget.confinePillToBar,
              onChanged: widget.onConfinePillChanged,
            ),
            LabeledSwitch(
              label: 'TabBar.swell (LiquidGlassTabBarSwell)',
              value: widget.enableSwell,
              onChanged: widget.onEnableSwellChanged,
            ),
            LabeledSwitch(
              label: 'pillStyle.magnifierPill.enabled (Impeller)',
              value: widget.enableMagnifierPill,
              onChanged: widget.onEnableMagnifierChanged,
            ),
            LabeledSwitch(
              label: 'TabBar.joinBatch',
              value: widget.tabBarJoinBatch,
              onChanged: widget.onTabBarJoinBatchChanged,
            ),
          ],
        ),
      ],
    );
  }
}
