import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('Easy UPI Payment example loads', (tester) async {
    await tester.pumpWidget(
      const EasyUpiPaymentExample(),
    );

    expect(
      find.text('Easy UPI Payment'),
      findsOneWidget,
    );

    expect(
      find.text('Make a secure payment'),
      findsOneWidget,
    );
  });
}