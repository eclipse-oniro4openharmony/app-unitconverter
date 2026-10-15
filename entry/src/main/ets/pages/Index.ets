import { ResourceHelper } from '../resources/ResourceHelper';
import { measureLabels } from '../resources/MeasureLabels';
import { UnitSelector } from '../components/UnitSelector';
import { UnitConverterViewModel, ConversionError } from './viewmodels/UnitConverterViewModel';

@Entry
@Component
struct Index {
  @State unitConverter: UnitConverterViewModel = new UnitConverterViewModel();
  private resManager?: ResourceHelper;

  aboutToAppear(): void {
    const context = this.getUIContext().getHostContext();
    if (context) {
      this.resManager = new ResourceHelper(context);
    }
  }

  getMeasureLabel(measure: string): Resource {
    return $r(`app.string.measure_${measure}`);
  }

  getCurrentMeasureLabel(): string {
    const measure = this.unitConverter.getCurrentMeasure();
    return this.resManager?.getString(Object(measureLabels)[measure], measure) ?? measure;
  }

  onValueChange(value: string): void {
    this.unitConverter.convertValue(value);
  }

  build() {
    Scroll() {
      Column() {
        Text($r('app.string.EntryAbility_label'))
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(INK)
          .width('100%')
          .margin({ bottom: 28 })

        Column() {
          Text($r('app.string.measure'))
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(SECONDARY_INK)
            .width('100%')
            .margin({ bottom: 10 })
          Select(this.unitConverter.getMeasures()
            .map<SelectOption>((measure) => ({ value: this.getMeasureLabel(measure) })))
            .selected(this.unitConverter.getCurrentMeasureIndex())
            .value(this.getCurrentMeasureLabel())
            .width('100%')
            .height(52)
            .font({ size: 18, weight: FontWeight.Medium })
            .fontColor(INK)
            .backgroundColor(SURFACE)
            .borderRadius(16)
            .accessibilityDescription($r('app.string.measure'))
            .onSelect((index: number) => {
              this.unitConverter.setMeasure(index);
            })
        }
        .width('100%')
        .margin({ bottom: 24 })

        Column() {
          UnitSelector({
            caption: $r('app.string.from'),
            units: this.unitConverter.units,
            value: this.unitConverter.sourceUnit,
            onUnitChange: (): void => this.unitConverter.convert()
          })
          TextInput({ text: this.unitConverter.value, placeholder: $r('app.string.conversion_prompt') })
            .type(InputType.NUMBER_DECIMAL)
            .fontSize(28)
            .fontColor(INK)
            .textAlign(TextAlign.End)
            .placeholderColor(SECONDARY_INK)
            .placeholderFont({ size: 20 })
            .inputFilter(INPUT_REGEX_SIGNED_DECIMAL)
            .height(64)
            .padding({ left: 16, right: 16 })
            .backgroundColor(BACKGROUND)
            .borderRadius(16)
            .accessibilityDescription($r('app.string.input_value'))
            .onChange((value: string) => this.onValueChange(value))
          if (this.unitConverter.conversionError === ConversionError.InvalidValue) {
            Text($r('app.string.invalid_input_value'))
              .fontSize(14)
              .fontColor(ERROR)
              .width('100%')
              .margin({ top: 10 })
          }
        }
        .width('100%')
        .padding(20)
        .backgroundColor(SURFACE)
        .borderRadius(24)

        Button() {
          Image($r('app.media.up_down'))
            .width(26)
            .height(26)
        }
        .width(56)
        .height(56)
        .padding(0)
        .backgroundColor(ACCENT)
        .borderRadius(28)
        .accessibilityText($r('app.string.swap_units'))
        .margin({ top: 16, bottom: 16 })
        .onClick((): void => this.unitConverter.exchangeUnits())

        Column() {
          UnitSelector({
            caption: $r('app.string.to'),
            units: this.unitConverter.units,
            value: this.unitConverter.targetUnit,
            onUnitChange: (): void => this.unitConverter.convert()
          })
          Text(this.unitConverter.conversionResult === '' ? '—' : this.unitConverter.conversionResult)
            .fontSize(28)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.unitConverter.conversionResult === '' ? SECONDARY_INK : ACCENT)
            .textAlign(TextAlign.End)
            .width('100%')
            .constraintSize({ minHeight: 64 })
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            .backgroundColor(BACKGROUND)
            .borderRadius(16)
            .accessibilityDescription($r('app.string.converted_value'))
            .accessibilityLevel('yes')
        }
        .width('100%')
        .padding(20)
        .backgroundColor(SURFACE)
        .borderRadius(24)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ left: 20, right: 20, top: 24, bottom: 32 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(BACKGROUND)
  }
}

const INPUT_REGEX_SIGNED_DECIMAL = '^[0-9.-]*$';
const BACKGROUND = 0xF8F3FF;
const SURFACE = 0xFFFFFF;
const INK = 0x0F0026;
const SECONDARY_INK = 0x625A70;
const ACCENT = 0x6024B5;
const ERROR = 0xB4235A;
