import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen();

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String? _term;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final term = _searchController.text;
    if (term.length > 3) {
      ref.read(autoCompleteUserProvider(term));
      setState(() {
        _term = term;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // when a user inputs text with character > 3 use this provider
    // ref.watch(autoCompleteUserProvider(term))
    // here 'term' is the string from the input field.
    // the call should be debounded for 150 millis as the user might be typing
    // to debounce maybe user a timer and cancel it
    // also send the result to the body
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search Lichess',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _Body(_term),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.term);

  final String? term;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (term != null) {
      final autoComplete = ref.watch(autoCompleteUserProvider(term!));
      return SafeArea(
        child: autoComplete.when(
          data: (users) => _UserList(users),
          error: (e, s) => Text('$e'),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _UserList extends ConsumerWidget {
  const _UserList(this.userList);

  final IList<LightUser> userList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.shrink();
  }
}
