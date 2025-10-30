import 'package:flutter/material.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/rate_limit.dart';
import 'package:lichess_mobile/src/widgets/emoji_picker/emoji_item.dart';
import 'package:lichess_mobile/src/widgets/emoji_picker/emoji_picker_configuration.dart';
import 'package:lichess_mobile/src/widgets/emoji_picker/emoji_picker_models.dart';
import 'package:visibility_detector/visibility_detector.dart';

typedef EmojiSearchBarBuilder =
    Widget Function(
      BuildContext context,
      ValueNotifier<String> keyword,
      ValueNotifier<EmojiSkinTone> skinTone,
    );

typedef EmojiSectionHeaderBuilder =
    Widget Function(BuildContext context, Category category);

typedef EmojiItemBuilder =
    Widget Function(
      BuildContext context,
      String emojiId,
      String emoji,
      EmojiSelectedCallback callback,
    );

class EmojiPicker extends StatefulWidget {
  const EmojiPicker({
    super.key,
    required this.emojiData,
    required this.onEmojiSelected,
    this.searchBarBuilder,
    this.headerBuilder,
    this.itemBuilder,
    this.configuration = const EmojiPickerConfiguration(),
    this.padding = EdgeInsets.zero,
  });

  /// Data to use for the picker
  ///
  /// You can use the [EmojiData] class to load the data from a JSON file or from
  ///   a custom source
  final EmojiData emojiData;

  /// Callback when an emoji is selected
  final EmojiSelectedCallback onEmojiSelected;

  /// Custom the emoji picker configuration
  final EmojiPickerConfiguration configuration;

  /// Builder for the emoji search bar
  ///
  /// If this is null, the default search bar will be used
  final EmojiSearchBarBuilder? searchBarBuilder;

  /// Builder for the emoji section header
  ///
  /// If this is null, the default section header will be used
  final EmojiSectionHeaderBuilder? headerBuilder;

  /// Builder for the emoji item
  ///
  ///
  final EmojiItemBuilder? itemBuilder;

  /// Padding for the emoji picker
  final EdgeInsets padding;

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker>
    with SingleTickerProviderStateMixin {
  final _debouncer = Debouncer(const Duration(milliseconds: 250));

  // global keys for each section
  //
  // it's used to scroll to a specific section
  final sectionKeys = <String, GlobalKey>{};

  // the index of the most visible section
  final ValueNotifier<int> mostVisibleIndex = ValueNotifier(0);

  // store the visible fraction of each section
  // the key is the category id
  // the value is the visible fraction
  // if the visible fraction is equal or less than 0, it means the section is not visible
  final visibleSections = <String, double>{};

  // the text in the search bar
  final ValueNotifier<String> keyword = ValueNotifier('');

  // current selected skin tone
  final ValueNotifier<EmojiSkinTone> skinTone = ValueNotifier(
    EmojiSkinTone.none,
  );

  late TabController tabController;
  final scrollController = ScrollController();

  // filtered emoji data
  late EmojiData emojiData;

  @override
  void initState() {
    super.initState();

    emojiData = widget.emojiData;
    tabController = TabController(
      length: widget.emojiData.categories.length,
      vsync: this,
    );
    mostVisibleIndex.addListener(scrollToMostVisibleSectionIndex);
    skinTone.value = widget.configuration.defaultSkinTone;

    for (final element in emojiData.categories) {
      sectionKeys[element.id] = GlobalKey();
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    mostVisibleIndex.removeListener(scrollToMostVisibleSectionIndex);
    mostVisibleIndex.dispose();
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // tab bar
        if (widget.configuration.showTabs) _buildTabBar(context),

        // search bar
        if (widget.configuration.showSearchBar)
          widget.searchBarBuilder?.call(context, keyword, skinTone) ??
              EmojiSearchBar(
                configuration: widget.configuration,
                onKeywordChanged: (keyword) {
                  this.keyword.value = keyword;
                },
              ),

        // sections
        Expanded(child: _buildSections(context)),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final tabs = widget.emojiData.categories
        .map(
          (category) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Icon(categoryIcon(category.id), size: 20),
          ),
        )
        .toList();
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      controller: tabController,
      tabs: tabs,
      onTap: (index) {
        scrollToSection(index);
      },
    );
  }

  Widget _buildSections(BuildContext context) {
    CustomScrollView builder(EmojiData emojiData, EmojiSkinTone skinTone) =>
        CustomScrollView(
          controller: scrollController,
          slivers: emojiData.categories
              .map(
                (category) => SliverPadding(
                  padding: widget.padding,
                  sliver: SliverVisibilityDetector(
                    key: ValueKey(category.id),
                    onVisibilityChanged: (info) =>
                        updateMostVisibleSection(category.id, info),
                    sliver: EmojiSection(
                      sectionKey: sectionKeys[category.id]!,
                      skinTone: skinTone,
                      configuration: widget.configuration,
                      emojiData: emojiData,
                      category: category,
                      headerBuilder: widget.headerBuilder,
                      itemBuilder: widget.itemBuilder,
                      onEmojiSelected: widget.onEmojiSelected,
                    ),
                  ),
                ),
              )
              .toList(),
        );

    if (widget.configuration.showSearchBar) {
      return ValueListenableBuilder<EmojiSkinTone>(
        valueListenable: skinTone,
        builder: (_, skinTone, _) {
          return ValueListenableBuilder(
            valueListenable: keyword,
            builder: (_, keyword, _) {
              final emojiData = widget.emojiData.filterByKeyword(keyword);
              if (emojiData.categories.isEmpty) {
                return const Center(child: Text('Oops, no emoji found'));
              }
              return builder(emojiData, skinTone);
            },
          );
        },
      );
    }

    return builder(emojiData, EmojiSkinTone.none);
  }

  void scrollToMostVisibleSectionIndex() {
    final index = mostVisibleIndex.value;
    tabController.animateTo(index);
  }

  Future<void> scrollToSection(int index) async {
    final categoryId = widget.emojiData.categories[index].id;
    final key = sectionKeys[categoryId];
    final currentContext = key?.currentContext;
    if (currentContext != null) {
      await Scrollable.ensureVisible(currentContext);
    }
  }

  // Count the most visible section based on the visibility info
  void updateMostVisibleSection(String categoryId, VisibilityInfo info) {
    visibleSections[categoryId] = info.visibleFraction;

    // Remove the category if it is not visible
    if (info.visibleFraction <= 0) {
      visibleSections.remove(categoryId);
    }

    // Update the most visible index
    _debouncer(() {
      // If there are no visible sections, return
      if (visibleSections.isEmpty) {
        return;
      }
      // Find the category with the highest visibility fraction
      final mostVisibleCategoryId = visibleSections.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      mostVisibleIndex.value = widget.emojiData.categories.indexWhere(
        (category) => category.id == mostVisibleCategoryId,
      );
    });
  }

  IconData categoryIcon(String categoryId) {
    switch (categoryId) {
      case 'smileys':
        return Icons.emoji_emotions_outlined;
      case 'people':
        return Icons.tag_faces_outlined;
      case 'nature':
        return Icons.park_outlined;
      case 'food-drink':
        return Icons.lunch_dining_outlined;
      case 'activity':
        return Icons.sports_basketball_outlined;
      case 'travel-places':
        return Icons.directions_car_outlined;
      case 'objects':
        return Icons.lightbulb_outlined;
      case 'symbols':
        return Icons.emoji_symbols_outlined;
      default:
        return Icons.emoji_emotions_outlined;
    }
  }
}

class EmojiSection extends StatelessWidget {
  const EmojiSection({
    super.key,
    required this.configuration,
    required this.emojiData,
    required this.category,
    required this.onEmojiSelected,
    required this.sectionKey,
    this.headerBuilder,
    this.itemBuilder,
    this.skinTone = EmojiSkinTone.none,
  });

  final Key sectionKey;
  final EmojiPickerConfiguration configuration;
  final EmojiData emojiData;
  final Category category;
  final EmojiSkinTone skinTone;
  final EmojiSelectedCallback onEmojiSelected;
  final EmojiSectionHeaderBuilder? headerBuilder;
  final EmojiItemBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        if (configuration.showSectionHeader)
          PinnedHeaderSliver(
            child:
                headerBuilder?.call(context, category) ??
                EmojiSectionHeader(
                  category: category,
                  configuration: configuration,
                ),
          ),
        SliverGrid.builder(
          key: sectionKey,
          itemCount: category.emojiIds.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: configuration.perLine,
          ),
          itemBuilder: (context, index) {
            final emojiId = category.emojiIds[index];
            final emojiSrc = emojiData.getEmojiById(emojiId);
            return itemBuilder?.call(
                  context,
                  emojiId,
                  emojiSrc,
                  onEmojiSelected,
                ) ??
                EmojiItem(
                  size: configuration.emojiSize,
                  emoji: emojiSrc,
                  onTap: () => onEmojiSelected(emojiId, emojiSrc),
                );
          },
        ),
      ],
    );
  }
}

class EmojiSectionHeader extends StatelessWidget {
  const EmojiSectionHeader({
    super.key,
    required this.category,
    required this.configuration,
  });

  final Category category;
  final EmojiPickerConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: double.infinity,
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainer.withValues(alpha: 1.0),
      child: Text(
        category.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class EmojiSearchBar extends StatefulWidget {
  const EmojiSearchBar({
    super.key,
    required this.configuration,
    required this.onKeywordChanged,
  });

  final EmojiPickerConfiguration configuration;
  final void Function(String keyword) onKeywordChanged;

  @override
  State<EmojiSearchBar> createState() => _EmojiSearchBarState();
}

class _EmojiSearchBarState extends State<EmojiSearchBar> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainer.withValues(alpha: 1.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // search bar
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, size: 20),
                hintText: context.l10n.searchSearch,
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 15),
              onChanged: widget.onKeywordChanged,
            ),
          ),
          IconButton(
            tooltip: context.l10n.mobileClearButton,
            icon: const Icon(Icons.clear, size: 20),
            onPressed: () {
              controller.clear();
              widget.onKeywordChanged('');
            },
          ),
        ],
      ),
    );
  }
}
