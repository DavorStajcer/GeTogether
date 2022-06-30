import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_together_app/features/single_event_overview/domain/usecase/check_is_current_user_event_admin.dart';

part 'single_event_screen_state.dart';

class SingleEventScreenCubit extends Cubit<SingleEventScreenState> {
  final CheckIsCurrentUserEventAdmin checkIsCurrentUserEventAdmin;

  SingleEventScreenCubit({required this.checkIsCurrentUserEventAdmin})
      : super(SingleEventScreenLoading());

  void checkIsAdminOfEventCurrentUser(String adminId) async {
    final response = await checkIsCurrentUserEventAdmin(adminId);
    response.fold(
      (failure) => emit(SingleEventScreenFailure(failure.message)),
      (isAdmin) => emit(SingleEventScreenLoaded(isAdmin)),
    );
  }
}
