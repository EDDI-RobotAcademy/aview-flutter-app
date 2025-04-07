import 'package:iosjobstick/common_ui/page_button.dart';
import 'package:flutter/cupertino.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentPage > 1)
              PageButton(
                assetPath: 'images/btn_login_google.png',
                page: currentPage - 1,
                isCurrentPage: false,
                onTap: () => onPageChanged(currentPage - 1),
              ),
            ...List.generate(totalPages, (index) {
              int pageNum = index + 1;
              return PageButton(
                assetPath: pageNum == currentPage
                  ? 'images/btn_login_google.png'
                  : 'images/logo1.png',
                page: pageNum,
                isCurrentPage: pageNum == currentPage,
                onTap: () => onPageChanged(pageNum),
              );
            }),
            if (currentPage < totalPages)
              PageButton(
                assetPath: 'images/images/btn_login_google.png',
                page: currentPage + 1,
                isCurrentPage: false,
                onTap: () => onPageChanged(currentPage + 1),
              )
          ],
        )
    );
  }
}