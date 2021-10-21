import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:rapper_app/models/rapperModel.dart';
import 'package:rapper_app/repos/rapperRepo.dart';

class RapperEvent extends Equatable {
  @override
  List<String> get props => [];
}

class FetchRappers extends RapperEvent {}

class SelectRapper extends RapperEvent {
  final _rapperName;
  final _rapperDesc;
  SelectRapper(this._rapperName, this._rapperDesc);

  @override
  List<String> get props => [_rapperName, _rapperDesc];
}

class RapperState extends Equatable {
  @override
  List<Rapper> get props => [];
}

// Display Error page - Error state (when API returns error)
class RapperIsNotLoaded extends RapperState {}

// Display ListView page loading animation - Initial state
class RapperIsLoading extends RapperState {}

// Display ListView page data - 2nd state (when ListView is shown)
class RapperIsLoaded extends RapperState {
  final _rappers;
  final _images;
  RapperIsLoaded(this._rappers, this._images);

  List<Rapper> get getRappers => _rappers;
  List<String> get getImages => _images;

  @override
  List<Rapper> get props => [_rappers];
}

// Display DescView page - 3rd state (when user clicks on a rapper)
class RapperIsSelected extends RapperState {
  final _rapperName;
  final _rapperDesc;
  RapperIsSelected(this._rapperName, this._rapperDesc);

  String get getRapperName => _rapperName;
  String get getRapperDesc => _rapperDesc;

  @override
  // Error: type 'List<String>' is not a subtype of 'Artist'
  List<Rapper> get props => [_rapperName, _rapperDesc];
}

class RapperBloc extends Bloc<RapperEvent, RapperState> {
  RapperRepo _rapperRepo;

  RapperBloc(
    this._rapperRepo,
  ) : super(RapperIsLoading());

  @override
  Stream<RapperState> mapEventToState(RapperEvent event) async* {
    List<String>? listOfImgStrings = [];
    if (event is FetchRappers) {
      yield RapperIsLoading();
      try {
        RapperModel _jsonData = await _rapperRepo.fetchData();
        final _rappers = _jsonData.artists;
        _rappers.forEach((artist) async {
          var response = await http.get(Uri.parse(artist.image));
          Directory docDir = await getApplicationDocumentsDirectory();
          File file = new File(join(docDir.path, '${artist.name}.jpeg'));
          file.writeAsBytesSync(response.bodyBytes);
          if (!listOfImgStrings.contains(file.path))
            listOfImgStrings.add(file.path);
        });
        // TODO: Not sure how to avoid this
        await Future.delayed(Duration(seconds: 1));
        listOfImgStrings.sort();
        print(listOfImgStrings);
        yield RapperIsLoaded(_rappers, listOfImgStrings);
      } catch (e) {
        yield RapperIsNotLoaded();
      }
    } else if (event is SelectRapper) {
      yield RapperIsSelected(event._rapperName, event._rapperDesc);
    }
  }
}
