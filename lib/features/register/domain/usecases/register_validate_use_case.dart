import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:app_health/core/failures.dart';
import 'package:app_health/core/usecase.dart';

class RegisterValidateUseCase extends BaseUseCase<bool, GlobalKey<FormState>> {
  RegisterValidateUseCase();

  @override
  FutureOr<Either<Failure, bool>> call(GlobalKey<FormState> params) async {
    if (params.currentState?.validate() ?? false) {
      params.currentState?.save();
      return const Right(true);
    } else {
      return Left(CacheFailure());
    }
  }
}
