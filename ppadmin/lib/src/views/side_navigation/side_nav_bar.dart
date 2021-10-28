import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';

import 'bar_item_tile.dart';
import 'side_nav_bar_item.dart';

/// Takes the data from [items] and builds [SideNavBarItemTile] with it.
///
/// [selectedIndex] is handled by the user. It defines what item of the navigation
/// options is currently selected.
///
/// Use [onTap] to provide a callback that [selectedIndex] has changed.
///
class SideNavBar extends StatefulWidget {
  /// The current index of the navigation bar
  final int selectedIndex;

  /// The items to put into the bar
  final List<SideNavBarItem> items;

  /// What to do when an item as been tapped
  final ValueChanged<int> onTap;

  /// Specifies wheter that [SideNavBar] is expanded or not. Default is true
  final bool expandable;

  /// The [IconData] to use when building the button to toggle [expanded]
  final IconData expandIcon;
  final IconData shrinkIcon;

  const SideNavBar(
      {Key? key,
      required this.selectedIndex,
      required this.items,
      required this.onTap,
      this.expandable = false,
      this.expandIcon = Icons.arrow_right,
      this.shrinkIcon = Icons.arrow_left})
      : super(key: key);

  @override
  _SideNavBarState createState() => _SideNavBarState();

  static _SideNavBarState of(BuildContext context) =>
      context.findAncestorStateOfType<_SideNavBarState>()!;
}

class _SideNavBarState extends State<SideNavBar>
    with SingleTickerProviderStateMixin {
  final double minWidth = 50;
  final double maxWidth = 250;
  late double width;

  bool expanded = true;

  @override
  void initState() {
    super.initState();
    width = maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GREY_BACKGROUND_COLOR,
        // border: Border(
        //   right: BorderSide(
        //     width: 1,
        //     color: MediaQuery.of(context).platformBrightness == Brightness.light
        //         ? Colors.grey[700]!
        //         : Colors.white,
        //   ),
        // ),
      ),
      child: SizedBox(
          width: width,
          height: double.infinity,
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageConstants.IMG_LOGO_NO_BG,
                    height: 72,
                  ),
                  Text(
                    POLICE_PATIL_APP,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: TEXT_COLOR_TITLE),
                  )
                ],
              ),
              const Divider(),
              // Navigation content
              Expanded(
                child: Scrollbar(
                  child: ListView(
                    children: _generateItems(expanded),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  /// Takes [SideNavBarItem] data and builds new widgets with it.
  List<Widget> _generateItems(final bool _expanded) {
    List<Widget> _items = widget.items
        .asMap()
        .entries
        .map<SideNavBarItemTile>((MapEntry<int, SideNavBarItem> entry) {
      return SideNavBarItemTile(
          image: entry.value.image,
          label: entry.value.label,
          onTap: widget.onTap,
          index: entry.key,
          expanded: expanded,
          color: PRIMARY_COLOR);
    }).toList();
    return _items;
  }
}
