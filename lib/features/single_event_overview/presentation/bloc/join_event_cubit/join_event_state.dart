part of 'join_event_cubit.dart';

abstract class JoinEventState extends Equatable {
  const JoinEventState();

  @override
  List<Object> get props => [];
}

class JoinEventLoading extends JoinEventState {}

class JoinEventFailure extends JoinEventState {
  final String message;
  JoinEventFailure(this.message);
}

class JoinEventNetworkFailure extends JoinEventFailure {
  JoinEventNetworkFailure(String message) : super(message);
}

class JoinEventServerFailure extends JoinEventFailure {
  JoinEventServerFailure(String message) : super(message);
}

class JoinEventFinished extends JoinEventState {
  final ButtonJoinUiData buttonData;
  JoinEventFinished({required this.buttonData});
  @override
  List<Object> get props => [buttonData];
}

abstract class ButtonJoinUiData extends Equatable {
  final Color buttonColor;
  final String text;
  final Color textColor;
  ButtonJoinUiData(this.buttonColor, this.text, this.textColor);

  @override
  List<Object?> get props => [buttonColor, text, textColor];
}

class ButtonJoinedUi extends ButtonJoinUiData {
  ButtonJoinedUi(BuildContext context)
      : super(Theme.of(context).primaryColor.withOpacity(0.6), "Leave event",
            Colors.white);
}

class ButtonRequestedUi extends ButtonJoinUiData {
  ButtonRequestedUi(BuildContext context)
      : super(
          Theme.of(context).primaryColor.withOpacity(0.2),
          "Request sent",
          Theme.of(context).primaryColor.withOpacity(0.6),
        );
}

class ButtonNotJoinedUi extends ButtonJoinUiData {
  ButtonNotJoinedUi(BuildContext context)
      : super(
          Colors.white,
          "Join event",
          Theme.of(context).primaryColor.withOpacity(0.6),
        );
}
