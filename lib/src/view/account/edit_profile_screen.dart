import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/flair_provider.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/countries.dart';
import 'package:lichess_mobile/src/widgets/emoji_picker/widget.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/yes_no_dialog.dart';
import 'package:result_extensions/result_extensions.dart';

final _countries = countries.values.toList();

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const EditProfileScreen());
  }

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{
    'flag': null,
    'location': null,
    'bio': null,
    'realName': null,
    'lastName': null,
    'fideRating': null,
    'uscfRating': null,
    'ecfRating': null,
    'rcfRating': null,
    'cfcRating': null,
    'dsbRating': null,
    'links': null,
  };

  bool _formHasChanges(User user) {
    final formState = _formKey.currentState;
    if (formState != null) {
      if (formState.validate()) {
        formState.save();
        return _formData['bio'] != user.profile?.bio ||
            _formData['flair'] != user.flair ||
            _formData['flag'] != user.profile?.country ||
            _formData['location'] != user.profile?.location ||
            _formData['realName'] != user.profile?.realName ||
            _formData['fideRating'] != user.profile?.fideRating ||
            _formData['uscfRating'] != user.profile?.uscfRating ||
            _formData['ecfRating'] != user.profile?.ecfRating ||
            _formData['rcfRating'] != user.profile?.rcfRating ||
            _formData['cfcRating'] != user.profile?.cfcRating ||
            _formData['dsbRating'] != user.profile?.dsbRating ||
            _formData['links'] != user.profile?.links?.map((e) => e.url).join('\r\n');
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    switch (account) {
      case AsyncData(:final value):
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.editProfile)),
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, _) async {
              if (didPop) {
                return;
              }
              final NavigatorState navigator = Navigator.of(context);
              if (value == null || !_formHasChanges(value)) {
                return navigator.pop();
              }
              final bool? shouldPop = await _showBackDialog(context);
              if (shouldPop ?? false) {
                navigator.pop();
              }
            },
            child: value == null
                ? Center(child: Text(context.l10n.mobileMustBeLoggedIn))
                : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: Styles.bodyPadding.copyWith(top: 0, bottom: 0),
                      child: ListView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        children: [
                          SizedBox(height: Styles.bodyPadding.top),
                          Text(context.l10n.allInformationIsPublicAndOptional),
                          const SizedBox(height: 16),
                          _EditProfileForm(value, _formKey, _formData),
                          SizedBox(height: Styles.bodyPadding.bottom),
                        ],
                      ),
                    ),
                  ),
          ),
        );

      case AsyncError(:final error):
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.editProfile)),
          body: Center(child: Text(error.toString())),
        );
      case _:
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.editProfile)),
          body: const Center(child: CircularProgressIndicator.adaptive()),
        );
    }
  }

  Future<bool?> _showBackDialog(BuildContext context) {
    return showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return YesNoDialog(
          title: Text(context.l10n.mobileAreYouSure),
          content: const Text('Your changes will be lost.'),
          onNo: () => Navigator.of(context).pop(false),
          onYes: () => Navigator.of(context).pop(true),
        );
      },
    );
  }
}

class _EditProfileForm extends ConsumerStatefulWidget {
  const _EditProfileForm(this.user, this.formKey, this.formData);

  final User user;
  final Map<String, dynamic> formData;
  final GlobalKey<FormState> formKey;

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<_EditProfileForm> {
  Future<void>? _pendingSaveProfile;

  @override
  Widget build(BuildContext context) {
    final String? initialLinks = widget.user.profile?.links?.map((e) => e.url).join('\r\n');

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TextField(
            label: context.l10n.biography,
            initialValue: widget.user.profile?.bio,
            formKey: 'bio',
            formData: widget.formData,
            description: context.l10n.biographyDescription,
            maxLength: 400,
            maxLines: 6,
            textInputAction: TextInputAction.newline,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FormField<String>(
              initialValue: widget.user.flair,
              onSaved: (value) {
                widget.formData['flair'] = value;
              },
              builder: (FormFieldState<String> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.flair, style: Styles.formLabel),
                    const SizedBox(height: 6.0),
                    InkWell(
                      onTap: () {
                        showAdaptiveDialog<String>(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return Consumer(
                              builder: (context, ref, _) {
                                final flairListAsync = ref.watch(flairListProvider);
                                switch (flairListAsync) {
                                  case AsyncData(:final value):
                                    return SafeArea(
                                      child: Dialog(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                                            maxWidth: MediaQuery.sizeOf(context).width * 0.9,
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 4.0,
                                                  ),
                                                  child: EmojiPicker(
                                                    emojiData: value,
                                                    itemBuilder:
                                                        (context, emojiId, emoji, callback) {
                                                          return EmojiItem(
                                                            onTap: () {
                                                              callback(emojiId, emoji);
                                                            },
                                                            emoji: emoji,
                                                          );
                                                        },
                                                    onEmojiSelected: (emojiId, emoji) {
                                                      Navigator.of(context).pop(emojiId);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop('__clear__');
                                                    },
                                                    child: Text(context.l10n.mobileClearButton),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(context.l10n.cancel),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  case _:
                                    return Dialog(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                                          maxWidth: MediaQuery.sizeOf(context).width * 0.9,
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        ),
                                      ),
                                    );
                                }
                              },
                            );
                          },
                        ).then((value) {
                          if (value != null) {
                            if (value == '__clear__') {
                              field.didChange(null);
                            } else {
                              field.didChange(value);
                            }
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: field.value != null
                            ? HttpNetworkImageWidget(lichessFlairSrc(field.value!))
                            : Text(context.l10n.setFlair),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FormField<String>(
              initialValue: widget.user.profile?.country,
              onSaved: (value) {
                widget.formData['flag'] = value;
              },
              builder: (FormFieldState<String> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.countryRegion, style: Styles.formLabel),
                    const SizedBox(height: 6.0),
                    Autocomplete<String>(
                      initialValue: field.value != null
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
                      fieldViewBuilder:
                          (
                            BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted,
                          ) {
                            return TextField(
                              controller: textEditingController,
                              textInputAction: TextInputAction.next,
                              focusNode: focusNode,
                              onSubmitted: (String value) {
                                onFieldSubmitted();
                              },
                            );
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
            formData: widget.formData,
            formKey: 'location',
            maxLength: 80,
          ),
          _TextField(
            label: context.l10n.realName,
            initialValue: widget.user.profile?.realName,
            formKey: 'realName',
            formData: widget.formData,
            maxLength: 100,
          ),

          _NumericField(
            label: context.l10n.xRating('FIDE'),
            initialValue: widget.user.profile?.fideRating,
            formKey: 'fideRating',
            formData: widget.formData,
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
            formData: widget.formData,
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
            formData: widget.formData,
            validator: (value) {
              if (value != null && (value < 0 || value > 3000)) {
                return 'Rating must be between 0 and 3000';
              }
              return null;
            },
          ),
          _NumericField(
            label: context.l10n.xRating('RCF'),
            initialValue: widget.user.profile?.rcfRating,
            formKey: 'rcfRating',
            formData: widget.formData,
            validator: (value) {
              if (value != null && (value < 0 || value > 3000)) {
                return 'Rating must be between 0 and 3000';
              }
              return null;
            },
          ),
          _NumericField(
            label: context.l10n.xRating('CFC'),
            initialValue: widget.user.profile?.cfcRating,
            formKey: 'cfcRating',
            formData: widget.formData,
            validator: (value) {
              if (value != null && (value < 200 || value > 3000)) {
                return 'Rating must be between 200 and 3000';
              }
              return null;
            },
          ),
          _NumericField(
            label: context.l10n.xRating('DSB'),
            initialValue: widget.user.profile?.dsbRating,
            formKey: 'dsbRating',
            formData: widget.formData,
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
            formData: widget.formData,
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
                return FilledButton(
                  onPressed: snapshot.connectionState == ConnectionState.waiting
                      ? null
                      : () async {
                          if (widget.formKey.currentState!.validate()) {
                            widget.formKey.currentState!.save();
                            widget.formData.removeWhere((key, value) {
                              return value == null;
                            });
                            final future = Result.capture(
                              ref
                                  .read(accountRepositoryProvider)
                                  .saveProfile(
                                    widget.formData.map(
                                      (key, value) => MapEntry(key, value.toString()),
                                    ),
                                  ),
                            );

                            setState(() {
                              _pendingSaveProfile = future;
                            });

                            final result = await future;

                            result.match(
                              onError: (err, _) {
                                if (context.mounted) {
                                  showSnackBar(
                                    context,
                                    'Something went wrong',
                                    type: SnackBarType.error,
                                  );
                                }
                              },
                              onSuccess: (_) {
                                if (context.mounted) {
                                  ref.invalidate(accountProvider);
                                  showSnackBar(
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
  final Map<String, dynamic> formData;
  const _NumericField({
    required this.label,
    required this.initialValue,
    required this.formKey,
    required this.validator,
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
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(errorText: field.errorText),
                onChanged: (value) {
                  field.didChange(int.tryParse(value));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TextField extends StatefulWidget {
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

  final String label;
  final String? initialValue;
  final String formKey;
  final String? description;
  final int? maxLength;
  final int? maxLines;
  final Map<String, dynamic> formData;
  final TextInputAction textInputAction;

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
              TextField(
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                controller: _controller,
                decoration: InputDecoration(errorText: field.errorText),
                textInputAction: widget.textInputAction,
                onChanged: (value) {
                  field.didChange(value.trim());
                },
              ),
              if (widget.description != null) ...[
                const SizedBox(height: 6.0),
                Text(widget.description!, style: Styles.formDescription),
              ],
            ],
          );
        },
      ),
    );
  }
}
