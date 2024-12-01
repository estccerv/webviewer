// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Definición del widget CustomWebViewWidget que extiende StatefulWidget
class CustomWebViewWidget extends StatefulWidget {
  // Constructor del widget
  const CustomWebViewWidget({
    super.key, // Clave única para el widget
    this.width, // Ancho del widget, opcional
    this.height, // Alto del widget, opcional
    required this.url, // URL requerida para el WebView
  });

  final double? width; // Ancho del widget, puede ser nulo
  final double? height; // Alto del widget, puede ser nulo
  final String url; // URL requerida para el WebView

  // Método para crear el estado del widget
  @override
  State<CustomWebViewWidget> createState() => _CustomWebViewWidgetState();
}

// Definición del estado del widget CustomWebViewWidget
class _CustomWebViewWidgetState extends State<CustomWebViewWidget> {
  WebViewXController? _controller; // Controlador del WebView, puede ser nulo
  bool _canGoBack =
      false; // Indicador de si se puede retroceder en el historial del WebView
  String? _currentUrl; // URL actual del WebView, puede ser nula

  // Método llamado cuando el widget se inserta en el árbol de widgets
  @override
  void initState() {
    super.initState();
    // Configura el modo de UI del sistema en modo inmersivo
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  // Método llamado cuando el widget se elimina del árbol de widgets
  @override
  void dispose() {
    // Restaura el modo de UI del sistema a modo edgeToEdge
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // Método para verificar si se puede retroceder en el historial del WebView
  Future<void> _checkBackNavigation() async {
    if (_controller != null) {
      bool canGoBack =
          await _controller!.canGoBack(); // Verifica si se puede retroceder
      setState(() {
        _canGoBack = canGoBack; // Actualiza el estado
      });
    }
  }

  // Método para construir la interfaz de usuario del widget
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Deshabilita la navegación hacia atrás por defecto
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (_controller != null) {
          bool canGoBack =
              await _controller!.canGoBack(); // Verifica si se puede retroceder
          if (canGoBack) {
            await _controller!.goBack(); // Retrocede en el historial
            await _checkBackNavigation(); // Verifica nuevamente si se puede retroceder
          } else {
            // Verifica si la URL actual es nula o vacía
            if (_currentUrl == null || _currentUrl!.isEmpty) {
              Navigator.of(context)
                  .pop(); // Cierra el WebView si no hay más páginas para retroceder
            } else {
              // Opcionalmente, muestra un mensaje al usuario
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No more pages to go back to.')),
              );
            }
          }
        }
      },
      child: WebViewX(
        width: widget.width ??
            MediaQuery.sizeOf(context).width, // Ancho del WebView
        height: widget.height ??
            MediaQuery.sizeOf(context).height, // Alto del WebView
        initialContent: widget.url, // Contenido inicial del WebView (URL)
        initialSourceType: SourceType.url, // Tipo de fuente inicial (URL)
        javascriptMode: JavascriptMode
            .unrestricted, // Modo de JavaScript (sin restricciones)
        mobileSpecificParams: MobileSpecificParams(
          gestureNavigationEnabled: true, // Habilita la navegación por gestos
          androidEnableHybridComposition:
              true, // Habilita la composición híbrida en Android
        ),
        onWebViewCreated: (controller) {
          _controller = controller; // Asigna el controlador del WebView
          _checkBackNavigation(); // Verifica inicialmente si se puede retroceder
        },
        onPageFinished: (url) async {
          setState(() {
            _currentUrl = url; // Actualiza la URL actual
          });
          await _checkBackNavigation(); // Verifica si se puede retroceder
        },
      ),
    );
  }
}

/*
class CustomWebViewWidget extends StatefulWidget {
  const CustomWebViewWidget({
    super.key,
    this.width,
    this.height,
    required this.url,
  });

  final double? width;
  final double? height;
  final String url;

  @override
  State<CustomWebViewWidget> createState() => _CustomWebViewWidgetState();
}

class _CustomWebViewWidgetState extends State<CustomWebViewWidget> {
  WebViewXController? _controller;
  bool _canGoBack = false;
  String? _currentUrl;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _checkBackNavigation() async {
    if (_controller != null) {
      bool canGoBack = await _controller!.canGoBack();
      setState(() {
        _canGoBack = canGoBack;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (_controller != null) {
          bool canGoBack = await _controller!.canGoBack();
          if (canGoBack) {
            await _controller!.goBack();
            await _checkBackNavigation();
          } else {
            // Check if the current URL is null or empty
            if (_currentUrl == null || _currentUrl!.isEmpty) {
              Navigator.of(context).pop();
            } else {
              // Optionally, show a message to the user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No more pages to go back to.')),
              );
            }
          }
        }
      },
      child: WebViewX(
        width: widget.width ?? MediaQuery.sizeOf(context).width,
        height: widget.height ?? MediaQuery.sizeOf(context).height,
        initialContent: widget.url,
        initialSourceType: SourceType.url,
        javascriptMode: JavascriptMode.unrestricted,
        mobileSpecificParams: MobileSpecificParams(
          gestureNavigationEnabled: true,
          androidEnableHybridComposition: true,
        ),
        onWebViewCreated: (controller) {
          _controller = controller;
          _checkBackNavigation(); // Check back navigation initially
        },
        onPageFinished: (url) async {
          setState(() {
            _currentUrl = url;
          });
          await _checkBackNavigation();
        },
      ),
    );
  }
}
*/

/*
class CustomWebViewWidget extends StatefulWidget {
  const CustomWebViewWidget({
    super.key,
    this.width,
    this.height,
    required this.url,
  });

  final double? width;
  final double? height;
  final String url;

  @override
  State<CustomWebViewWidget> createState() => _CustomWebViewWidgetState();
}

class _CustomWebViewWidgetState extends State<CustomWebViewWidget> {
  late WebViewXController? _controller;
  bool _canGoBack = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _checkBackNavigation() async {
    if (_controller != null) {
      bool canGoBack = await _controller!.canGoBack();
      setState(() {
        _canGoBack = canGoBack;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (_controller != null) {
          bool canGoBack = await _controller!.canGoBack();
          if (canGoBack) {
            await _controller!.goBack();
            await _checkBackNavigation();
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: WebViewX(
        width: widget.width ?? MediaQuery.sizeOf(context).width,
        height: widget.height ?? MediaQuery.sizeOf(context).height,
        initialContent: widget.url,
        initialSourceType: SourceType.url,
        javascriptMode: JavascriptMode.unrestricted,
        mobileSpecificParams: MobileSpecificParams(
          gestureNavigationEnabled: true,
          androidEnableHybridComposition: true,
        ),
        onWebViewCreated: (controller) {
          _controller = controller;
          _checkBackNavigation(); // Check back navigation initially
        },
        onPageFinished: (url) async {
          await _checkBackNavigation();
        },
      ),
    );
  }
}
*/

/*
class CustomNativeWebView extends StatefulWidget {
  const CustomNativeWebView({
    super.key,
    this.width,
    this.height,
    this.url,
  });

  final double? width;
  final double? height;
  final String? url;

  @override
  State<CustomNativeWebView> createState() => _CustomNativeWebViewState();
}

class _CustomNativeWebViewState extends State<CustomNativeWebView> {
  @override
  Widget build(BuildContext context) {
    return WebViewX(
      width: widget.width ?? MediaQuery.sizeOf(context).width,
      height: widget.height ?? MediaQuery.sizeOf(context).height,
      initialContent: widget.url ?? 'https://app.kubuncrm.com',
      initialSourceType: SourceType.url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
*/
