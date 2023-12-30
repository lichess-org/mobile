import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/user/user_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/user_list_tile.dart';

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
    return ListView.separated(
      separatorBuilder: (context, index) => const PlatformDivider(
        height: 1,
        cupertinoHasLeading: true,
      ),
      itemCount: userList.length,
      itemBuilder: (context, index) => UserListTile.fromLightUser(
        userList[index],
        onTap: () => {
          pushPlatformRoute(
            context,
            builder: (ctx) => UserScreen(user: userList[index]),
          ),
        },
      ),
    );
  }
}
