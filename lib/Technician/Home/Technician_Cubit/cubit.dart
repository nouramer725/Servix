import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servix/Settings/Contact%20Us.dart';
import 'package:servix/Settings/Privacy%20Policy.dart';
import 'package:servix/Settings/Terms%20&%20Conditions.dart';
import 'package:servix/Technician/Home/HomeTechnician.dart';
import 'package:servix/Technician/Home/Technician_Cubit/states.dart';

class TechnicianCubit extends Cubit<TechnicianStates> {

  TechnicianCubit() : super(TechnicianInitialState());
  static TechnicianCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    HomeTechnician(),
    TermsAndConditions(),
    PrivacyPolicy(),
    Contactus(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(TechnicianChangeBottomNavState());
  }
}