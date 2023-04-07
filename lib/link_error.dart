class LinkError {
  final LinkErrorType errorType;
  final String errorMessage;
  final String? errorDetails;

  LinkError({
    required this.errorType,
    required this.errorMessage,
    this.errorDetails,
  });
}

enum LinkErrorType {
  invalidLinkKey,
  invalidUserToken,
  invalidDdsConfig,
  invalidItems,
  invalidAccountId,
  callbackUndefined,
  cardIssuerUnavailable,
  expiredUserToken,
  ddsNotSupported,
  incompatibleDdsConfig,
  generic
}
