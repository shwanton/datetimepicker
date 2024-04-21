/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <React/RCTConvert.h>
#import <React/RCTViewManager.h>

#if !TARGET_OS_OSX
@interface RCTConvert (UIDatePicker)

+ (UIDatePickerMode)UIDatePickerMode:(id)json;
#else
@interface RCTConvert (NSDatePicker)

+ (NSDatePickerMode)NSDatePickerMode:(id)json;
+ (NSDatePickerStyle)NSDatePickerStyle:(id)json;
#endif // !TARGET_OS_OSX

@end

@interface RNDateTimePickerManager : RCTViewManager

@end
