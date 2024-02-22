import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:etiquette/database/product.dart';
import 'package:etiquette/windows_bar/windows_bar.dart';
import 'package:etiquette/windows_bar/windows_hover_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

import 'database_view/view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  // Must add this line.
  await windowManager.ensureInitialized();
  doWhenWindowReady(() {
    const initialSize = Size(1200, 600);
    appWindow.minSize = const Size(600, 500);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static GlobalKey<DatabaseViewState> databaseView =
      GlobalKey<DatabaseViewState>();

  bool fullScreen = false;

  bool onNotification(int id) {
    switch (id) {
      case 0: // want show impression list
        databaseView.currentState?.scaffoldKey.currentState?.openEndDrawer();
        break;
      case 1: // want import file
        databaseView.currentState?.selectFile();
        break;
      case 2: // want test file
        databaseView.currentState?.selectFile(true);
        break;
      default:
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<MenuNotification>(
      onNotification: (notif) => onNotification(notif.id),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Etiquette',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: 'Lora'),
        home: Material(
          type: MaterialType.transparency,
          child: CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.escape): () {
                DatabaseViewState? localState = databaseView.currentState;
                if (localState == null) return;
                if (localState.wantReimport == true) {
                  localState.closeReimportView();
                }
                if (localState.selectedProduct != null) {
                  localState.onUnSelectProduct();
                }
                if (localState.scaffoldKey.currentState?.isEndDrawerOpen ==
                    true) {
                  localState.scaffoldKey.currentState?.closeEndDrawer();
                  localState.searchFocusNode.requestFocus();
                }
              },
              const SingleActivator(LogicalKeyboardKey.f11): () async {
                WindowManager instance = WindowManager.instance;
                fullScreen = !await instance.isFullScreen();
                if (!fullScreen) {
                  await WindowManager.instance.setFullScreen(false);
                  setState(() {});
                  return;
                } else {
                  await WindowManager.instance.setFullScreen(true);
                  setState(() {});
                }
              },
              const SingleActivator(LogicalKeyboardKey.enter): () {
                DatabaseViewState? state = databaseView.currentState;
                if (state == null) return;
                if (state.selectedProduct != null) {
                  state.overlayKey.currentState?.onValidate();
                  return;
                }
                List<Product>? products =
                    state.dataTableKey.currentState?.filteredProduct;
                if (products?.length == 1) {
                  if (state.hoverProduct == null) {
                    state.overlayKey.currentState?.mouseY =
                        MediaQuery.of(context).size.height * 0.5 + 100;
                    state.overlayKey.currentState?.mouseX =
                        MediaQuery.of(context).size.width * 0.5 - 200;
                  }
                  state.onSelectProduct(products!.first);
                }
              },
            },
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/background.png'),
                      fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Column(
                  children: [
                    WindowsBar(showButton: !fullScreen),
                    Expanded(child: DatabaseView(key: databaseView)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
