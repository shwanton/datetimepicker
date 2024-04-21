/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if !TARGET_OS_OSX
#import <UIKit/UIKit.h>
#else
#import <React/RCTUIKit.h>
#endif // !TARGET_OS_OSX

#if !TARGET_OS_OSX
@interface RNDateTimePicker : UIDatePicker
#else
@interface RNDateTimePicker : NSDatePicker
#endif

@end
