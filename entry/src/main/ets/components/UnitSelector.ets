import { ResourceHelper } from '../resources/ResourceHelper';
import { unitLabels } from '../resources/UnitLabels';
import { Unit } from '../model/Units';
import { MeasurementUnit } from '../pages/viewmodels/UnitConverterViewModel';

@Component
export struct UnitSelector {
  caption: Resource = $r('app.string.from');
  @Prop units: Unit[] = [];
  @ObjectLink value: MeasurementUnit;
  onUnitChange?: () => void;

  private resManager?: ResourceHelper;

  aboutToAppear(): void {
    const context = this.getUIContext().getHostContext();
    if (context) {
      this.resManager = new ResourceHelper(context);
    }
  }

  getLabel(unit: Unit): string {
    return this.resManager?.getString(Object(unitLabels)[unit], unit) ?? unit;
  }

  getSelected(): number {
    if (this.value) {
      return this.units.indexOf(this.value.unit);
    }
    return -1;
  }

  build() {
    Column() {
      Text(this.caption)
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor(0x625A70)
        .width('100%')
        .margin({ bottom: 10 })
      Select(this.units.map<SelectOption>((unit) => ({ value: this.getLabel(unit) })))
        .value(this.getLabel(this.value?.unit))
        .selected(this.getSelected())
        .width('100%')
        .height(52)
        .font({ size: 18, weight: FontWeight.Medium })
        .fontColor(0x0F0026)
        .backgroundColor(0xF8F3FF)
        .borderRadius(16)
        .accessibilityDescription(this.caption)
        .onSelect((index: number) => {
          this.value.unit = this.units[index];
          this.onUnitChange?.();
        })
    }
    .width('100%')
    .margin({ bottom: 16 })
  }
}
