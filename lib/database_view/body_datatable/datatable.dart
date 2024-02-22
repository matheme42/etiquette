import 'package:auto_size_text/auto_size_text.dart';
import 'package:etiquette/database/basket.dart';
import 'package:etiquette/database/product.dart';
import 'package:etiquette/database/product_fields.dart';
import 'package:etiquette/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../database/filter.dart';

class ProductDatatable extends StatefulWidget {
  final ProductController productController;
  final TextEditingController searchController;
  final List<Product> selectedProducts;
  final ValueNotifier<bool> updateSelectButton;

  final void Function(Product? product) onHoverProduct;
  final void Function(Product product) onSelectProduct;

  const ProductDatatable(
      {super.key,
      required this.productController,
      required this.searchController,
      required this.onHoverProduct,
      required this.onSelectProduct,
      required this.selectedProducts,
      required this.updateSelectButton});

  @override
  State<StatefulWidget> createState() => ProductDatatableState();
}

class ProductDatatableState extends State<ProductDatatable> {
  ScrollController horizontalScrollController = ScrollController();
  ScrollController verticalScrollController = ScrollController();

  AutoSizeGroup labelGroup = AutoSizeGroup();

  List<Product> filteredProduct = [];

  int? selectedRow;
  int? selectedColumn;

  final List<String> titleName = [
    ProductField.index,
    ProductField.libelle1,
    ProductField.libelle2,
    ProductField.famille,
    ProductField.sousFamille,
    ProductField.codeMedial,
    ProductField.quantite,
    ProductField.lieu,
    ProductField.modalite,
    ProductField.dotation,
    ProductField.toxicite,
    ProductField.codeBarre,
    ProductField.abriLumiere,
    ProductField.frigo,
    ProductField.medicamentARisque
  ];

  final List<double> titleSize = [
    90, // index
    320, // libelle 1
    320, // libelle 2
    220, // famille
    220, // sous-famille
    170, // code medial
    120, // quantité
    220, // lieu
    140, // modalité
    200, // dotation
    120, // toxicité
    170, // code barre
    180, // abri lumière
    180, // frigo
    220 // medicament à risque
  ];

  @override
  void initState() {
    super.initState();
    Filter().filteredProduct = widget.productController.products;
    filteredProduct = Filter().filteredProduct;
    Filter().addListener(update);
    Basket().addListener(onBasketChange);
  }

  void onBasketChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    Filter().removeListener(update);
    Basket().removeListener(onBasketChange);
    super.dispose();
  }

  void update() => setState(() {
        if (widget.searchController.text.trim().isEmpty) {
          filteredProduct = Filter().filteredProduct;
          return;
        }
        filteredProduct = Filter().filteredProduct.where(productTest).toList();
      });

  Widget _buildCell(BuildContext context, TableVicinity vicinity) {
    if (vicinity.column == 0 && vicinity.row != 0) {
      Product product = filteredProduct[vicinity.row - 1];

      return Checkbox(
          activeColor: Colors.deepPurple,
          value: widget.selectedProducts.contains(product),
          onChanged: (value) {
            setState(() {
              value == true
                  ? widget.selectedProducts.add(product)
                  : widget.selectedProducts.remove(product);
              widget.updateSelectButton.value =
                  !widget.updateSelectButton.value;
            });
          });
    }
    if (vicinity.row == 0) {
      bool value = false;
      if (vicinity.column == 0) {
        var a = filteredProduct;
        var b = widget.selectedProducts;
        value = a.toSet().difference(b.toSet()).isEmpty;
      }
      return Material(
        child: Card(
          color: Colors.deepPurpleAccent,
          elevation: 1,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              if (vicinity.column == 0) {
                setState(() {
                  widget.selectedProducts.clear();
                  if (value) return;
                  widget.selectedProducts.addAll(filteredProduct);
                });
                widget.updateSelectButton.value =
                    !widget.updateSelectButton.value;
              }
            },
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  Flexible(
                      flex: 5,
                      child: Builder(builder: (context) {
                        if (vicinity.column == 0) {
                          return AbsorbPointer(
                            absorbing: true,
                            child: Checkbox(
                                activeColor: Colors.deepPurple,
                                value: value,
                                onChanged: (val) {}),
                          );
                        }
                        return AutoSizeText(
                          titleName[vicinity.column],
                          group: labelGroup,
                          maxLines: 1,
                        );
                      })),
                  Flexible(
                    child: Builder(builder: (context) {
                      if (vicinity.column == 12) {
                        return Image.asset('images/logo/abri.png');
                      } else if (vicinity.column == 13) {
                        return Image.asset('images/logo/frigo.png');
                      } else if (vicinity.column == 14) {
                        return Image.asset('images/logo/dangeureux.png');
                      }
                      return const SizedBox.expand();
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    Product product = filteredProduct[vicinity.row - 1];
    List<String> texts = product.asList();
    String matchedText = "";
    if (Filter().searchBarAffinity.contains(titleName[vicinity.column])) {
      matchedText = widget.searchController.text.trim().toLowerCase();
    }
    return Center(
        child: Text(texts[vicinity.column], textAlign: TextAlign.center)
            .boldSubString(matchedText));
  }

  TableSpan _buildColumnSpan(int index) {
    return TableSpan(
        foregroundDecoration: TableSpanDecoration(
            color: index == selectedColumn ? Colors.black12 : null,
            border: TableSpanBorder(
                trailing: const BorderSide(),
                leading: index == 0 ? const BorderSide() : BorderSide.none)),
        extent: FixedTableSpanExtent(titleSize[index]));
  }

  TableSpan _buildRowSpan(int index) {
    Color? backgroundColor;
    if (index > 0) {
      Product product = filteredProduct[index - 1];
      for (var e in Basket().productSelections) {
        if (product.barCode == e.product.barCode) {
          backgroundColor = Colors.deepPurpleAccent.withAlpha(50);
          break;
        }
      }
    }
    return TableSpan(
      backgroundDecoration: TableSpanDecoration(
          color: index == selectedRow ? Colors.black12 : backgroundColor,
          border: TableSpanBorder(
              trailing: const BorderSide(),
              leading: index == 0 ? const BorderSide() : BorderSide.none)),
      extent: const FixedTableSpanExtent(50),
      cursor: SystemMouseCursors.click,
      onExit: (_) =>
          [setState(() => selectedRow = null), widget.onHoverProduct(null)],
      onEnter: index > 0
          ? (_) => [
                setState(() => selectedRow = index),
                widget.onHoverProduct(filteredProduct[index - 1])
              ]
          : null,
      recognizerFactories: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                () => TapGestureRecognizer(), (TapGestureRecognizer t) {
          if (index > 0) {
            t.onTap = () {
              widget.updateSelectButton.value =
                  !widget.updateSelectButton.value;
              if (widget.selectedProducts
                  .contains(filteredProduct[index - 1])) {
                setState(() {
                  widget.selectedProducts.remove(filteredProduct[index - 1]);
                });
                return;
              }
              setState(() {
                widget.selectedProducts.add(filteredProduct[index - 1]);
              });
            };
            return;
            //t.onTap = () => widget.onSelectProduct(filteredProduct[index - 1]);
          }
        }),
      },
    );
  }

  bool productTest(Product product) {
    String text = widget.searchController.text
        .trim()
        .toLowerCase()
        .replaceAllDiacritics();
    List<String> filterData = Filter().searchBarAffinity;

    if (filterData.contains(ProductField.libelle1) &&
        product.softLibelle1.contains(text)) {
      return true;
    }
    if (filterData.contains(ProductField.libelle2) &&
        product.softLibelle2.contains(text)) {
      return true;
    }
    if (filterData.contains(ProductField.famille) &&
        product.softFamily.contains(text)) {
      return true;
    }
    if (filterData.contains(ProductField.sousFamille) &&
        product.softSubFamily.contains(text)) {
      return true;
    }
    if (filterData.contains(ProductField.codeMedial) &&
        product.codeMedial.contains(text)) {
      return true;
    }
    if (filterData.contains(ProductField.codeBarre) && product.barCode.contains(text)) {
      return true;
    }
    if (filterData.contains(ProductField.lieu) &&
        product.softLieu.contains(text)) {
      return true;
    }

    if (filterData.contains(ProductField.dotation) &&
        product.softDotation.contains(text)) {
      return true;
    }
    if (filterData.contains(ProductField.modalite) &&
        product.softModality.contains(text)) {
      return true;
    }
    if (filterData.contains(ProductField.toxicite) &&
        product.toxicity.toString().contains(text)) {
      return true;
    }
    return false;
  }

  @override
  void didUpdateWidget(covariant ProductDatatable oldWidget) {
    if (widget.searchController.text.trim().isEmpty) {
      filteredProduct = Filter().filteredProduct;
      return;
    }
    filteredProduct = Filter().filteredProduct.where(productTest).toList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: horizontalScrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: Scrollbar(
        controller: verticalScrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: TableView.builder(
              horizontalDetails: ScrollableDetails.horizontal(
                  controller: horizontalScrollController),
              verticalDetails: ScrollableDetails.vertical(
                  controller: verticalScrollController),
              columnCount: titleName.length,
              rowCount: filteredProduct.length + 1,
              pinnedRowCount: 1,
              pinnedColumnCount: 1,
              columnBuilder: _buildColumnSpan,
              rowBuilder: _buildRowSpan,
              cellBuilder: _buildCell,
            ),
          ),
        ),
      ),
    );
  }
}
