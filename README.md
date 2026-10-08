# flutter_easy_upi_payment

A production-ready Flutter package for initiating **UPI payments on Android** using installed UPI applications such as Google Pay, PhonePe, Paytm, BHIM, and Amazon Pay.

The package provides UPI URI generation, payment validation, preferred UPI app selection, native Android payment launching, payment response parsing, and customizable payment UI components.

<p align="center">
  <img src="example/assets/demo_upi.gif" width="200" alt="flutter_easy_upi_payment demo">
</p>

## Features

* 🚀 Launch UPI payments directly from Flutter.
* 💳 Support for major UPI applications.
* 📱 Google Pay support.
* 📱 PhonePe support.
* 📱 Paytm support.
* 📱 BHIM support.
* 📱 Amazon Pay support.
* 🔗 Custom UPI application support.
* ✅ UPI ID validation.
* 💰 Payment amount validation.
* 🧾 Transaction ID support.
* 📝 Transaction note support.
* 💱 Currency support.
* 📊 Structured payment response.
* 🔍 Payment status detection.
* 🎨 Customizable UPI payment button.
* 💳 Ready-to-use UPI payment card.
* ⚡ Native Android MethodChannel integration.
* 🛡️ Prevents multiple payments from being started simultaneously.
* 🧹 Clean and lightweight API.

## Platform Support

| Platform | Support         |
| -------- | --------------- |
| Android  | ✅ Supported     |
| iOS      | ❌ Not supported |
| Web      | ❌ Not supported |
| Windows  | ❌ Not supported |
| macOS    | ❌ Not supported |
| Linux    | ❌ Not supported |

> This package currently uses Android native UPI intents and is designed for Android applications.

## Requirements

* Flutter `>= 3.41.0`
* Dart `>= 3.11.5`
* Android SDK compatible with your Flutter version
* Android device with a supported UPI application installed

## Installation

Add the package to your Flutter project:

```yaml
dependencies:
  flutter_easy_upi_payment:
    path: ../flutter_easy_upi_payment
```

For a published package, use:

```yaml
dependencies:
  flutter_easy_upi_payment: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Basic Usage

Import the package:

```dart
import 'package:flutter_easy_upi_payment/flutter_easy_upi_payment.dart';
```

Create a payment configuration:

```dart
final config = UpiPaymentConfig(
  payeeVpa: 'merchant@upi',
  payeeName: 'Test Merchant',
  amount: 100,
  transactionId: 'TXN123456',
  transactionNote: 'Order Payment',
);
```

Launch the payment:

```dart
final response = await UpiPaymentLauncher.launch(config);

print(response.status);
print(response.message);
```

## Using UpiPaymentButton

The package includes a ready-to-use payment button:

```dart
UpiPaymentButton(
  config: UpiPaymentConfig(
    payeeVpa: 'merchant@upi',
    payeeName: 'Test Merchant',
    amount: 100,
    transactionId: 'TXN123456',
    transactionNote: 'Order Payment',
  ),
  label: 'Pay with UPI',
  onResult: (response) {
    if (response.isSuccess) {
      print('Payment successful');
    } else {
      print(response.message);
    }
  },
)
```

## Custom Payment Button

You can customize the button appearance:

```dart
UpiPaymentButton(
  config: config,
  label: 'Pay ₹100',
  icon: const Icon(Icons.payment_rounded),
  height: 56,
  borderRadius: 16,
  backgroundColor: Colors.deepPurple,
  foregroundColor: Colors.white,
  onResult: (response) {
    print(response.message);
  },
)
```

## Using UpiPaymentCard

Display payment information using the built-in card:

```dart
UpiPaymentCard(
  config: UpiPaymentConfig(
    payeeVpa: 'merchant@upi',
    payeeName: 'Test Merchant',
    amount: 100,
    transactionId: 'TXN123456',
    transactionNote: 'Order Payment',
  ),
)
```

You can also handle card taps:

```dart
UpiPaymentCard(
  config: config,
  onTap: () {
    print('Payment card tapped');
  },
)
```

## UpiPaymentConfig

`UpiPaymentConfig` contains all information required to initiate a UPI payment.

```dart
const UpiPaymentConfig({
  required String payeeVpa,
  required String payeeName,
  required double amount,
  required String transactionId,
  String transactionNote = 'UPI Payment',
  String currency = 'INR',
  UpiApp? preferredApp,
});
```

### Properties

| Property          | Type      | Required | Description                     |
| ----------------- | --------- | -------- | ------------------------------- |
| `payeeVpa`        | `String`  | Yes      | Merchant or receiver UPI ID     |
| `payeeName`       | `String`  | Yes      | Receiver display name           |
| `amount`          | `double`  | Yes      | Payment amount                  |
| `transactionId`   | `String`  | Yes      | Unique transaction reference    |
| `transactionNote` | `String`  | No       | Payment description             |
| `currency`        | `String`  | No       | Payment currency, default `INR` |
| `preferredApp`    | `UpiApp?` | No       | Specific UPI application        |

## Supported UPI Apps

The `UpiApp` enum provides predefined applications:

```dart
enum UpiApp {
  googlePay,
  phonePe,
  paytm,
  bhim,
  amazonPay,
  other,
}
```

### Google Pay

```dart
preferredApp: UpiApp.googlePay,
```

### PhonePe

```dart
preferredApp: UpiApp.phonePe,
```

### Paytm

```dart
preferredApp: UpiApp.paytm,
```

### BHIM

```dart
preferredApp: UpiApp.bhim,
```

### Amazon Pay

```dart
preferredApp: UpiApp.amazonPay,
```

### Any Compatible UPI App

```dart
preferredApp: UpiApp.other,
```

When no preferred application is specified, Android can choose a compatible UPI application.

## Payment Response

Every payment request returns a `UpiPaymentResponse`.

```dart
final response = await UpiPaymentLauncher.launch(config);
```

### Payment Status

```dart
enum UpiPaymentStatus {
  success,
  submitted,
  failed,
  cancelled,
  unknown,
}
```

### Checking Payment Status

```dart
if (response.isSuccess) {
  print('Payment successful');
}

if (response.isFailed) {
  print('Payment failed');
}

if (response.isCancelled) {
  print('Payment cancelled');
}
```

### Response Properties

| Property            | Type               | Description                   |
| ------------------- | ------------------ | ----------------------------- |
| `status`            | `UpiPaymentStatus` | Current payment status        |
| `transactionId`     | `String?`          | Transaction reference         |
| `responseCode`      | `String?`          | UPI response code             |
| `approvalReference` | `String?`          | Approval reference number     |
| `rawResponse`       | `String?`          | Raw UPI response              |
| `message`           | `String`           | Human-readable status message |

## UPI URI Generation

The package can generate a standard UPI payment URI:

```dart
final uri = UpiPaymentUtils.buildUpiUri(config);

print(uri);
```

Example:

```text
upi://pay?pa=merchant%40upi&pn=Test%20Merchant&am=100.00&tr=TXN123456&tn=Order%20Payment&cu=INR
```

## Validation

### Validate UPI ID

```dart
final valid = UpiPaymentUtils.isValidVpa('merchant@upi');

print(valid);
```

### Validate Amount

```dart
final valid = UpiPaymentUtils.isValidAmount(100);

print(valid);
```

The package rejects:

* Zero amount
* Negative amount
* Non-finite amount

## Copy Configuration

`UpiPaymentConfig` supports `copyWith`:

```dart
final updatedConfig = config.copyWith(
  amount: 250,
  transactionNote: 'Updated Payment',
);
```

## Android Configuration

The package uses Android native UPI intents internally.

Your Android application should support UPI intent queries. In the example application, the manifest contains:

```xml
<queries>
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="upi" />
    </intent>
</queries>
```

This allows Android to discover applications capable of handling the `upi://` scheme.

## Example Application

The package includes a complete example application.

Run the example:

```bash
cd example
flutter pub get
flutter run
```

The example demonstrates:

* Payment configuration
* Payee information
* Payment amount
* Transaction ID
* Transaction note
* Preferred UPI application
* Payment button
* Payment response
* Success/failure/cancellation handling

## Demo

<p align="center">
  <img src="example/assets/demo.gif" width="200" alt="UPI payment demo">
</p>

## Project Structure

```text
flutter_easy_upi_payment/
│
├── android/
│   └── src/
│       └── main/
│           └── kotlin/
│               └── com/
│                   └── sufiyan/
│                       └── flutter_easy_upi_payment/
│                           └── FlutterEasyUpiPaymentPlugin.kt
│
├── example/
│   ├── assets/
│   │   └── demo.gif
│   ├── lib/
│   │   └── main.dart
│   ├── test/
│   │   └── widget_test.dart
│   └── pubspec.yaml
│
├── lib/
│   ├── flutter_easy_upi_payment.dart
│   └── src/
│       ├── models/
│       │   ├── upi_app.dart
│       │   ├── upi_payment_config.dart
│       │   └── upi_payment_response.dart
│       │
│       ├── utils/
│       │   ├── upi_payment_launcher.dart
│       │   └── upi_payment_utils.dart
│       │
│       └── widgets/
│           ├── upi_payment_button.dart
│           └── upi_payment_card.dart
│
├── test/
│   └── flutter_easy_upi_payment_test.dart
│
├── README.md
└── pubspec.yaml
```

## API Overview

### `UpiPaymentConfig`

Payment configuration model.

```dart
UpiPaymentConfig(...)
```

### `UpiPaymentLauncher`

Starts a native Android UPI payment.

```dart
UpiPaymentLauncher.launch(config)
```

### `UpiPaymentUtils`

Utility methods for UPI URI generation and validation.

```dart
UpiPaymentUtils.buildUpiUri(config);

UpiPaymentUtils.isValidVpa(vpa);

UpiPaymentUtils.isValidAmount(amount);
```

### `UpiPaymentButton`

Ready-to-use customizable payment button.

```dart
UpiPaymentButton(...)
```

### `UpiPaymentCard`

Payment information card.

```dart
UpiPaymentCard(...)
```

### `UpiPaymentResponse`

Structured payment result.

```dart
UpiPaymentResponse(...)
```

## Error Handling

The package handles common payment launch errors such as:

* Invalid UPI ID
* Invalid amount
* No Android activity available
* UPI application not installed
* Selected UPI application not installed
* Another payment already in progress
* Unable to launch UPI payment
* Unknown payment response

Example:

```dart
final response = await UpiPaymentLauncher.launch(config);

switch (response.status) {
  case UpiPaymentStatus.success:
    print('Payment successful');
    break;

  case UpiPaymentStatus.submitted:
    print('Payment submitted');
    break;

  case UpiPaymentStatus.failed:
    print('Payment failed');
    break;

  case UpiPaymentStatus.cancelled:
    print('Payment cancelled');
    break;

  case UpiPaymentStatus.unknown:
    print('Unknown payment status');
    break;
}
```

## Testing

Run package tests from the root directory:

```bash
flutter test
```

Analyze the package:

```bash
flutter analyze
```

Analyze the example:

```bash
cd example
flutter analyze
```

Run example tests:

```bash
flutter test
```

## Development

Clone the repository:

```bash
git clone https://github.com/sufiyanshaikh-1304/flutter_easy_upi_payment.git
```

Enter the project:

```bash
cd flutter_easy_upi_payment
```

Install dependencies:

```bash
flutter pub get
```

Run tests:

```bash
flutter test
```

Run analyzer:

```bash
flutter analyze
```

Run the example application:

```bash
cd example
flutter run
```

## Important Payment Note

UPI applications control the final payment flow and payment result.

This package initiates the UPI payment request and parses the response returned by the UPI application. For production payment verification, applications should not rely only on the client-side response.

For real payment processing, always verify transactions using your payment provider or backend system where applicable.

## Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Run `flutter analyze`.
5. Run `flutter test`.
6. Test the example application on a real Android device.
7. Commit your changes.
8. Open a pull request.

Please keep contributions focused, clean, and compatible with the existing public API.

## Issues

If you find a bug or have a feature request, please open an issue in the repository.

## License

This project is licensed under the MIT License.

Copyright © 2026 Excelsior Technologies.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Author

**Sufiyan Shaikh**

Flutter Developer Intern
**Excelsior Technologies**

Built with Flutter and Dart.
