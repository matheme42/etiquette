import 'package:auto_size_text/auto_size_text.dart';
import 'package:etiquette/database/filter.dart';
import 'package:etiquette/database/product_fields.dart';
import 'package:etiquette/widget_librairies/hover_button.dart';
import 'package:flutter/material.dart';

class SearchFilterListTile extends StatefulWidget {
  final String title;
  final AutoSizeGroup group;

  const SearchFilterListTile(
      {super.key, required this.title, required this.group});

  @override
  State<StatefulWidget> createState() => SearchFilterListTileState();
}

class SearchFilterListTileState extends State<SearchFilterListTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: AutoSizeText(widget.title,
            maxLines: 1, minFontSize: 8, group: widget.group),
        controlAffinity: ListTileControlAffinity.leading,
        value: Filter().searchBarAffinity.contains(widget.title),
        onChanged: (val) {
          setState(() {
            if (val == true) {
              Filter().searchBarAffinity.add(widget.title);
            } else {
              Filter().searchBarAffinity.remove(widget.title);
            }
          });
          Filter().updateSharedPreferenceSearchBarAffinity();
        });
  }
}

class DatatableSearchBarFilter extends StatelessWidget {
  const DatatableSearchBarFilter({super.key});

  static final AutoSizeGroup group = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 64,
      child: HoverButton(
          contentWidth: 200,
          margin: const EdgeInsets.only(left: 2),
          buttonContent: SizedBox(
            height: 64,
            width: 64,
            child: Center(
              child: SizedBox(
                height: 48,
                width: 48,
                child: MaterialButton(
                  padding: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {},
                  child: Image.asset('images/icon/filtre.png'),
                ),
              ),
            ),
          ),
          buttonHeight: 64,
          child: Card(
            child: SizedBox(
              height: 350,
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyHeaderDelegate(
                        child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration:
                                const BoxDecoration(color: Color(0xfff7f1fb)),
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: const Text('Rechercher depuis:'))),
                  ),
                  SliverFixedExtentList(
                      delegate: SliverChildListDelegate([
                        SearchFilterListTile(
                            title: ProductField.libelle1, group: group),
                        SearchFilterListTile(
                            title: ProductField.libelle2, group: group),
                        SearchFilterListTile(
                            title: ProductField.famille, group: group),
                        SearchFilterListTile(
                            title: ProductField.sousFamille, group: group),
                        SearchFilterListTile(
                            title: ProductField.codeMedial, group: group),
                        SearchFilterListTile(
                            title: ProductField.codeBarre, group: group),
                        SearchFilterListTile(
                            title: ProductField.lieu, group: group),
                        SearchFilterListTile(
                            title: ProductField.dotation, group: group),
                        SearchFilterListTile(
                            title: ProductField.modalite, group: group),
                        SearchFilterListTile(
                            title: ProductField.toxicite, group: group),
                      ]),
                      itemExtent: 50)
                ],
              ),
            ),
          )),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 40;

  @override
  double get maxExtent => 40; // Adjust this value according to your needs

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
