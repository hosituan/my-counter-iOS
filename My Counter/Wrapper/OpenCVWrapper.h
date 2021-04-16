//
//  OpenCVWrapper.h
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 15/04/2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

- (NSString *) openCVVersionString;
+ (nonnull UIImage *)cvtColorBGR2GRAY:(nonnull UIImage *)image;
+ (nonnull UIImage *)cvtColorCOLOR_BGR2HSV:(nonnull UIImage *)image;
+ (nonnull UIImage *)inRedRange:(nonnull UIImage *) image;
+ (nonnull UIImage *)inRange:(nonnull UIImage *) image lowerRange:(nonnull NSInteger*)lowerRange upperRange:(nonnull NSInteger*)upperRange;
+ (nonnull NSArray<UIImage*>*)findContour:(nonnull UIImage *) image;
@end

NS_ASSUME_NONNULL_END
