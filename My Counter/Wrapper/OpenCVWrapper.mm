//
//  OpenCVWrapper.m
//  My Counter
//
//  Created by Hồ Sĩ Tuấn on 15/04/2021.
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc.hpp>
#pragma clang diagnostic pop

#import <UIKit/UIKit.h>

/// Converts an UIImage to Mat.
/// Orientation of UIImage will be lost.
static void UIImageToMat(UIImage *image, cv::Mat &mat) {
    assert(image.size.width > 0 && image.size.height > 0);
    assert(image.CGImage != nil || image.CIImage != nil);

    // Create a pixel buffer.
    NSInteger width = image.size.width;
    NSInteger height = image.size.height;
    cv::Mat mat8uc4 = cv::Mat((int)height, (int)width, CV_8UC4);

    // Draw all pixels to the buffer.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (image.CGImage) {
        // Render with using Core Graphics.
        CGContextRef contextRef = CGBitmapContextCreate(mat8uc4.data, mat8uc4.cols, mat8uc4.rows, 8, mat8uc4.step, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
        CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage);
        CGContextRelease(contextRef);
    } else {
        // Render with using Core Image.
        static CIContext* context = nil; // I do not like this declaration contains 'static'. But it is for performance.
        if (!context) {
            context = [CIContext contextWithOptions:@{ kCIContextUseSoftwareRenderer: @NO }];
        }
        CGRect bounds = CGRectMake(0, 0, width, height);
        [context render:image.CIImage toBitmap:mat8uc4.data rowBytes:mat8uc4.step bounds:bounds format:kCIFormatRGBA8 colorSpace:colorSpace];
    }
    CGColorSpaceRelease(colorSpace);

    // Adjust byte order of pixel.
    cv::Mat mat8uc3 = cv::Mat((int)width, (int)height, CV_8UC3);
    cv::cvtColor(mat8uc4, mat8uc3, cv::COLOR_RGBA2BGR);

    mat = mat8uc3;
}

/// Converts a Mat to UIImage.
static UIImage *MatToUIImage(cv::Mat &mat) {

    // Create a pixel buffer.
    assert(mat.elemSize() == 1 || mat.elemSize() == 3);
    cv::Mat matrgb;
    if (mat.elemSize() == 1) {
        cv::cvtColor(mat, matrgb, cv::COLOR_GRAY2RGB);
    } else if (mat.elemSize() == 3) {
        cv::cvtColor(mat, matrgb, cv::COLOR_BGR2RGB);
    }

    // Change a image format.
    NSData *data = [NSData dataWithBytes:matrgb.data length:(matrgb.elemSize() * matrgb.total())];
    CGColorSpaceRef colorSpace;
    if (matrgb.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(matrgb.cols, matrgb.rows, 8, 8 * matrgb.elemSize(), matrgb.step.p[0], colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    return image;
}

/// Restore the orientation to image.
static UIImage *RestoreUIImageOrientation(UIImage *processed, UIImage *original) {
    if (processed.imageOrientation == original.imageOrientation) {
        return processed;
    }
    return [UIImage imageWithCGImage:processed.CGImage scale:1.0 orientation:original.imageOrientation];
}


@implementation OpenCVWrapper

-(NSString *) openCVVersionString
{
    return [NSString stringWithFormat:@"OpenCV Version %s", CV_VERSION];
}

+ (nonnull UIImage *)cvtColorBGR2GRAY:(nonnull UIImage *)image {
    cv::Mat bgrMat;
    UIImageToMat(image, bgrMat);
    cv::Mat grayMat;
    cv::cvtColor(bgrMat, grayMat, cv::COLOR_BGR2GRAY);
    UIImage *grayImage = MatToUIImage(grayMat);
    return RestoreUIImageOrientation(grayImage, image);
}

+ (nonnull UIImage *)cvtColorCOLOR_BGR2HSV:(nonnull UIImage *)image {
    cv::Mat bgrMat;
    UIImageToMat(image, bgrMat);
    cv::Mat hsvMat;
    cv::cvtColor(bgrMat, hsvMat, cv::COLOR_BGR2HSV);
    UIImage *hsvImage = MatToUIImage(hsvMat);
    return RestoreUIImageOrientation(hsvImage, image);
}


//+ (nonnull UIImage *)drawRect:(nonnull UIImage *) image rect:(nonnull CGRect *)rect {
//    int x = 0;
//    int y = 0;
//    int width = 10;
//    int height = 20;
//    cv::Rect rect(x, y, width, height);
//    cv::Point pt1(x, y);
//    cv::Point pt2(x + width, y + height);
//    cv::rectangle(image, pt1, pt2, cv::Scalar(0, 255, 0));
//    cv::rectangle(image, rect, cv::Scalar(0, 255, 0))
//}


+ (nonnull UIImage *)inRange:(nonnull UIImage *) image lowerRange:(nonnull NSInteger*)lowerRange upperRange:(nonnull NSInteger*)upperRange {
    cv::Mat bgrMat;
    UIImageToMat(image, bgrMat);
    cv::Mat rangeMat;
    int lowH = (int) lowerRange[0];
    int lowS = (int) lowerRange[1];
    int lowV = (int) lowerRange[2];
    int upH = (int) upperRange[0];
    int upS = (int) upperRange[1];
    int upV = (int) upperRange[2];
    cv::inRange(bgrMat, cv::Scalar(lowH, lowS, lowV), cv::Scalar(upH, upS, upV), rangeMat);
    UIImage *rangeImage = MatToUIImage(rangeMat);
    return RestoreUIImageOrientation(rangeImage, image);
}

+ (nonnull UIImage *)inRedRange:(nonnull UIImage *) image {
    cv::Mat bgrMat;
    UIImageToMat(image, bgrMat);
    cv::Mat rangeMat1;
    cv::Mat rangeMat2;
    cv::inRange(bgrMat, cv::Scalar(0, 70, 0), cv::Scalar(30, 255, 255), rangeMat1);
    cv::inRange(bgrMat, cv::Scalar(170, 70, 0), cv::Scalar(180, 255, 255), rangeMat2);
    cv::Mat matResult;
    cv::add(rangeMat1, rangeMat2, matResult);
    cv::Mat result;
    cv::bitwise_and(bgrMat, matResult, result);
    
    UIImage *rangeImage = MatToUIImage(result);
    return RestoreUIImageOrientation(rangeImage, image);
}

+ (nonnull NSArray<UIImage*>*)findContour:(nonnull UIImage *) image {
    cv::Mat bgrMat;
    UIImageToMat(image, bgrMat);
    cv::Mat result;
    cv::Mat grayMat;
    cv::cvtColor(bgrMat, grayMat, cv::COLOR_BGR2GRAY);
    cv::Mat thresh;
    cv::Mat canny;
    int thresh_val = 50;
    cv::threshold(grayMat, thresh, 0, 255, cv::THRESH_BINARY | cv::THRESH_OTSU);
    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    
    cv::Canny(grayMat, canny, thresh_val, thresh_val*2 );
    cv::findContours(canny, contours, hierarchy, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE );
    
    std::vector<cv::Rect> boundRect(contours.size());
    std::vector<std::vector<cv::Point> > contours_poly( contours.size() );
    for( size_t i = 0; i < contours.size(); i++ )
      {
        cv::approxPolyDP( cv::Mat(contours[i]), contours_poly[i], 3, true );
        boundRect[i] = boundingRect( cv::Mat(contours_poly[i]) );
      }
    NSMutableArray *imagesArray = [NSMutableArray array];
    cv::Mat drawing = cv::Mat::zeros( canny.size(), CV_8UC3 );
    for (int i = 0; i < contours.size(); i++) {
        double area = cv::contourArea(contours[i]);
        if (area > 100) {
            //cv::rectangle(bgrMat, boundRect[i], cv::Scalar(0, 255, 0));
            cv::Mat croppedImage = bgrMat(boundRect[i]);
            UIImage *resultImage = MatToUIImage(croppedImage);
            UIImage *restore = RestoreUIImageOrientation(resultImage, image);
            [imagesArray addObject: restore];
        }
    }
    
    
//    UIImage *resultImage = MatToUIImage(bgrMat);
//    UIImage *restore = RestoreUIImageOrientation(resultImage, image);
//    [imagesArray addObject: restore];
    
    return imagesArray;
}





@end


