import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themegen/wallpaper_pair.dart';

class WallpaperPicker extends StatefulWidget {
  const WallpaperPicker({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WallpaperPickerState();
  }
}

class _WallpaperPickerState extends State<WallpaperPicker> {
  int selected = 0;
  final scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WallpaperPickerProvider>();
    const gap = SizedBox(width: 8);

    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            WallpaperButton(
              index: 0,
              onSelect: (sel, wallpaper) => setState(() {
                selected = sel;
                provider.updateCurrentWallpaper(wallpaper);
                provider.updateCurrentWallpaper5(null);
              }),
              selected: selected,
              wallpaper: provider.wallpaper1,
            ),
            gap,
            WallpaperButton(
              index: 1,
              onSelect: (sel, wallpaper) => setState(() {
                selected = sel;
                provider.updateCurrentWallpaper(wallpaper);
                provider.updateCurrentWallpaper5(null);
              }),
              selected: selected,
              wallpaper: provider.wallpaper2,
            ),
            gap,
            WallpaperButton(
              index: 2,
              onSelect: (sel, wallpaper) => setState(() {
                selected = sel;
                provider.updateCurrentWallpaper(wallpaper);
                provider.updateCurrentWallpaper5(null);
              }),
              selected: selected,
              wallpaper: provider.wallpaper3,
            ),
            gap,
            WallpaperButton(
              index: 3,
              onSelect: (sel, wallpaper) => setState(() {
                selected = sel;
                provider.updateCurrentWallpaper(wallpaper);
                provider.updateCurrentWallpaper5(null);
              }),
              selected: selected,
              wallpaper: provider.wallpaper4,
            ),
            gap,
            WallpaperButton(
              index: 4,
              onSelect: (sel, wallpaper) => setState(() {
                selected = sel;
                provider.updateCurrentWallpaper(wallpaper);
                provider.updateCurrentWallpaper5(wallpaper);
              }),
              selected: selected,
              wallpaper: provider.wallpaper5,
            ),
          ],
        ),
      ),
    );
  }
}

class WallpaperButton extends StatefulWidget {
  const WallpaperButton(
      {super.key,
      required this.wallpaper,
      required this.index,
      required this.selected,
      required this.onSelect});

  final WallpaperPair? wallpaper;
  final int index;
  final int selected;

  final void Function(int selected, WallpaperPair wallpaperPair) onSelect;

  @override
  State<StatefulWidget> createState() {
    return _WallpaperButtonState();
  }
}

class _WallpaperButtonState extends State<WallpaperButton> {
  Color color = Colors.transparent;
  BorderRadius borderRadius = BorderRadius.circular(146 / 2);

  @override
  Widget build(BuildContext context) {
    double width = widget.selected == widget.index ? 290 : 146;
    final image = widget.wallpaper?.imageProvider;
    final imageWidget = image != null
        ? Image(
            image: image,
            fit: BoxFit.cover,
          )
        : Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.wallpaper,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );

    return MouseRegion(
        onEnter: (event) {
          setState(() {
            color = widget.wallpaper?.colorSchemeLight.onSurfaceVariant
                    .withOpacity(0.1) ??
                Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.1);
            borderRadius = BorderRadius.circular(8);
            width = 290;
          });
        },
        onExit: (event) {
          setState(() {
            color = Colors.transparent;
            borderRadius = BorderRadius.circular(146 / 2);
            width = 146;
          });
        },
        child: GestureDetector(
          onTap: () async {
            if (widget.wallpaper != null) {
              widget.onSelect(widget.index, widget.wallpaper!);
            } else {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  lockParentWindow: true,
                  dialogTitle: "Open Image");

              if (result != null) {
                final path = result.files.first.path;
                if (path != null) {
                  final file = File(path);
                  widget.onSelect(widget.index,
                      await WallpaperPair.fromImageProvider(FileImage(file)));
                }
              }
            }
          },
          child: AnimatedContainer(
            duration: Durations.short3,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border:
                  widget.selected == widget.index ? Border.all(width: 1) : null,
              borderRadius: borderRadius,
            ),
            width: width,
            height: 108,
            child: AnimatedContainer(
              duration: Durations.medium1,
              color: color,
              child: AnimatedContainer(
                duration: Durations.medium1,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                ),
                child: imageWidget,
              ),
            ),
          ),
        ));
  }
}
