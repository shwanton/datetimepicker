/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RNDateTimePickerManager.h"
#import "RNDateTimePickerShadowView.h"

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "RNDateTimePicker.h"
#import <React/UIView+React.h>

#if !TARGET_OS_OSX
#ifndef __IPHONE_15_0
@interface UIColor (Xcode12)
+ (instancetype) tintColor;
@end
#endif // __IPHONE_15_0
#endif // !TARGET_OS_OSX

#if !TARGET_OS_OSX
@implementation RCTConvert (UIDatePicker)

RCT_ENUM_CONVERTER(UIDatePickerMode, (@{
  @"time": @(UIDatePickerModeTime),
  @"date": @(UIDatePickerModeDate),
  @"datetime": @(UIDatePickerModeDateAndTime),
  @"countdown": @(UIDatePickerModeCountDownTimer),
}), UIDatePickerModeTime, integerValue)
#else
@implementation RCTConvert (NSDatePicker)

RCT_ENUM_CONVERTER(NSDatePickerMode, (@{
  @"single": @(NSSingleDateMode),
  @"range": @(NSRangeDateMode)
}), NSSingleDateMode, unsignedIntegerValue)
RCT_ENUM_CONVERTER(NSDatePickerStyle, (@{
  @"textfield-stepper": @(NSTextFieldAndStepperDatePickerStyle),
  @"clock-calendar": @(NSClockAndCalendarDatePickerStyle),
  @"textfield": @(NSTextFieldDatePickerStyle)
}), NSTextFieldAndStepperDatePickerStyle, unsignedIntegerValue)
#endif // !TARGET_OS_OSX

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0

typedef UIDatePickerStyle RNCUIDatePickerStyle;

// using UIDatePickerStyle directly conflicts with RN implementation
RCT_ENUM_CONVERTER(RNCUIDatePickerStyle, (@{
    @"default": @(UIDatePickerStyleAutomatic),
    @"compact": @(UIDatePickerStyleCompact),
    @"spinner": @(UIDatePickerStyleWheels),
    @"inline": @(UIDatePickerStyleInline),
}), UIDatePickerStyleAutomatic, integerValue)


RCT_ENUM_CONVERTER(UIUserInterfaceStyle, (@{
    @"dark": @(UIUserInterfaceStyleDark),
    @"light": @(UIUserInterfaceStyleLight),
}), UIUserInterfaceStyleUnspecified, integerValue)

#endif
#pragma clang diagnostic pop
@end

@implementation RNDateTimePickerManager {
  RNDateTimePicker* _picker;
}

RCT_EXPORT_MODULE()

- (instancetype)init {
  if (self = [super init]) {
    _picker = [RNDateTimePicker new];
  }
  return self;
}

+ (BOOL)requiresMainQueueSetup {
  return true;
}

- (RCTPlatformView *)view
{
  return [RNDateTimePicker new];
}

- (RCTShadowView *)shadowView
{
  RNDateTimePickerShadowView* shadowView = [RNDateTimePickerShadowView new];
  shadowView.picker = _picker;
  return shadowView;
}

#if !TARGET_OS_OSX
+ (NSString*) datepickerStyleToString: (UIDatePickerStyle) style  API_AVAILABLE(ios(13.4)){
    // RCTConvert does not handle this.?
    switch (style) {
        case UIDatePickerStyleCompact:
            return @"compact";
        case UIDatePickerStyleWheels:
            return @"spinner";
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        case UIDatePickerStyleInline:
            return @"inline";
#endif
        default:
            [NSException raise:@"Unsupported style value" format:@"UIDatePickerStyle of %ld is unsupported", (long)style];
            return @"";
    }
}
#endif // !TARGET_OS_OSX

RCT_EXPORT_SHADOW_PROPERTY(date, NSDate)
RCT_EXPORT_SHADOW_PROPERTY(mode, UIDatePickerMode)
RCT_EXPORT_SHADOW_PROPERTY(locale, NSLocale)
RCT_EXPORT_SHADOW_PROPERTY(displayIOS, RNCUIDatePickerStyle)
RCT_EXPORT_SHADOW_PROPERTY(timeZoneName, NSString)

#if !TARGET_OS_OSX
RCT_EXPORT_VIEW_PROPERTY(date, NSDate)
RCT_EXPORT_VIEW_PROPERTY(locale, NSLocale)
RCT_EXPORT_VIEW_PROPERTY(minimumDate, NSDate)
RCT_EXPORT_VIEW_PROPERTY(maximumDate, NSDate)
RCT_EXPORT_VIEW_PROPERTY(minuteInterval, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(enabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPickerDismiss, RCTBubblingEventBlock)
RCT_REMAP_VIEW_PROPERTY(mode, datePickerMode, UIDatePickerMode)
RCT_REMAP_VIEW_PROPERTY(timeZoneOffsetInMinutes, timeZone, NSTimeZone)
#else
RCT_REMAP_VIEW_PROPERTY(date, dateValue, NSDate)
RCT_REMAP_VIEW_PROPERTY(minimumDate, minDate, NSDate)
RCT_REMAP_VIEW_PROPERTY(maximumDate, maxDate, NSDate)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
RCT_REMAP_VIEW_PROPERTY(timeZoneOffsetInMinutes, timeZone, NSTimeZone)
RCT_REMAP_VIEW_PROPERTY(pickerStyle, datePickerStyle, NSDatePickerStyle)
#endif // !TARGET_OS_OSX

#if !TARGET_OS_OSX
RCT_CUSTOM_VIEW_PROPERTY(themeVariant, UIUserInterfaceStyle, RNDateTimePicker) {
    if (@available(iOS 13.0, *)) {
        if (json) {
            UIUserInterfaceStyle propValue = [RCTConvert UIUserInterfaceStyle:json];
            view.overrideUserInterfaceStyle = propValue;
        } else {
            view.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
        }
    }
}

RCT_CUSTOM_VIEW_PROPERTY(textColor, UIColor, RNDateTimePicker)
{
  if (@available(iOS 14.0, *)) {
    if (view.datePickerStyle != UIDatePickerStyleWheels) {
      // prevents #247
      return;
    }
  }
  if (json) {
    [view setValue:[RCTConvert UIColor:json] forKey:@"textColor"];
    [view setValue:@(NO) forKey:@"highlightsToday"];
  } else {
    UIColor* defaultColor;
    if (@available(iOS 13.0, *)) {
        defaultColor = [UIColor labelColor];
    } else {
        defaultColor = [UIColor blackColor];
    }
    [view setValue:defaultColor forKey:@"textColor"];
    [view setValue:@(YES) forKey:@"highlightsToday"];
  }
}

RCT_CUSTOM_VIEW_PROPERTY(accentColor, UIColor, RNDateTimePicker)
{
    if (json) {
        [view setTintColor:[RCTConvert UIColor:json]];
    } else {
        if (@available(iOS 15.0, *)) {
            [view setTintColor:[UIColor tintColor]];
        } else {
            [view setTintColor:[UIColor systemBlueColor]];
        }
    }
}

// TODO vonovak setting preferredDatePickerStyle invalidates minuteinterval
RCT_CUSTOM_VIEW_PROPERTY(displayIOS, RNCUIDatePickerStyle, RNDateTimePicker)
{
    // officially since 13.4 (https://developer.apple.com/documentation/uikit/uidatepickerstyle?language=objc) but practically since 14
    if (@available(iOS 14.0, *)) {
        if (json) {
            UIDatePickerStyle propValue = [RCTConvert RNCUIDatePickerStyle:json];
            view.preferredDatePickerStyle = propValue;
        } else {
            view.preferredDatePickerStyle = UIDatePickerStyleAutomatic;
        }
    }
}

RCT_CUSTOM_VIEW_PROPERTY(timeZoneName, NSString, RNDateTimePicker)
{
    if (json) {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:json];
        if (timeZone == nil) {
            RCTLogWarn(@"'%@' does not exist in NSTimeZone.knownTimeZoneNames fallback to localTimeZone=%@", json, NSTimeZone.localTimeZone.name);
            view.timeZone = NSTimeZone.localTimeZone;
        } else {
            view.timeZone = timeZone;
        }
    } else {
        view.timeZone = NSTimeZone.localTimeZone;
    }
}
#endif // !TARGET_OS_OSX

@end
