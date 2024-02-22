import 'package:auto_size_text/auto_size_text.dart';
import 'package:etiquette/extensions.dart';
import 'package:flutter/material.dart';

class DatatableFilterContent extends StatefulWidget {
  final List<String> datas;
  final List<String> filter;
  final void Function() onChangeFilter;
  final void Function(bool) onWantSort;

  const DatatableFilterContent(
      {super.key,
      required this.datas,
      required this.onWantSort,
      required this.filter,
      required this.onChangeFilter});

  @override
  State<StatefulWidget> createState() => DatatableFilterContentState();
}

class DatatableFilterContentState extends State<DatatableFilterContent> {
  List<String> filteredData = [];

  TextEditingController controller = TextEditingController();
  AutoSizeGroup group = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    filteredData = widget.datas;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.hardEdge,
      borderOnForeground: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                onTap: () {
                  if (filteredData.length < 2) return;
                  setState(() => filteredData.sort((a, b) => a.compareTo(b)));
                  widget.onWantSort(false);
                },
                leading: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_down_outlined),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('A'), Text('Z')],
                    )
                  ],
                ),
                title: const AutoSizeText("Trier par ordre croissant",
                    maxLines: 1, minFontSize: 8),
              ),
              ListTile(
                onTap: () {
                  if (filteredData.length < 2) return;
                  setState(() => filteredData.sort((b, a) => a.compareTo(b)));
                  widget.onWantSort(true);
                },
                leading: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_outlined),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('A'), Text('Z')],
                    )
                  ],
                ),
                title: const AutoSizeText("Trier par ordre decroissant",
                    maxLines: 1, minFontSize: 8),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(),
              ),
            ]),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
                child: Container(
              decoration: const BoxDecoration(color: Color(0xffede4f7)),
              alignment: Alignment.topCenter,
              margin: EdgeInsets.zero,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextField(
                controller: controller,
                onChanged: (value) {
                  value = value.trim().toLowerCase().replaceAllDiacritics();
                  setState(() {
                    filteredData =
                        widget.datas.where((e) => e.contains(value)).toList();
                  });
                },
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                    prefixIcon: Builder(builder: (context) {
                      if (widget.filter.isNotEmpty) {
                        return IconButton(
                            onPressed: () {
                              setState(() => widget.filter.clear());
                              widget.onChangeFilter();
                            },
                            tooltip: "tout déselectionner",
                            icon: const Icon(
                              Icons.check_box_outlined,
                            ));
                      }
                      return const SizedBox.shrink();
                    }),
                    suffixIcon: const Icon(Icons.search),
                    isCollapsed: false,
                    isDense: true,
                    contentPadding: const EdgeInsets.only(left: 8.0),
                    hintText: "Chercher",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
            )),
          ),
          SliverFixedExtentList(
              delegate: SliverChildListDelegate(
                  List<Widget>.generate(filteredData.length + 1, (index) {
                if (index == filteredData.length) {
                  return const SizedBox(height: 70);
                }
                String data = filteredData[index];
                return CheckboxListTile(
                  value: widget.filter.contains(data),
                  onChanged: (val) {
                    setState(() {
                      val == true
                          ? widget.filter.add(data)
                          : widget.filter.remove(data);
                      widget.onChangeFilter();
                    });
                  },
                  title: AutoSizeText(data.capitalize(),
                          minFontSize: 8,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)
                      .boldSubString(controller.text, group),
                  controlAffinity: ListTileControlAffinity.leading,
                );
              })),
              itemExtent: 50)
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 70;

  @override
  double get maxExtent => 70; // Adjust this value according to your needs

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

extension BoldSubString on AutoSizeText {
  AutoSizeText boldSubString(String target, AutoSizeGroup group) {
    final textSpans = List.empty(growable: true);
    final escapedTarget = RegExp.escape(target);
    final pattern = RegExp(escapedTarget, caseSensitive: false);
    final matches = pattern.allMatches(data!);

    int currentIndex = 0;
    for (final match in matches) {
      final beforeMatch = data!.substring(currentIndex, match.start);
      if (beforeMatch.isNotEmpty) {
        textSpans.add(TextSpan(text: beforeMatch));
      }

      final matchedText = data!.substring(match.start, match.end);
      textSpans.add(
        TextSpan(
          text: matchedText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < data!.length) {
      final remainingText = data!.substring(currentIndex);
      textSpans.add(TextSpan(text: remainingText));
    }

    return AutoSizeText.rich(
      TextSpan(children: <TextSpan>[...textSpans]),
      group: group,
      minFontSize: 8,
      maxLines: 1,
    );
  }
}
