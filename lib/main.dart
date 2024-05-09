import 'dart:math';

import "package:material_color_utilities/material_color_utilities.dart" as mcu;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:themegen/converter.dart';
import 'package:themegen/wallpaper_pair.dart';
import 'package:themegen/wallpaper_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wallpaper1 = await WallpaperPair.fromImageProvider(
      const AssetImage('assets/1_wallpaper.webp'));
  final wallpaper2 = await WallpaperPair.fromImageProvider(
      const AssetImage('assets/2_wallpaper.webp'));
  final wallpaper3 = await WallpaperPair.fromImageProvider(
      const AssetImage('assets/3_wallpaper.webp'));
  final wallpaper4 = await WallpaperPair.fromImageProvider(
      const AssetImage('assets/4_wallpaper.webp'));
  final currentWallpaper =
      [wallpaper1, wallpaper2, wallpaper3, wallpaper4][Random().nextInt(4)];

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => WallpaperPickerProvider(
          currentWallpaper: currentWallpaper,
          wallpaper1: wallpaper1,
          wallpaper2: wallpaper2,
          wallpaper3: wallpaper3,
          wallpaper4: wallpaper4,
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final softwareBrightness =
        context.watch<WallpaperPickerProvider>().brightness;
    final brightness = softwareBrightness ?? platformBrightness;
    final isDark = brightness == Brightness.dark;

    final currentWallpaper =
        context.watch<WallpaperPickerProvider>().currentWallpaper;

    final colorScheme = isDark
        ? currentWallpaper.colorSchemeDark
        : currentWallpaper.colorSchemeLight;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tailwind Material 3 Theme Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {}

  final scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final softwareBrightness =
        context.watch<WallpaperPickerProvider>().brightness;
    final brightness = softwareBrightness ?? platformBrightness;
    final isDark = brightness == Brightness.dark;

    final currentWallpaper =
        context.watch<WallpaperPickerProvider>().currentWallpaper;

    final dynamicScheme = isDark
        ? currentWallpaper.dynamicSchemeDark
        : currentWallpaper.dynamicSchemeLight;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.javascript),
        title: Text(widget.title),
        actions: [
          if (!isDark)
            IconButton(
                onPressed: () {
                  context
                      .read<WallpaperPickerProvider>()
                      .updateBrightness(Brightness.dark);
                },
                icon: const Icon(Icons.dark_mode)),
          if (isDark)
            IconButton(
                onPressed: () {
                  context
                      .read<WallpaperPickerProvider>()
                      .updateBrightness(Brightness.light);
                },
                icon: const Icon(Icons.light_mode)),
        ],
      ),
      body: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Source image",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const WallpaperPicker(),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final data = ColorHelper.copyLightCSS(
                          currentWallpaper.dynamicSchemeLight,
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text("")));
                        Clipboard.setData(ClipboardData(text: data)).then((_) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Copied Light CSS Variable")));
                        });
                      },
                      child: const Text("Copy Light CSS Variable")),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final data = ColorHelper.copyDarkCSS(
                          currentWallpaper.dynamicSchemeDark,
                        );

                        Clipboard.setData(ClipboardData(text: data)).then((_) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Copied Dark CSS Variable")));
                        });
                        // ignore: use_build_context_synchronously
                      },
                      child: const Text("Copy Dark CSS Variable")),
                  Container(
                      width: 200,
                      height: 80,
                      color: WallpaperPair.argbToColor(mcu
                          .MaterialDynamicColors.primary
                          .getArgb(dynamicScheme))),
                  Container(
                      width: 200,
                      height: 80,
                      color: WallpaperPair.argbToColor(mcu
                          .MaterialDynamicColors.onPrimary
                          .getArgb(dynamicScheme))),
                ],
              ),
            )),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
