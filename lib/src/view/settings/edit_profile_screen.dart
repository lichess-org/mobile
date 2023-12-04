import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/user/countries.dart';
import 'package:lichess_mobile/src/widgets/adaptive_autocomplete.dart';
import 'package:lichess_mobile/src/widgets/adaptive_text_field.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

final _countries = countries.values.toList();

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.editProfile),
      ),
      body: _Body(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
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
          return const Center(
            child: Text('You must be logged in to view this page.'),
          );
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

class _EditProfileForm extends StatefulWidget {
  const _EditProfileForm(this.user);

  final User user;

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  final _cupertinoTextFieldDecoration = BoxDecoration(
    color: CupertinoColors.tertiarySystemBackground,
    border: Border.all(
      color: CupertinoColors.systemGrey4,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(8),
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormField<String>(
            initialValue: widget.user.profile?.bio,
            builder: (FormFieldState<String> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.biography, style: Styles.formLabel),
                  const SizedBox(height: 6.0),
                  AdaptiveTextField(
                    maxLines: 6,
                    cupertinoDecoration: _cupertinoTextFieldDecoration,
                    onChanged: (value) {
                      field.didChange(value.substring(0, 400));
                    },
                    controller: TextEditingController(text: field.value),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    context.l10n.biographyDescription,
                    style: Styles.formDescription,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16.0),
          FormField<String>(
            initialValue: widget.user.profile?.country,
            builder: (FormFieldState<String> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Country', style: Styles.formLabel),
                  const SizedBox(height: 6.0),
                  AdaptiveAutoComplete<String>(
                    cupertinoDecoration: _cupertinoTextFieldDecoration,
                    initialValue: field.value != null
                        ? TextEditingValue(text: countries[field.value]!)
                        : null,
                    optionsBuilder: (TextEditingValue value) {
                      if (value.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return _countries.where((String option) {
                        return option
                            .toLowerCase()
                            .contains(value.text.toLowerCase());
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
          const SizedBox(height: 16.0),
          FormField<String>(
            initialValue: widget.user.profile?.location,
            builder: (FormFieldState<String> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.location, style: Styles.formLabel),
                  const SizedBox(height: 6.0),
                  AdaptiveTextField(
                    cupertinoDecoration: _cupertinoTextFieldDecoration,
                    onChanged: (value) {
                      field.didChange(value.substring(0, 80));
                    },
                    controller: TextEditingController(text: field.value),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16.0),
          FormField<String>(
            initialValue: widget.user.profile?.firstName,
            builder: (FormFieldState<String> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.firstName, style: Styles.formLabel),
                  const SizedBox(height: 6.0),
                  AdaptiveTextField(
                    cupertinoDecoration: _cupertinoTextFieldDecoration,
                    onChanged: (value) {
                      field.didChange(value.substring(0, 80));
                    },
                    controller: TextEditingController(text: field.value),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16.0),
          FormField<String>(
            initialValue: widget.user.profile?.lastName,
            builder: (FormFieldState<String> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.lastName, style: Styles.formLabel),
                  const SizedBox(height: 6.0),
                  AdaptiveTextField(
                    cupertinoDecoration: _cupertinoTextFieldDecoration,
                    onChanged: (value) {
                      field.didChange(value.substring(0, 80));
                    },
                    controller: TextEditingController(text: field.value),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: FatButton(
              semanticsLabel: context.l10n.apply,
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              child: Text(context.l10n.apply),
            ),
          ),
        ],
      ),
    );
  }
}
