import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import 'pages/adaptivity_edge_page.dart';
import 'pages/blend_batch_page.dart';
import 'pages/components_page.dart';
import 'pages/lens_playground_page.dart';
import 'pages/touch_morph_page.dart';
import 'widgets/showcase_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-compile every liquid_glass_easy shader before frame 1.
  await LiquidGlassShaders.ensureLoaded();
  runApp(const LiquidGlassShowcaseApp());
}

class LiquidGlassShowcaseApp extends StatefulWidget {
  const LiquidGlassShowcaseApp({super.key});

  @override
  State<LiquidGlassShowcaseApp> createState() => _LiquidGlassShowcaseAppState();
}

class _LiquidGlassShowcaseAppState extends State<LiquidGlassShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Liquid Glass Easy 5.2.0 — Complete API Showcase',
      themeMode: _themeMode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: ShowcaseHome(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ShowcaseHome({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  int _tabIndex = 0;
  ShowcaseBackdropStyle _backdropStyle = ShowcaseBackdropStyle.vibrantMesh;
  int _configGeneration = 0;

  // Live LiquidGlassTabBar customization state (controlled from Tab 5)
  LiquidGlassPillMode _pillMode = LiquidGlassPillMode.both;
  bool _confinePillToBar = false;
  bool _enableSwell = true;
  bool _enableMagnifierPill = true;
  Axis _tabItemAxis = Axis.vertical;
  bool _tabBarJoinBatch = false;

  static const List<String> _tabTitles = [
    'Lens & Style',
    'Touch & Morph',
    'Blend & Engine',
    'Adapt & Edge',
    'Components',
  ];

  void _cycleBackdrop() {
    setState(() {
      final int next =
          (_backdropStyle.index + 1) % ShowcaseBackdropStyle.values.length;
      _backdropStyle = ShowcaseBackdropStyle.values[next];
    });
  }

  void _onReselected(int index) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1200),
          content: Text('onReselected fired for "${_tabTitles[index]}"'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.sizeOf(context).width;
    final double appBarW = (screenW - 24).clamp(260, 460);
    final double tabBarW = (screenW - 92).clamp(248, 360);

    return Scaffold(
      body: KeyedSubtree(
        key: ValueKey<int>(_configGeneration),
        child: LiquidGlassScaffold(
          safeArea: true,
          appBarTopMargin: 8,
          bottomNavigationBarActionMargin: 12,
          batch: true,
          batchMode: LiquidGlassConfiguration.batchMode,
          adaptivity: const LiquidGlassScaffoldAdaptivity(
            LiquidGlassAdaptivity(
              glassColorOnDark: Color(0x36000000),
              contentColorOnDark: Colors.white,
              glassColorOnLight: Color(0x66FFFFFF),
              contentColorOnLight: Color(0xFF1C1C1E),
            ),
            systemChrome: LiquidGlassSystemChrome.statusBar,
            sampling: LiquidGlassAdaptiveSampling(
              pixelRatio: 0.05,
              frameLimit: 8,
              minimumRegionSamples: 8,
            ),
          ),
          appBar: LiquidGlassAppBar(
            width: appBarW,
            height: 54,
            centerTitle: true,
            touch: const LiquidGlassTouch.flexing(LiquidGlassFlex.subtle()),
            leading: IconButton(
              tooltip: 'Switch Backdrop (${_backdropStyle.name})',
              onPressed: _cycleBackdrop,
              icon: const Icon(Icons.wallpaper_rounded, size: 20),
            ),
            title: Text(
              '5.2.0 • ${_tabTitles[_tabIndex]}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                tooltip: 'Toggle Light / Dark Theme',
                onPressed: widget.onToggleTheme,
                icon: Icon(
                  widget.isDark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  size: 20,
                ),
              ),
            ],
          ),
          body: LiquidGlassView(
            backgroundWidget: ShowcaseBackground(
              style: _backdropStyle,
              darkTheme: widget.isDark,
            ),
            child: IndexedStack(
              index: _tabIndex,
              children: [
                const LensPlaygroundPage(),
                const TouchMorphPage(),
                BlendBatchPage(
                  onGlobalConfigChanged: () =>
                      setState(() => _configGeneration++),
                ),
                const AdaptivityEdgePage(),
                ComponentsPage(
                  pillMode: _pillMode,
                  confinePillToBar: _confinePillToBar,
                  enableSwell: _enableSwell,
                  enableMagnifierPill: _enableMagnifierPill,
                  tabItemAxis: _tabItemAxis,
                  tabBarJoinBatch: _tabBarJoinBatch,
                  onPillModeChanged: (v) => setState(() => _pillMode = v),
                  onConfinePillChanged: (v) =>
                      setState(() => _confinePillToBar = v),
                  onEnableSwellChanged: (v) =>
                      setState(() => _enableSwell = v),
                  onEnableMagnifierChanged: (v) =>
                      setState(() => _enableMagnifierPill = v),
                  onTabItemAxisChanged: (v) =>
                      setState(() => _tabItemAxis = v),
                  onTabBarJoinBatchChanged: (v) =>
                      setState(() => _tabBarJoinBatch = v),
                ),
              ],
            ),
          ),
          bottomNavigationBar: LiquidGlassTabBar(
            width: tabBarW,
            height: 62,
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.only(left: 12, bottom: 14),
            selectedIndex: _tabIndex,
            onChanged: (i) => setState(() => _tabIndex = i),
            onReselected: _onReselected,
            joinBatch: _tabBarJoinBatch,
            swell: _enableSwell ? const LiquidGlassTabBarSwell() : null,
            itemStyle: LiquidGlassTabItemStyle(
              iconSize: 22,
              underGlassIconSize: 26,
              labelFontSize: 9.5,
              underGlassLabelFontSize: 10.5,
              axis: _tabItemAxis,
            ),
            pillStyle: LiquidGlassTabPillStyle(
              mode: _pillMode,
              animated: true,
              confineToBar: _confinePillToBar,
              magnifierPill: LiquidGlassTabMagnifierPillStyle(
                enabled: _enableMagnifierPill,
                magnification: 0.832,
              ),
              behavior: const LiquidGlassTabPillBehavior(),
            ),
            items: [
              const LiquidGlassTabBarItem(
                icon: Icons.lens_blur_outlined,
                selectedIcon: Icons.lens_blur_rounded,
                label: 'Lens',
              ),
              const LiquidGlassTabBarItem(
                icon: Icons.touch_app_outlined,
                selectedIcon: Icons.touch_app_rounded,
                label: 'Morph',
              ),
              const LiquidGlassTabBarItem(
                icon: Icons.bubble_chart_outlined,
                selectedIcon: Icons.bubble_chart_rounded,
                label: 'Blend',
              ),
              const LiquidGlassTabBarItem(
                icon: Icons.brightness_auto_outlined,
                selectedIcon: Icons.brightness_auto_rounded,
                label: 'Adapt',
              ),
              // Demonstrates custom iconBuilder & labelBuilder (LiquidGlassGlyph & LiquidGlassLabel)
              LiquidGlassTabBarItem(
                label: 'UI',
                iconBuilder: (context, glyph) => Icon(
                  glyph.selected
                      ? Icons.widgets_rounded
                      : Icons.widgets_outlined,
                  size: glyph.size,
                  color: glyph.color,
                ),
                labelBuilder: (context, label) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label.text ?? 'UI', style: label.textStyle),
                    if (label.selected) ...[
                      const SizedBox(width: 2),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: label.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBarAction: LiquidGlassTabBarAction(
            size: 56,
            icon: Icons.wallpaper_rounded,
            touch: const LiquidGlassTouch.flexing(LiquidGlassFlex.pronounced()),
            onTap: _cycleBackdrop,
          ),
        ),
      ),
    );
  }
}
