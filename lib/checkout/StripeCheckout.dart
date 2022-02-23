import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/constants/stripe_const.dart';
import 'package:mared_social/screens/splitter/splitter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeCheckoutPage extends StatefulWidget {
  final String sessionId;
  StripeCheckoutPage({required this.sessionId});
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<StripeCheckoutPage> {
  WebViewController? _webViewController;
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: constantColors.darkColor,
        title: Text(
          "Promote Post",
        ),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (webViewController) =>
              _webViewController = webViewController,
          onPageFinished: (String url) {
            if (url == initialUrl) {
              _redirectToStripe(widget.sessionId);
            }
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains("success")) {
              Navigator.of(context).pop("success");
            } else if (request.url.startsWith('http://cancel.com')) {
              Navigator.of(context).pop("cancel");
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  String get initialUrl => 'https://marcinusx.github.io/test1/index.html';

  Future<void> _redirectToStripe(String sessionId) async {
    final redirectToCheckoutJs = '''
var stripe = Stripe(\'$apiKey\');
    
stripe.redirectToCheckout({
  sessionId: '$sessionId'
}).then(function (result) {
  result.error.message = 'Error'
});
''';

    try {
      await _webViewController!.evaluateJavascript(redirectToCheckoutJs);
    } on PlatformException catch (e) {
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
  }
}
