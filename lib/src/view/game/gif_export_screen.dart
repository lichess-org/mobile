import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class GifExport extends StatelessWidget {
  const GifExport({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const GifExport());
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      children: [
        ListSection(children: [SwitchSettingTile(title: Text("Player names"), value: false)]),
        FilledButton.tonal(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.next, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
