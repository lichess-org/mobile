import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController controller = SearchController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: controller,
      builder: (context, controller) => Stack(
        children: [
          SearchBar(
            shadowColor: MaterialStateColor.resolveWith(
              (states) => Colors.transparent,
            ),
            constraints: const BoxConstraints(maxHeight: 50),
            hintText: "Search Lichess",
            leading: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          InkWell(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
            ),
            onTap: () {
              controller.openView();
            },
          )
        ],
      ),
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        });
      },
    );
  }
}
