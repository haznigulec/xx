import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:piapiri_v2/app/license/bloc/license_event.dart';
import 'package:piapiri_v2/app/license/bloc/license_state.dart';
import 'package:piapiri_v2/app/license/repository/license_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/license_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class LicenseBloc extends PBloc<LicenseState> {
  final LicensesRepository _licensesRepository;

  LicenseBloc({
    required LicensesRepository licensesRepository,
  })  : _licensesRepository = licensesRepository,
        super(initialState: const LicenseState()) {
    on<GetLicensesEvent>(_onGetLicenses);
    on<RequestLicenseEvent>(_onRequestLicence);
    on<CancelLicenseEvent>(_onCancelLicence);
  }

  FutureOr<void> _onGetLicenses(
    GetLicensesEvent event,
    Emitter<LicenseState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _licensesRepository.getLicenses();

    if (response.success) {
      List<LicenseModel> licenseList =
          response.data['licences'].map<LicenseModel>((e) => LicenseModel.fromJson(e)).toList();
      bool isDepthEnabled = false;
      bool isDepthExtendedEnabled = false;
      bool isBookletEnabled = false;
      int totalStage = 0;
      bool isViopDepthEnabled = false;
      bool isViopDepthExtendedEnabled = false;
      int totalViopStage = 0;
      bool isBrokerageEnabled = false;
      bool isViopBrokerageEnabled = false;

      // VD1P => VD1+ (VİOP Düzey 1 Plus)
      // VD2 => VD2 (VİOP Düzey 2)
      // VD2P => VD2+ (VİOP Düzey 2 Plus)
      // PD1P => PD1+ (Pay Düzey 1 Plus)
      // PD2 => PD2 (Pay Düzey 2)
      // PD2P => PD2+ (Pay Düzey 2 Plus)
      // AKD => AKD (Aracı Kurum Dağılımı Gün Sonu)
      // AKDE => AKDE (Aracı Kurum Dağılımı ve Eşanlı Taraf Bilgisi)
      // VAKD => VAKD (VİOP Aracı Kurum Dağılımı Gün Sonu)
      List<LicenseModel> viopDepthLicences =
          licenseList.where((e) => ['VD2P', 'VD2', 'VD1P'].contains(e.code) && e.hasLicence).toList();
      if (viopDepthLicences.isNotEmpty) {
        isViopDepthEnabled = true;
        LicenseModel? highestViopLicense = viopDepthLicences.firstWhereOrNull((e) => e.code == 'VD2P') ??
            viopDepthLicences.firstWhereOrNull((e) => e.code == 'VD2') ??
            viopDepthLicences.firstWhereOrNull((e) => e.code == 'VD1P');

        if (highestViopLicense != null) {
          isViopDepthExtendedEnabled = highestViopLicense.code == 'VD2P';
          totalViopStage = highestViopLicense.code == 'VD2P'
              ? 25
              : highestViopLicense.code == 'VD2'
                  ? 10
                  : 1;
        } else {
          isViopDepthEnabled = false;
        }
      }
      List<LicenseModel> depthLicences =
          licenseList.where((e) => ['PD1P', 'PD2', 'PD2P'].contains(e.code) && e.hasLicence).toList();
      if (depthLicences.isNotEmpty) {
        isDepthEnabled = true;
        LicenseModel? highestLicense = depthLicences.firstWhereOrNull((e) => e.code == 'PD2P') ??
            depthLicences.firstWhereOrNull((e) => e.code == 'PD2') ??
            depthLicences.firstWhereOrNull((e) => e.code == 'PD1P');

        if (highestLicense != null) {
          isDepthExtendedEnabled = highestLicense.code == 'PD2P';
          isBookletEnabled = highestLicense.code == 'PD2P';
          totalStage = highestLicense.code == 'PD2P'
              ? 25
              : highestLicense.code == 'PD2'
                  ? 10
                  : 1;
        } else {
          isDepthEnabled = false;
        }
      }

      List<LicenseModel> brokerageLicences =
          licenseList.where((e) => ['AKD', 'AKDE'].contains(e.code) && e.hasLicence).toList();

      isBrokerageEnabled = brokerageLicences.isNotEmpty;

      isViopBrokerageEnabled = licenseList.firstWhereOrNull((e) => e.code == 'VAKD')?.hasLicence ?? false;

      emit(
        state.copyWith(
          type: PageState.success,
          licenseList: licenseList,
          isDepthEnabled: isDepthEnabled,
          isDepthExtendedEnabled: isDepthExtendedEnabled,
          isBookletEnabled: isBookletEnabled,
          totalStage: totalStage,
          isViopDepthEnabled: isViopDepthEnabled,
          isViopDepthExtendedEnabled: isViopDepthExtendedEnabled,
          totalViopStage: totalViopStage,
          isBrokerageEnabled: isBrokerageEnabled,
          isViopBrokerageEnabled: isViopBrokerageEnabled,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01LIC01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onRequestLicence(
    RequestLicenseEvent event,
    Emitter<LicenseState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _licensesRepository.requestLicense(
      licenceId: event.licenceId,
      requestType: event.requestType,
      startDateStr: event.startDate,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess?.call(response.success);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr('licence.request_error.${response.error?.message ?? ''}'),
            errorCode: '01LIC02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onCancelLicence(
    CancelLicenseEvent event,
    Emitter<LicenseState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _licensesRepository.requestLicense(
      licenceId: event.licenceId,
      requestType: event.requestType,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess?.call(response.success);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01LIC03',
          ),
        ),
      );
    }
  }
}
