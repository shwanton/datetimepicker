// @flow strict-local
import type {ViewProps} from 'react-native/Libraries/Components/View/ViewPropTypes';
import type {ColorValue} from 'react-native/Libraries/StyleSheet/StyleSheet';
import type {HostComponent} from 'react-native';

import type {
  BubblingEventHandler,
  Double,
  Int32,
  WithDefault,
} from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

type DateTimePickerEvent = $ReadOnly<{|
  timestamp: Double,
  utcOffset: Int32,
|}>;

type DateTimePickerMode = 'date' | 'time' | 'datetime' | 'countdown' | 'single' | 'range';
type ThemeVariant = 'dark' | 'light' | 'unspecified'
type DisplayStyle = 'default' | 'spinner' | 'compact' | 'inline';
type PickerStyle = 'textfield-stepper' | 'clock-calendar' | 'textfield';

type NativeProps = $ReadOnly<{|
  ...ViewProps,
  onChange?: ?BubblingEventHandler<DateTimePickerEvent>,
  onPickerDismiss?: ?BubblingEventHandler<null>,
  maximumDate?: ?Double,
  minimumDate?: ?Double,
  date?: ?Double,
  locale?: ?string,
  minuteInterval?: ?Int32,
  mode?: WithDefault<DateTimePickerMode, 'date'>,
  timeZoneOffsetInMinutes?: ?Double,
  timeZoneName?: ?string,
  textColor?: ?ColorValue,
  accentColor?: ?ColorValue,
  themeVariant?: WithDefault<ThemeVariant, 'unspecified'>,
  displayIOS?: WithDefault<DisplayStyle, 'default'>,
  pickerStyleMacOSX?: WithDefault<PickerStyle, 'textfield-stepper'>,
  enabled?: WithDefault<boolean, true>,
|}>;

export default (codegenNativeComponent<NativeProps>('RNDateTimePicker', {
  excludedPlatforms: ['android'],
}): HostComponent<NativeProps>);
