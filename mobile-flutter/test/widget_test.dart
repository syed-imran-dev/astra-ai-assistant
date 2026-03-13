
import 'package:axiom_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

// 1. Mock the PlatformWebViewController
class MockPlatformWebViewController extends PlatformWebViewController {
  MockPlatformWebViewController(PlatformWebViewControllerCreationParams params)
      : super(params);

  @override
  Future<void> runJavaScript(String javaScript) async {
    // Intercept JS calls, can be left empty for tests.
  }

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {
    // Intercept HTML loading, can be left empty for tests.
  }

  // 2. This is the crucial part to fix the error.
  // We use `noSuchMethod` to catch the call to the non-existent 'initWebTeXView' method.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #initWebTeXView) {
      // The package expects this to be an async method. We return a completed Future.
      return Future.value();
    }
    // Fallback to the default behavior for any other methods.
    return super.noSuchMethod(invocation);
  }
}

// 3. Mock the PlatformWebViewWidget
class MockPlatformWebViewWidget extends PlatformWebViewWidget {
  MockPlatformWebViewWidget(PlatformWebViewWidgetCreationParams params)
      : super(params);

  @override
  Widget build(BuildContext context) {
    // A simple placeholder for the webview in our widget test.
    return Container(child: const Text('Mock WebView'));
  }
}

// 4. Mock the WebViewPlatform itself
class MockWebViewPlatform extends Fake implements WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    // Return our custom mocked controller.
    return MockPlatformWebViewController(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    // Return our custom mocked widget.
    return MockPlatformWebViewWidget(params);
  }
}

void main() {
  // 5. Set up the mock platform implementation before tests run.
  setUpAll(() {
    WebView.platform = MockWebViewPlatform();
  });

  testWidgets('Renders AxiomDashboard correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app bar title is rendered.
    expect(find.text('Axiom: Spatial Math'), findsOneWidget);

    // Verify that the initial welcome message is rendered.
    expect(find.text('3D VIEW LOADING...'), findsOneWidget);

    // We can also check if our mock widget is being rendered.
    expect(find.text('Mock WebView'), findsOneWidget);
  });
}
