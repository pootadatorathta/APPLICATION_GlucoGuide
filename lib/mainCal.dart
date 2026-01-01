class mainCal {
  double currentBloodSugar;
  double targetBloodSugar;
  double carbValue;

  mainCal(
    this.currentBloodSugar,
    this.targetBloodSugar,
    this.carbValue,
  );

  double calculateCorrectionDose(double insulinSensitivity) {
    // Result Dose from blood sugar
    if (insulinSensitivity <= 0) {
      throw ArgumentError('Insulin sensitivity must be greater than zero.');
    }
    double correctionDose =
        (currentBloodSugar - targetBloodSugar) / insulinSensitivity;
    return correctionDose.ceilToDouble(); // round up
  }

  double calculateCarbDose(double carbPerInsulin) {
    // Result Dose from carbs
    if (carbPerInsulin <= 0) {
      throw ArgumentError(
          'Carb per unit of insulin must be greater than zero.');
    }
    double carbDose = carbValue / carbPerInsulin;
    return carbDose.ceilToDouble(); // round up
  }

  double calculateTotalDose(double insulinSensitivity, double carbPerInsulin) {
    // Sum of the doses required
    double totalDose = calculateCorrectionDose(insulinSensitivity) +
        calculateCarbDose(carbPerInsulin);
    return totalDose.ceilToDouble(); // round up
  }
}
