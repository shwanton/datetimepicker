/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * This is a controlled component version of RNDateTimePicker
 *
 * @format
 * @flow strict-local
 */
import RNDateTimePicker from './picker';
import {dateToMilliseconds, sharedPropsValidation} from './utils';
import { EVENT_TYPE_SET } from './constants';
import * as React from 'react';

import type {
  DateTimePickerEvent,
  NativeEventIOS,
  IOSNativeProps,
} from './types';

export default function Picker({
  value,
  maximumDate,
  minimumDate,
  minuteInterval,
  timeZoneOffsetInMinutes,
  onChange,
  pickerStyle = 'textfield-stepper',
  mode = 'range',
  ...other
}: IOSNativeProps): React.Node {
  sharedPropsValidation({value, timeZoneOffsetInMinutes});

  const _onChange = (event: NativeEventIOS) => {
    const timestamp = event.nativeEvent.timestamp;
    const unifiedEvent: DateTimePickerEvent = {
      ...event,
      type: EVENT_TYPE_SET,
    };

    const date = timestamp !== undefined ? new Date(timestamp) : undefined;

    onChange && onChange(unifiedEvent, date);
  };

  return (
    <RNDateTimePicker
      date={dateToMilliseconds(value)}
      maximumDate={dateToMilliseconds(maximumDate)}
      minimumDate={dateToMilliseconds(minimumDate)}
      mode={mode}
      pickerStyle={pickerStyle}
      timeZoneOffsetInMinutes={timeZoneOffsetInMinutes}
      onChange={_onChange}
      onStartShouldSetResponder={() => true}
      onResponderTerminationRequest={() => false}
    />
  );
}
