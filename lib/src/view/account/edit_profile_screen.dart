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

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.editProfile)),
      body: _Body(),
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
        return Padding(
          padding: Styles.bodyPadding,
          child: ListView(
            children: [
              Text(context.l10n.allInformationIsPublicAndOptional),
              const SizedBox(height: 16),
              _EditProfileForm(data),
            ],
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

  final _cupertinoTextFieldDecoration = BoxDecoration(
    color: CupertinoColors.tertiarySystemBackground,
    border: Border.all(color: CupertinoColors.systemGrey4, width: 1),
    borderRadius: BorderRadius.circular(8),
  );

  Future<void>? _pendingSaveProfile;

  @override
  Widget build(BuildContext context) {
    final String? initialLinks = widget.user.profile?.links?.map((e) => e.url).join('\r\n');

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _textField(
            label: context.l10n.biography,
            initialValue: widget.user.profile?.bio,
            formKey: 'bio',
            controller: TextEditingController(text: widget.user.profile?.bio),
            description: context.l10n.biographyDescription,
            maxLength: 400,
            maxLines: 6,
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
          _textField(
            label: context.l10n.location,
            initialValue: widget.user.profile?.location,
            controller: TextEditingController(text: widget.user.profile?.location),
            formKey: 'location',
            maxLength: 80,
          ),
          _textField(
            label: context.l10n.realName,
            initialValue: widget.user.profile?.realName,
            formKey: 'realName',
            controller: TextEditingController(text: widget.user.profile?.realName),
            maxLength: 20,
          ),
          _numericField(
            label: context.l10n.xRating('FIDE'),
            initialValue: widget.user.profile?.fideRating,
            formKey: 'fideRating',
            controller: TextEditingController(text: widget.user.profile?.fideRating?.toString()),
            validator: (value) {
              if (value != null && (value < 1400 || value > 3000)) {
                return 'Rating must be between 1400 and 3000';
              }
              return null;
            },
          ),
          _numericField(
            label: context.l10n.xRating('USCF'),
            initialValue: widget.user.profile?.uscfRating,
            formKey: 'uscfRating',
            controller: TextEditingController(text: widget.user.profile?.uscfRating?.toString()),
            validator: (value) {
              if (value != null && (value < 100 || value > 3000)) {
                return 'Rating must be between 100 and 3000';
              }
              return null;
            },
          ),
          _numericField(
            label: context.l10n.xRating('ECF'),
            initialValue: widget.user.profile?.ecfRating,
            formKey: 'ecfRating',
            controller: TextEditingController(text: widget.user.profile?.ecfRating?.toString()),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value != null && (value < 0 || value > 3000)) {
                return 'Rating must be between 0 and 3000';
              }
              return null;
            },
          ),
          _textField(
            label: context.l10n.socialMediaLinks,
            initialValue: initialLinks,
            formKey: 'links',
            controller: TextEditingController(text: initialLinks),
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

  Widget _textField({
    required String label,
    required String? initialValue,
    required String formKey,
    required TextEditingController controller,
    String? description,
    int? maxLength,
    int? maxLines,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FormField<String>(
        initialValue: initialValue,
        onSaved: (value) {
          _formData[formKey] = value;
        },
        builder: (FormFieldState<String> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Styles.formLabel),
              const SizedBox(height: 6.0),
              AdaptiveTextField(
                maxLength: maxLength,
                maxLines: maxLines,
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
                textInputAction: textInputAction,
                controller: controller,
                onChanged: (value) {
                  field.didChange(value.trim());
                },
              ),
              if (description != null) ...[
                const SizedBox(height: 6.0),
                Text(description, style: Styles.formDescription),
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

  Widget _numericField({
    required String label,
    required int? initialValue,
    required String formKey,
    required TextEditingController controller,
    required String? Function(int?)? validator,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FormField<int>(
        initialValue: initialValue,
        onSaved: (value) {
          _formData[formKey] = value;
        },
        validator: validator,
        builder: (FormFieldState<int> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Styles.formLabel),
              const SizedBox(height: 6.0),
              AdaptiveTextField(
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
                textInputAction: textInputAction,
                controller: controller,
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
