import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/countries.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:result_extensions/result_extensions.dart';

final _countries = countries.values.toList();

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const EditProfileScreen());
  }

  Future<bool?> _showBackDialog(BuildContext context) {
    return showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(context.l10n.mobileAreYouSure),
          content: const Text('Your changes will be lost.'),
          actions: [
            PlatformDialogAction(
              child: Text(context.l10n.cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            PlatformDialogAction(
              child: Text(context.l10n.ok),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.editProfile)),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) async {
          if (didPop) {
            return;
          }
          final NavigatorState navigator = Navigator.of(context);
          final bool? shouldPop = await _showBackDialog(context);
          if (shouldPop ?? false) {
            navigator.pop();
          }
        },
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
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
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
                    Autocomplete<String>(
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
                      fieldViewBuilder: (
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
