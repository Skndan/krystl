class UpiPayment {
  String? payeeAddress;
  String? payeeName;
  String? transactionNote;
  String? transactionReference;
  String? transactionId;
  String currency;
  String? amount;
  String? merchantCode;
  String? mode;
  String? purpose;

  /// Created by Balaji Malathi on 1/28/2025 at 18:07.
  ///
  UpiPayment({
    this.payeeAddress,
    this.payeeName,
    this.transactionNote,
    this.transactionReference,
    this.transactionId,
    this.currency = "INR",
    this.amount,
    this.merchantCode,
    this.mode,
    this.purpose,
  });

  /// Factory constructor to parse a UPI payment string
  factory UpiPayment.fromUri(String uri) {
    if (!uri.startsWith('upi://pay?')) {
      throw const FormatException('Invalid UPI URI');
    }

    final uriParts = Uri.parse(uri);
    final queryParams = uriParts.queryParameters;

    return UpiPayment(
      payeeAddress: queryParams['pa'],
      payeeName: queryParams['pn'],
      transactionNote: queryParams['tn'],
      transactionId: queryParams['tid'],
      transactionReference: queryParams['tr'],
      currency: queryParams['cu'] ?? "INR",
      amount: queryParams['am'],
      merchantCode: queryParams['mc'],
      mode: queryParams['mode'],
      purpose: queryParams['purpose'],
    );
  }

  /// Convert the object back to a UPI URI string
  @override
  String toString() {
    final params = {
      if (payeeAddress != null) 'pa': payeeAddress,
      if (payeeName != null) 'pn': payeeName,
      if (transactionNote != null) 'tn': transactionNote,
      if (transactionId != null) 'tid': transactionId,
      if (transactionReference != null) 'tr': transactionReference,
      'cu': currency,
      if (amount != null) 'am': amount,
      if (merchantCode != null) 'mc': merchantCode,
      if (mode != null) 'mode': mode,
      if (purpose != null) 'purpose': purpose,
    };

    final query = Uri(queryParameters: params).query;
    return 'upi://pay?$query';
  }
}
