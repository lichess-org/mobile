import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/study/study.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:material_ui/material_ui.dart';

/// Lets the study owner (or an admin member) rename the study, change its visibility and decide
/// who is allowed to use each of its features.
class EditStudyScreen extends ConsumerStatefulWidget {
  const EditStudyScreen(this.options);

  final StudyOptions options;

  static Route<dynamic> buildRoute(StudyOptions options) {
    return buildScreenRoute(screen: EditStudyScreen(options));
  }

  @override
  ConsumerState<EditStudyScreen> createState() => _EditStudyScreenState();
}

class _EditStudyScreenState extends ConsumerState<EditStudyScreen> {
  late final TextEditingController _nameController;
  late StudyVisibility _visibility;
  late UserSelection _computer;
  late UserSelection _explorer;
  late UserSelection _cloneable;
  late UserSelection _shareable;
  late UserSelection _chat;
  late bool _sticky;
  late bool _description;

  /// Whether a save request is in flight — the server doesn't acknowledge `editStudy`, so this
  /// stays true until the change has been read back and confirmed.
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final study = ref.read(studyControllerProvider(widget.options)).requireValue.study;
    _nameController = TextEditingController(text: study.name);
    _visibility = study.visibility;
    _computer = study.settings.computer;
    _explorer = study.settings.explorer;
    _cloneable = study.settings.cloneable;
    _shareable = study.settings.shareable;
    _chat = study.settings.chat;
    _sticky = study.settings.sticky;
    _description = study.settings.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final succeeded = await ref
        .read(studyControllerProvider(widget.options).notifier)
        .editStudy(
          EditStudyPayload(
            name: _nameController.text.trim(),
            visibility: _visibility,
            settings: StudySettings(
              computer: _computer,
              explorer: _explorer,
              cloneable: _cloneable,
              shareable: _shareable,
              chat: _chat,
              sticky: _sticky,
              description: _description,
            ),
          ),
        );

    if (!mounted) return;

    if (succeeded) {
      Navigator.of(context).pop();
    } else {
      // Keep the screen open so the user doesn't lose their edits.
      setState(() => _isSaving = false);
      // TODO l10n
      showSnackBar(
        context,
        'Could not save changes — you may not have permission to edit this study.',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.studyEditStudy),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            tooltip: context.l10n.studySave,
            onPressed: (_isSaving || _nameController.text.trim().isEmpty) ? null : _save,
          ),
        ],
      ),
      body: ListView(
        children: [
          ListSection(
            children: [
              ListTile(
                title: Text(context.l10n.name),
                subtitle: TextField(controller: _nameController, onChanged: (_) => setState(() {})),
              ),
              ListTile(
                title: Text(context.l10n.studyVisibility),
                trailing: TextButton(
                  onPressed: () => showChoicePicker(
                    context,
                    choices: StudyVisibility.values,
                    selectedItem: _visibility,
                    labelBuilder: (StudyVisibility v) => Text(v.l10n(context.l10n)),
                    onSelectedItemChanged: (StudyVisibility v) => setState(() => _visibility = v),
                  ),
                  child: Text(_visibility.l10n(context.l10n)),
                ),
              ),
            ],
          ),
          ListSection(
            children: [
              _UserSelectionTile(
                title: context.l10n.computerAnalysis,
                value: _computer,
                onChanged: (v) => setState(() => _computer = v),
              ),
              _UserSelectionTile(
                title: context.l10n.openingExplorer,
                value: _explorer,
                onChanged: (v) => setState(() => _explorer = v),
              ),
              _UserSelectionTile(
                title: context.l10n.studyAllowCloning,
                value: _cloneable,
                onChanged: (v) => setState(() => _cloneable = v),
              ),
              _UserSelectionTile(
                title: context.l10n.studyShareAndExport,
                value: _shareable,
                onChanged: (v) => setState(() => _shareable = v),
              ),
              _UserSelectionTile(
                title: context.l10n.chat,
                value: _chat,
                onChanged: (v) => setState(() => _chat = v),
              ),
            ],
          ),
          ListSection(
            children: [
              SwitchSettingTile(
                title: Text(context.l10n.studyEnableSync),
                value: _sticky,
                onChanged: (value) => setState(() => _sticky = value),
              ),
              SwitchSettingTile(
                // TODO l10n
                title: const Text('Pinned comment'),
                subtitle: const Text('Show a comment pinned above the study'),
                value: _description,
                onChanged: (value) => setState(() => _description = value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserSelectionTile extends StatelessWidget {
  const _UserSelectionTile({required this.title, required this.value, required this.onChanged});

  final String title;
  final UserSelection value;
  final void Function(UserSelection) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: TextButton(
        onPressed: () => showChoicePicker(
          context,
          choices: UserSelection.values,
          selectedItem: value,
          labelBuilder: (UserSelection s) => Text(s.l10n(context.l10n)),
          onSelectedItemChanged: onChanged,
        ),
        child: Text(value.l10n(context.l10n)),
      ),
    );
  }
}
