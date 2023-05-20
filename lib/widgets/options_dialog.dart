import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OptionsDialog<T> extends StatelessWidget {
  const OptionsDialog({Key? key, required this.title, required this.entries})
      : super(key: key);

  final String title;
  final Map<T, String> entries;

  double _paddingScaleFactor(double textScaleFactor) {
    final double clampedTextScaleFactor =
        clampDouble(textScaleFactor, 1.0, 2.0);
    // The final padding scale factor is clamped between 1/3 and 1. For example,
    // a non-scaled padding of 24 will produce a padding between 24 and 8.
    return lerpDouble(1.0, 1.0 / 3.0, clampedTextScaleFactor - 1.0)!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var dividerColor = theme.dividerColor;

    final textDirection = Directionality.maybeOf(context);

    const titlePadding = EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0);
    final EdgeInsets effectiveTitlePadding =
        titlePadding.resolve(textDirection);

    final double paddingScaleFactor =
        _paddingScaleFactor(MediaQuery.of(context).textScaleFactor);

    var titleWidget = Padding(
      padding: EdgeInsets.only(
        left: effectiveTitlePadding.left * paddingScaleFactor,
        right: effectiveTitlePadding.right * paddingScaleFactor,
        top: effectiveTitlePadding.top * paddingScaleFactor,
        bottom: effectiveTitlePadding.bottom * paddingScaleFactor,
      ),
      child: DefaultTextStyle(
        style: DialogTheme.of(context).titleTextStyle ??
            Theme.of(context).textTheme.titleLarge!,
        child: Semantics(
          container: true,
          child: Text(title),
        ),
      ),
    );

    const contentPadding = EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0);
    final EdgeInsets effectiveContentPadding =
        contentPadding.resolve(textDirection);
    var optionsListView = Flexible(
      child: ListView.separated(
        padding: EdgeInsets.only(
          left: effectiveContentPadding.left * paddingScaleFactor,
          right: effectiveContentPadding.right * paddingScaleFactor,
          top: effectiveContentPadding.top,
          bottom: effectiveContentPadding.bottom * paddingScaleFactor,
        ),
        separatorBuilder: (context, index) => Divider(
          color: dividerColor,
          height: 2,
          thickness: 1.0,
          indent: 20,
          endIndent: 20,
        ),
        shrinkWrap: true,
        itemCount: entries.length,
        itemBuilder: (context, index) {
          var entry = entries.entries.elementAt(index);
          return SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, entry.key);
            },
            child: Text(entry.value),
          );
        },
      ),
    );

    var dialogChild = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [titleWidget, optionsListView],
      ),
    );

    return Dialog(child: dialogChild);
  }
}
