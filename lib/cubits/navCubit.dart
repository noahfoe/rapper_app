import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapper_app/models/rapperModel.dart';

class NavCubit extends Cubit<Rapper?> {
  NavCubit() : super(null);

  void showRapperDetails(Rapper rapper) => emit(rapper);
  void popToRappers() => emit(null);
}
