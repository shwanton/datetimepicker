#import <React/RCTShadowView.h>
#import <React/RCTLog.h>
#import "RNDateTimePicker.h"

@interface RNDateTimePickerShadowView : RCTShadowView

@property (nullable, nonatomic, strong) RNDateTimePicker *picker;
#if !TARGET_OS_OSX
@property (nonatomic) UIDatePickerMode mode;
#endif // !TARGET_OS_OSX
@property (nullable, nonatomic, strong) NSDate *date;
@property (nullable, nonatomic, strong) NSLocale *locale;
@property (nonatomic, assign) NSInteger timeZoneOffsetInMinutes;
@property (nullable, nonatomic, strong) NSString *timeZoneName;
#if !TARGET_OS_OSX
@property (nonatomic, assign) UIDatePickerStyle displayIOS API_AVAILABLE(ios(13.4));
#endif // !TARGET_OS_OSX

@end
