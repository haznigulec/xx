class IpoUtils {
  // void appendNewIpos(
  //   List<IpoModel> ipoList,
  //   int page,
  //   PagingController pagingController, [
  //   VoidCallback? onSuccess,
  //   bool canRequest = false,
  // ]) {
  //   final List<Widget> ipoList0 = _prepareIpos(
  //     ipoList,
  //     pagingController,
  //     onSuccess!,
  //     canRequest,
  //   );
  //   final isLastPage = ipoList0.length < ipoPaginationListLength;
  //   if (isLastPage) {
  //     pagingController.appendLastPage(ipoList0);
  //   } else {
  //     pagingController.appendPage(ipoList0, page + 1);
  //   }
  // }

  // List<Widget> _prepareIpos(
  //   List<IpoModel> ipoList,
  //   PagingController pagingController,
  //   VoidCallback onSuccess,
  //   bool canRequest,
  // ) {
  //   return ipoList
  //       .map(
  //         (ipos) => IpoCard(
  //           canRequest: canRequest,
  //           ipo: ipos,
  //           isDemanded: ipos.isDemanded,
  //           onSuccess: onSuccess,
  //         ),
  //       )
  //       .toList();
  // }
}
