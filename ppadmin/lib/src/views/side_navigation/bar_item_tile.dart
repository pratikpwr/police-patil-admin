import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/views/side_navigation/side_nav_bar.dart';
import 'package:ppadmin/src/views/side_navigation/side_nav_bar_item.dart';

/// This widget uses the [icon] and [label] value from the [SideNavBarItem]
/// to generate a completely new widget which provides an [onTap] callback while
/// it also holds the [index] of its position defined in the [SideNavBar]'s
/// [SideNavBar.items]
class SideNavBarItemTile extends StatefulWidget {
  /// From [SideNavBarItem]
  /// What [Image] to display
  final String image;

  /// From [SideNavBarItem]
  /// Info text about the chosable navigation option
  final String label;

  /// From [SideNavBar]
  /// What to do on item tap
  final ValueChanged<int> onTap;

  /// From [SideNavBar]
  /// The currently selected index which the end user chooses
  final int index;

  final Color color;
  final bool expanded;

  const SideNavBarItemTile(
      {Key? key,
      required this.image,
      required this.label,
      required this.onTap,
      required this.index,
      required this.color,
      required this.expanded})
      : super(key: key);

  @override
  _SideNavBarItemTileState createState() => _SideNavBarItemTileState();
}

class _SideNavBarItemTileState extends State<SideNavBarItemTile> {
  @override
  Widget build(BuildContext context) {
    // Get the data holders from the parent
    final List<SideNavBarItem> barItems = SideNavBar.of(context).widget.items;
    // Get the current selected index from the parent
    final int selectedIndex = SideNavBar.of(context).widget.selectedIndex;
    // Check if this tile is selected
    final bool isSelected = isTileSelected(barItems, selectedIndex);

    /// Return a basic listTile for now
    return widget.expanded
        ? ListTile(
            leading: Image.asset(
              widget.image,
              height: 34.0,
            ),
            title: Text(
              widget.label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500
              ),
            ),
            onTap: () {
              widget.onTap(widget.index);
            },
          )
        : IconButton(
            icon: Image.asset(
              widget.image,
              height: 36.0,
            ),
            onPressed: () {
              widget.onTap(widget.index);
            },
          );
  }

  /// Determines if this tile is currently selected
  ///
  /// Looks at the both item labels to compare wheter they are equal
  /// and compares the parents [index] with this tiles index
  bool isTileSelected(final List<SideNavBarItem> items, final int index) {
    for (final SideNavBarItem item in items) {
      if (item.label == widget.label && index == widget.index) {
        return true;
      }
    }
    return false;
  }

  /// Check if this item [isSelected] and return the passed [widget.color]
  /// If it is not selected return either [Colors.white] or [Colors.grey] based on the
  /// [Brightness]
// Color getTileColor(final bool isSelected) {
//   return isSelected
//       ? widget.color
//       : (Theme.of(context).brightness == Brightness.dark
//           ? Colors.white
//           : Colors.grey);
// }
}
