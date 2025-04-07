/*
import '../../infrasturcture/repository/google_auth_repository.dart';
import 'agree_terms_usecase.dart';

class AgreeTermsUseCaseImpl implements AgreeTermsUseCase {
  final googleAuthRepository repository;  // ✅ googleAuthRepository → TermsRepository 변경

  AgreeTermsUseCaseImpl(this.repository);  // ✅ 생성자 수정

  @override
  Future<void> agree() async {
    await repository.saveAgreement();   // 사용자가 동의하면 동의 여부를 저장
  }

  @override
  Future<bool> checkAgreement() async {
    return await repository.loadAgreement();   // 사용자가 동의했는지 여부를 불러옴
  }
}
*/

