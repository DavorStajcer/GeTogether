/* //@dart=2.6
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_together_app/core/error/failure.dart';
import 'package:get_together_app/core/usecases/usecase.dart';
import 'package:get_together_app/features/chats_overview/domain/usecases/get_all_user_event_ids.dart';
import 'package:get_together_app/features/chats_overview/presentation/bloc/chats_overivew/chats_overview_cubit.dart';
import 'package:mockito/mockito.dart';

class GetAllUserEventsMock extends Mock implements GetAllUserEventIds {}

void main() {
  GetAllUserEventsMock getAllUserEventsMock;
  ChatsOverviewCubit chatsOverviewCubit;

  setUp(() {
    getAllUserEventsMock = GetAllUserEventsMock();
    chatsOverviewCubit = ChatsOverviewCubit(getAllUserEventsMock);
  });

  test("inital state should be ", () {
    expect(chatsOverviewCubit.state, ChatsOverviewLoading());
  });

  group("no errors", () {
    setUp(() {
      when(getAllUserEventsMock.call(NoParameters()))
          .thenAnswer((realInvocation) async => Right(["event", "otherEvent"]));
    });

    blocTest(
      "shoudl emit loaded state with list of events from repo",
      build: () => chatsOverviewCubit,
      act: (cubit) => (cubit as ChatsOverviewCubit).getAllEvents(),
      expect: () => [
        ChatsOverviewLoaded(["event", "otherEvent"]),
      ],
      verify: (cubit) => verify(
        getAllUserEventsMock.call(NoParameters()),
      ),
    );
  });

  group("errors", () {
    blocTest(
      "shoudl emit server failure when usecase emits it",
      build: () {
        when(getAllUserEventsMock.call(NoParameters())).thenAnswer(
            (realInvocation) async =>
                Left(ServerFailure(message: "someMessage")));
        return chatsOverviewCubit;
      },
      act: (cubit) => (cubit as ChatsOverviewCubit).getAllEvents(),
      expect: () => [
        ChatsOverviewServerFailure("someMessage"),
      ],
      verify: (cubit) => verify(
        getAllUserEventsMock.call(NoParameters()),
      ),
    );
    blocTest(
      "shoudl emit network failure when usecase emits it",
      build: () {
        when(getAllUserEventsMock.call(NoParameters())).thenAnswer(
            (realInvocation) async =>
                Left(NetworkFailure(message: "someMessage")));
        return chatsOverviewCubit;
      },
      act: (cubit) => (cubit as ChatsOverviewCubit).getAllEvents(),
      expect: () => [
        ChatsOverviewNetworkFailure("someMessage"),
      ],
      verify: (cubit) => verify(
        getAllUserEventsMock.call(NoParameters()),
      ),
    );
  });
}
 */