//
//  CustomCameraViewController.h
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/9/21.
//

@import UIKit;
@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@protocol CustomCameraViewControllerDelegate <NSObject>
-(void) saveTakenImage:(UIImage*) image;
@end

@interface CustomCameraViewController : UIViewController

@property (nonatomic, weak) id<CustomCameraViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
