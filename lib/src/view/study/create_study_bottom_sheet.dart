import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/study/create_study_chapter_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';

class CreateStudyBottomSheet extends ConsumerStatefulWidget {
  const CreateStudyBottomSheet({required this.user, this.onStudyCreated});

  final LightUser user;

  final void Function(BuildContext, StudyId)? onStudyCreated;

  @override
  ConsumerState<CreateStudyBottomSheet> createState() => _CreateStudyBottomSheetState();
}

class _CreateStudyBottomSheetState extends ConsumerState<CreateStudyBottomSheet> {
  CreateStudyPayload payload = const CreateStudyPayload(
    name: '',
    chat: StudyFeatureAccess.member,
    cloneable: StudyFeatureAccess.everyone,
    computer: StudyFeatureAccess.everyone,
    explorer: StudyFeatureAccess.everyone,
    shareable: StudyFeatureAccess.everyone,
    visibility: StudyVisibility.unlisted,
    sticky: true,
  );

  final _nameController = TextEditingController();

  @override
  void initState() {
    payload = payload.copyWith(name: "${widget.user.name}'s Study");
    _nameController.text = payload.name;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetScrollableContainer(
      padding: Styles.verticalBodyPadding,
      children: [
        ListTile(
          title: Text(context.l10n.name),
          subtitle: TextField(
            controller: _nameController,
            onChanged: (value) => setState(() => payload = payload.copyWith(name: value)),
          ),
        ),

        ListTile(
          title: Text(context.l10n.studyVisibility),
          trailing: TextButton(
            onPressed: () {
              showChoicePicker(
                context,
                choices: StudyVisibility.values,
                selectedItem: payload.visibility,
                labelBuilder: (StudyVisibility visibility) => Text(visibility.l10(context)),
                onSelectedItemChanged: (StudyVisibility value) =>
                    setState(() => payload = payload.copyWith(visibility: value)),
              );
            },
            child: Text(payload.visibility.l10(context)),
          ),
        ),
        ListTile(
          title: Text(context.l10n.chat),
          trailing: TextButton(
            onPressed: () {
              showChoicePicker(
                context,
                choices: StudyFeatureAccess.values,
                selectedItem: payload.chat,
                labelBuilder: (StudyFeatureAccess access) => Text(access.l10(context)),
                onSelectedItemChanged: (StudyFeatureAccess value) =>
                    setState(() => payload = payload.copyWith(chat: value)),
              );
            },
            child: Text(payload.chat.l10(context)),
          ),
        ),
        ListTile(
          title: Text(context.l10n.computerAnalysis),
          trailing: TextButton(
            onPressed: () {
              showChoicePicker(
                context,
                choices: StudyFeatureAccess.values,
                selectedItem: payload.computer,
                labelBuilder: (StudyFeatureAccess access) => Text(access.l10(context)),
                onSelectedItemChanged: (StudyFeatureAccess value) =>
                    setState(() => payload = payload.copyWith(computer: value)),
              );
            },
            child: Text(payload.computer.l10(context)),
          ),
        ),

        ListTile(
          title: Text(context.l10n.openingExplorerAndTablebase),
          trailing: TextButton(
            onPressed: () {
              showChoicePicker(
                context,
                choices: StudyFeatureAccess.values,
                selectedItem: payload.explorer,
                labelBuilder: (StudyFeatureAccess access) => Text(access.l10(context)),
                onSelectedItemChanged: (StudyFeatureAccess value) =>
                    setState(() => payload = payload.copyWith(explorer: value)),
              );
            },
            child: Text(payload.explorer.l10(context)),
          ),
        ),

        ListTile(
          title: Text(context.l10n.studyAllowCloning),
          trailing: TextButton(
            onPressed: () {
              showChoicePicker(
                context,
                choices: StudyFeatureAccess.values,
                selectedItem: payload.cloneable,
                labelBuilder: (StudyFeatureAccess access) => Text(access.l10(context)),
                onSelectedItemChanged: (StudyFeatureAccess value) =>
                    setState(() => payload = payload.copyWith(cloneable: value)),
              );
            },
            child: Text(payload.cloneable.l10(context)),
          ),
        ),

        ListTile(
          title: Text(context.l10n.studyEnableSync),
          subtitle: Text(
            payload.sticky
                ? context.l10n.studyYesKeepEveryoneOnTheSamePosition
                : context.l10n.studyNoLetPeopleBrowseFreely,
          ),
          trailing: Switch(
            value: payload.sticky,
            onChanged: (bool value) => setState(() => payload = payload.copyWith(sticky: value)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: (context) => CreateStudyChapterBottomSheet(
                  params: CreateFirstChapterOfNewStudy(payload),
                  chapterNumber: 1,
                  onChaptersCreated: (studyId, _) => widget.onStudyCreated?.call(context, studyId),
                ),
              );
            },
            child: Text(context.l10n.studyCreateStudy, style: Styles.bold),
          ),
        ),
      ],
    );
  }
}
