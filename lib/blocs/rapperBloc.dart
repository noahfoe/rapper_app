import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapper_app/models/rapperModel.dart';
import 'package:rapper_app/repos/rapperRepo.dart';

class RapperEvent extends Equatable {
  @override
  List<String> get props => [];
}

class FetchRappers extends RapperEvent {}

class ResetRappers extends RapperEvent {}

class SelectRapper extends RapperEvent {
  final _rapperName;
  final _rapperDesc;
  SelectRapper(this._rapperName, this._rapperDesc);

  @override
  List<String> get props => [_rapperName, _rapperDesc];
}

class RapperState extends Equatable {
  @override
  List<Artist> get props => [];
}

// Display Error page - Error state (when API returns error)
class RapperIsNotLoaded extends RapperState {}

// Display ListView page loading animation - Initial state
class RapperIsLoading extends RapperState {}

// Display ListView page data - 2nd state (when ListView is shown)
class RapperIsLoaded extends RapperState {
  final _rappers;
  RapperIsLoaded(this._rappers);

  RapperModel get getRappers => _rappers;

  @override
  List<Artist> get props => [_rappers];
}

// Display DescView page - 3rd state (when user clicks on a rapper)
class RapperIsSelected extends RapperState {
  final _rapper;
  RapperIsSelected(this._rapper);

  @override
  // Error: type 'List<String>' is not a subtype of 'Artist'
  List<Artist> get props => [_rapper];
}

class RapperBloc extends Bloc<RapperEvent, RapperState> {
  RapperRepo _rapperRepo;

  RapperBloc(
    this._rapperRepo,
  ) : super(RapperIsLoading());

  @override
  Stream<RapperState> mapEventToState(RapperEvent event) async* {
    if (event is FetchRappers) {
      yield RapperIsLoading();
      try {
        RapperModel rappers = await _rapperRepo.fetchData();
        yield RapperIsLoaded(rappers);
      } catch (e) {
        yield RapperIsNotLoaded();
      }
    } else if (event is SelectRapper) {
      yield RapperIsSelected(event.props);
    }
    // else if (event is ResetRappers) {
    //   yield rapperIsLoaded(rappers);
    // }
  }
}
