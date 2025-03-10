import 'package:jobstick/board/board_module.dart';
import 'package:jobstick/common_ui/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/error_message.dart';
import '../../../common_ui/loading_indicator.dart';
import '../providers/board_list_provider.dart';
import 'component/page_content.dart';

class BoardListPage extends StatefulWidget {
  @override
  _BoardListPageState createState() => _BoardListPageState();
}

class _BoardListPageState extends State<BoardListPage> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    // 실제 데이터가 전부 준비 된 이후 화면 출력하도록 만듬
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boardListProvider =
      Provider.of<BoardListProvider>(context, listen: false);

      boardListProvider.listBoard(1, 6);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    final boardListProvider =
    Provider.of<BoardListProvider>(context, listen: false);

    boardListProvider.listBoard(page, 6);
  }

  @override
  Widget build(BuildContext context) {
    // AppBar 기본 높이
    final double appBarHeight = kToolbarHeight;
    // 상태 표시줄
    final double statusBarHeight =
        MediaQuery.of(context).padding.top;
    // 간격 계산 시 활용
    final double contentTopPadding = appBarHeight;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            body: Container(),
            title: '게시판',
          ),
        ),
        body: SafeArea(
            child: Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: contentTopPadding),
                    child: Consumer<BoardListProvider>(
                        builder: (context, boardListProvider, child) {
                          if (boardListProvider.isLoading &&
                              boardListProvider.boardList.isEmpty) {
                            // 아직 준비 중일 때
                            return LoadingIndicator();
                          }

                          if (boardListProvider.message.isNotEmpty) {
                            return ErrorMessage(
                                message: boardListProvider.message
                            );
                          }

                          return PageContent(
                            boardListProvider: boardListProvider,
                            onPageChanged: onPageChanged,
                          );
                        }
                    )
                ),
                Positioned(
                    top: statusBarHeight,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoardModule.provideBoardCreatePage(),
                            )
                        ).then((_) {
                          final boardListProvider = Provider.of<BoardListProvider>(
                              context, listen: false
                          );

                          boardListProvider.listBoard(1, 6);
                        });
                      },
                      child: Icon(Icons.add),
                      tooltip: '게시물 생성',
                    )
                ),
              ],
            )
        )
    );
  }

}