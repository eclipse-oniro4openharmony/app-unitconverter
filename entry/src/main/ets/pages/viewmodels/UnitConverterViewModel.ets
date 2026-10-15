import { Unit } from '../../model/Units';
import { measures, measureFactories, MeasureFactory } from '../../feature/MeasureFactory'
import { formatConversion } from '../../feature/ConversionFormatter';

export enum ConversionError {
  None,
  InvalidValue
}

@Observed
export class MeasurementUnit {
  unit: Unit;

  constructor(unit: Unit) {
    this.unit = unit;
  }
}

@Observed
export class UnitConverterViewModel {
  private measureFactory?: MeasureFactory;
  private measureIndex: number = 0;
  units: Unit[] = [];
  sourceUnit: MeasurementUnit;
  targetUnit: MeasurementUnit;
  conversionResult: string = '';
  value: string = '';
  conversionError: ConversionError = ConversionError.None;

  constructor() {
    const initialUnits: Unit[] = measureFactories[measures[0]]().getUnits();
    this.sourceUnit = new MeasurementUnit(initialUnits[0]);
    this.targetUnit = new MeasurementUnit(initialUnits[1]);
    this.setMeasure(0);
  }

  getMeasures() {
    return measures;
  }

  getCurrentMeasure() {
    return measures[this.measureIndex];
  }

  getCurrentMeasureIndex() {
    return this.measureIndex;
  }

  setMeasure(index: number) {
    this.measureIndex = index;
    const m = measures[this.measureIndex];
    this.measureFactory = measureFactories[m]();
    this.units = this.measureFactory!.getUnits();
    this.sourceUnit = new MeasurementUnit(this.units[0]);
    this.targetUnit = new MeasurementUnit(this.units[1]);
    this.convert();
  }

  exchangeUnits() {
    const temp = this.sourceUnit;
    this.sourceUnit = this.targetUnit;
    this.targetUnit = temp;
    this.convert();
  }

  convertValue(value: string) {
    this.value = value;
    this.convert();
  }

  convert() {
    if (this.value === '' || this.value === '-' || this.value === '.' || this.value === '-.') {
      this.conversionResult = '';
      this.conversionError = ConversionError.None;
    } else {
      const v = Number(this.value);
      if (!SIGNED_DECIMAL_PATTERN.test(this.value) || !Number.isFinite(v)) {
        this.conversionResult = '';
        this.conversionError = ConversionError.InvalidValue;
      } else {
        const converted = this.measureFactory!.convert(this.sourceUnit.unit, this.targetUnit.unit, v);
        if (!Number.isFinite(converted)) {
          this.conversionResult = '';
          this.conversionError = ConversionError.InvalidValue;
        } else {
          this.conversionResult = formatConversion(converted);
          this.conversionError = ConversionError.None;
        }
      }
    }
  }
}

const SIGNED_DECIMAL_PATTERN = /^-?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)$/;
