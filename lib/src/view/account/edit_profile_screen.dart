import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/countries.dart';
import 'package:lichess_mobile/src/widgets/adaptive_autocomplete.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:result_extensions/result_extensions.dart';

final _countries = countries.values.toList();
final _cupertinoTextFieldDecoration = BoxDecoration(
  color: CupertinoColors.tertiarySystemBackground,
  border: Border.all(color: CupertinoColors.systemGrey4, width: 1),
  borderRadius: BorderRadius.circular(8),
);

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.editProfile)),
      body: PopScope(
        canPop: false,
        child: _Body(),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    return account.when(
      data: (data) {
        if (data == null) {
          return Center(child: Text(context.l10n.mobileMustBeLoggedIn));
        }
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: Styles.bodyPadding.copyWith(top: 0, bottom: 0),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                SizedBox(height: Styles.bodyPadding.top),
                Text(context.l10n.allInformationIsPublicAndOptional),
                const SizedBox(height: 16),
                _EditProfileForm(data),
                SizedBox(height: Styles.bodyPadding.bottom),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(err.toString())),
    );
  }
}

class _EditProfileForm extends ConsumerStatefulWidget {
  const _EditProfileForm(this.user);

  final User user;

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  final _formData = <String, dynamic>{
    'flag': null,
    'location': null,
    'bio': null,
    'firstName': null,
    'lastName': null,
    'fideRating': null,
    'uscfRating': null,
    'ecfRating': null,
    'rcfRating': null,
    'cfcRating': null,
    'dsbRating': null,
    'links': null,
  };

  Future<void>? _pendingSaveProfile;

  @override
  Widget build(BuildContext context) {
    final String? initialLinks = widget.user.profile?.links?.map((e) => e.url).join('\r\n');
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _TextField(
            label: context.l10n.biography,
            initialValue: widget.user.profile?.bio,
            formKey: 'bio',
            formData: _formData,
            description: context.l10n.biographyDescription,
            maxLength: 400,
            maxLines: 6,
            textInputAction: TextInputAction.newline,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FormField<String>(
              initialValue: widget.user.profile?.country,
              onSaved: (value) {
                _formData['flag'] = value;
              },
              builder: (FormFieldState<String> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.countryRegion, style: Styles.formLabel),
                    const SizedBox(height: 6.0),
                    AdaptiveAutoComplete<String>(
                      cupertinoDecoration: _cupertinoTextFieldDecoration,
                      textInputAction: TextInputAction.next,
                      initialValue:
                          field.value != null
                              ? TextEditingValue(text: countries[field.value]!)
                              : null,
                      optionsBuilder: (TextEditingValue value) {
                        if (value.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return _countries.where((String option) {
                          return option.toLowerCase().contains(value.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        final country = countries.entries.firstWhere(
                          (element) => element.value == selection,
                        );
                        field.didChange(country.key);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          _TextField(
            label: context.l10n.location,
            initialValue: widget.user.profile?.location,
            formData: _formData,
            formKey: 'location',
            maxLength: 80,
          ),
          _TextField(
            label: context.l10n.realName,
            initialValue: widget.user.profile?.realName,
            formKey: 'realName',
            formData: _formData,
            maxLength: 20,
          ),

          _NumericField(
            label: context.l10n.xRating('FIDE'),
            initialValue: widget.user.profile?.fideRating,
            formKey: 'fideRating',
            formData: _formData,
            validator: (value) {
              if (value != null && (value < 1400 || value > 3000)) {
                return 'Rating must be between 1400 and 3000';
              }
              return null;
            },
          ),
          _NumericField(
            label: context.l10n.xRating('USCF'),
            initialValue: widget.user.profile?.uscfRating,
            formKey: 'uscfRating',
            formData: _formData,
            validator: (value) {
              if (value != null && (value < 100 || value > 3000)) {
                return 'Rating must be between 100 and 3000';
              }
              return null;
            },
          ),
          _NumericField(
            label: context.l10n.xRating('ECF'),
            initialValue: widget.user.profile?.ecfRating,
            formKey: 'ecfRating',
            formData: _formData,
            validator: (value) {
              if (value != null && (value < 0 || value > 3000)) {
                return 'Rating must be between 0 and 3000';
              }
              return null;
            },
          ),
          _TextField(
            label: context.l10n.socialMediaLinks,
            initialValue: initialLinks,
            formKey: 'links',
            formData: _formData,
            maxLength: 3000,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            description:
                'Mastodon, Facebook, GitHub, Chess.com, ...\r\n${context.l10n.oneUrlPerLine}',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: FutureBuilder(
              future: _pendingSaveProfile,
              builder: (context, snapshot) {
                return FatButton(
                  semanticsLabel: context.l10n.apply,
                  onPressed:
                      snapshot.connectionState == ConnectionState.waiting
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _formData.removeWhere((key, value) {
                                return value == null;
                              });
                              final future = Result.capture(
                                ref.withClient(
                                  (client) => AccountRepository(client).saveProfile(
                                    _formData.map((key, value) => MapEntry(key, value.toString())),
                                  ),
                                ),
                              );

                              setState(() {
                                _pendingSaveProfile = future;
                              });

                              final result = await future;

                              result.match(
                                onError: (err, __) {
                                  if (context.mounted) {
                                    showPlatformSnackbar(
                                      context,
                                      'Something went wrong',
                                      type: SnackBarType.error,
                                    );
                                  }
                                },
                                onSuccess: (_) {
                                  if (context.mounted) {
                                    ref.invalidate(accountProvider);
                                    showPlatformSnackbar(
                                      context,
                                      context.l10n.success,
                                      type: SnackBarType.success,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                },
                              );
                            }
                          },
                  child: Text(context.l10n.apply),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NumericField extends StatefulWidget {
  final String label;
  final int? initialValue;
  final String formKey;
  final String? Function(int?)? validator;
  final TextInputAction textInputAction;
  final Map<String, dynamic> formData;
  const _NumericField({
    required this.label,
    required this.initialValue,
    required this.formKey,
    required this.validator,
    this.textInputAction = TextInputAction.next,
    required this.formData,
  });

  @override
  State<_NumericField> createState() => __NumericFieldState();
}

class __NumericFieldState extends State<_NumericField> {
  final _controller = TextEditingController();
  @override
  void initState() {
    _controller.text = widget.initialValue?.toString() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FormField<int>(
        initialValue: widget.initialValue,
        onSaved: (value) {
          widget.formData[widget.formKey] = value;
        },
        validator: widget.validator,
        builder: (FormFieldState<int> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: Styles.formLabel),
              const SizedBox(height: 6.0),
              AdaptiveTextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                cupertinoDecoration: _cupertinoTextFieldDecoration.copyWith(
                  border: Border.all(
                    color:
                        field.errorText == null
                            ? CupertinoColors.systemGrey4
                            : context.lichessColors.error,
                    width: 1,
                  ),
                ),
                materialDecoration:
                    field.errorText != null ? InputDecoration(errorText: field.errorText) : null,
                textInputAction: widget.textInputAction,

                onChanged: (value) {
                  field.didChange(int.tryParse(value));
                },
              ),
              if (Theme.of(context).platform == TargetPlatform.iOS && field.errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(field.errorText!, style: Styles.formError),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TextField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final String formKey;
  final String? description;
  final int? maxLength;
  final int? maxLines;
  final Map<String, dynamic> formData;
  final TextInputAction textInputAction;
  const _TextField({
    required this.label,
    required this.initialValue,
    required this.formKey,
    required this.formData,
    this.description,
    this.maxLength,
    this.maxLines,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<_TextField> createState() => __TextFieldState();
}

class __TextFieldState extends State<_TextField> {
  final _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FormField<String>(
        initialValue: widget.initialValue,
        onSaved: (value) {
          widget.formData[widget.formKey] = value?.trim();
        },

        builder: (FormFieldState<String> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: Styles.formLabel),
              const SizedBox(height: 6.0),
              AdaptiveTextField(
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                controller: _controller,
                cupertinoDecoration: _cupertinoTextFieldDecoration.copyWith(
                  border: Border.all(
                    color:
                        field.errorText == null
                            ? CupertinoColors.systemGrey4
                            : context.lichessColors.error,
                    width: 1,
                  ),
                ),
                materialDecoration:
                    field.errorText != null ? InputDecoration(errorText: field.errorText) : null,
                textInputAction: widget.textInputAction,
                onChanged: (value) {
                  field.didChange(value.trim());
                },
              ),
              if (widget.description != null) ...[
                const SizedBox(height: 6.0),
                Text(widget.description!, style: Styles.formDescription),
              ],
              if (Theme.of(context).platform == TargetPlatform.iOS && field.errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(field.errorText!, style: Styles.formError),
                ),
            ],
          );
        },
      ),
    );
  }
}
