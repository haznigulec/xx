/// Due to auto route upgrade change our routes have Route prefix
/// Since our previous analytics screen events does not include -route prefix, every screen event should use this
extension RoutePathShortener on String {
  String removeRoutePrefix() {
    return replaceAll('-route', '');
  }

  String addRouteSuffixIfNotExist() {
    if (!contains('-route')) {
      const pageSuffix = 'page';
      final indexOfPage = lastIndexOf(pageSuffix);
      if (indexOfPage != -1) {
        final modifiedRouteName = '${substring(0, indexOfPage + pageSuffix.length)}-route${substring(
          indexOfPage + pageSuffix.length,
        )}';
        return modifiedRouteName;
      } else {
        return this;
      }
    }
    return this;
  }
}
