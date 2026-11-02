enum ServiceType {
  financialSupportFOKP,
  financialSupportFOAP,
  boneDensityRequestFOAP,
  medicalConsultationRequestFOAP,
  healthInformationRequestFOAP,
  healthEducationalProgramHEP,
  nutritionalConsultationHPD,
  sponsorshipRequestTBHF,
  fundraisingRequestTBHF,
  coBrandingMerchandiseRequest,
  eventHostingRequest,
  corporatePartnershipTBHF,
  familyConsultation,
  donationBoxPlacement,
  supportingCancerPatientRequest,
  other;

  factory ServiceType.fromApiKey(int serviceId) {
    switch (serviceId) {
      case 1:
        return ServiceType.financialSupportFOKP;
      case 2:
        return ServiceType.financialSupportFOAP;
      case 3:
        return ServiceType.boneDensityRequestFOAP;
      case 4:
        return ServiceType.medicalConsultationRequestFOAP;
      case 5:
        return ServiceType.healthInformationRequestFOAP;
      case 6:
        return ServiceType.healthEducationalProgramHEP;
      case 7:
        return ServiceType.nutritionalConsultationHPD;
      case 8:
        return ServiceType.familyConsultation;
      case 10:
        return ServiceType.corporatePartnershipTBHF;
      case 12:
        return ServiceType.sponsorshipRequestTBHF;
      case 14:
        return ServiceType.fundraisingRequestTBHF;
      case 9:
        return ServiceType.coBrandingMerchandiseRequest;
      case 11:
        return ServiceType.eventHostingRequest;
      case 13:
        return ServiceType.donationBoxPlacement;
      case 15:
        return ServiceType.supportingCancerPatientRequest;
      default:
        return ServiceType.other;
    }
  }
  int get toApiKey {
    switch (this) {
      case ServiceType.financialSupportFOKP:
        return 1;
      case ServiceType.financialSupportFOAP:
        return 2;
      case ServiceType.boneDensityRequestFOAP:
        return 3;
      case ServiceType.medicalConsultationRequestFOAP:
        return 4;
      case ServiceType.healthInformationRequestFOAP:
        return 5;
      case ServiceType.healthEducationalProgramHEP:
        return 6;
      case ServiceType.nutritionalConsultationHPD:
        return 7;
      case ServiceType.familyConsultation:
        return 8;
      case ServiceType.corporatePartnershipTBHF:
        return 10;
      case ServiceType.sponsorshipRequestTBHF:
        return 12;
      case ServiceType.fundraisingRequestTBHF:
        return 14;
      case ServiceType.coBrandingMerchandiseRequest:
        return 9;
      case ServiceType.eventHostingRequest:
        return 11;
      case ServiceType.donationBoxPlacement:
        return 13;
      case ServiceType.supportingCancerPatientRequest:
        return 15;
      case ServiceType.other:
        return -1;
    }
  }
}
