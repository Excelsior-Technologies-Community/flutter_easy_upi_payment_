enum UpiApp {
  googlePay,
  phonePe,
  paytm,
  bhim,
  amazonPay,
  other,
}

extension UpiAppExtension on UpiApp {
  String get packageName {
    switch (this) {
      case UpiApp.googlePay:
        return 'com.google.android.apps.nbu.paisa.user';
      case UpiApp.phonePe:
        return 'com.phonepe.app';
      case UpiApp.paytm:
        return 'net.one97.paytm';
      case UpiApp.bhim:
        return 'in.org.npci.upiapp';
      case UpiApp.amazonPay:
        return 'in.amazon.mShop.android.shopping';
      case UpiApp.other:
        return '';
    }
  }

  String get displayName {
    switch (this) {
      case UpiApp.googlePay:
        return 'Google Pay';
      case UpiApp.phonePe:
        return 'PhonePe';
      case UpiApp.paytm:
        return 'Paytm';
      case UpiApp.bhim:
        return 'BHIM';
      case UpiApp.amazonPay:
        return 'Amazon Pay';
      case UpiApp.other:
        return 'Other UPI App';
    }
  }
}