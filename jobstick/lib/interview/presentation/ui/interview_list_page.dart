import 'package:jobstick/common_ui/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_ui/error_message.dart';
import '../../../common_ui/loading_indicator.dart';
import '../../interview_module.dart';
import '../providers/interview_list_provider.dart';
import 'component/interview_page_content.dart';

class InterviewListPage extends StatefulWidget {
  @override
  _InterviewListPageState createState() => _InterviewListPageState();
}

class _InterviewListPageState extends State<InterviewListPage> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    // 데이터 로딩
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final interviewListProvider =
      Provider.of<InterviewListProvider>(context, listen: false);
      interviewListProvider.listInterview(1, 6); // Fixed method name
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    final interviewListProvider =
    Provider.of<InterviewListProvider>(context, listen: false);
    interviewListProvider.listInterview(page, 6); // Fixed method name
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = kToolbarHeight;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double contentTopPadding = appBarHeight;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          body: Container(),
          title: '인터뷰 목록',
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: contentTopPadding),
              child: Consumer<InterviewListProvider>(
                builder: (context, interviewListProvider, child) {
                  if (interviewListProvider.isLoading &&
                      interviewListProvider.interviewList.isEmpty) {
                    return LoadingIndicator();
                  }

                  if (interviewListProvider.message.isNotEmpty) {
                    return ErrorMessage(message: interviewListProvider.message);
                  }

                  return InterviewPageContent(
                    interviewListProvider: interviewListProvider,
                    onPageChanged: onPageChanged,
                  );
                },
              ),
            ),
            Positioned(
              top: statusBarHeight,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InterviewModule.provideInterviewStartPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 버튼 배경색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 둥근 모서리
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // 패딩 조정
                ),
                child: Text(
                  '모의 면접 시작',
                  style: TextStyle(
                    color: Colors.white, // 글자 색
                    fontSize: 16, // 글자 크기
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
