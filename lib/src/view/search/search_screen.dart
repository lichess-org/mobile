import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,

        title: Hero(
          tag: "searchHero",
          child: SearchBar(
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
        ),
      ),
    );
  }
}
