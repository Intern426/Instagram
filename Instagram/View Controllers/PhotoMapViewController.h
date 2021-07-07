//
//  PhotoMapViewController.h
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/6/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PhotoMapViewControllerDelegate

-(void) savePost: (Post*) post;

@end

@interface PhotoMapViewController : UIViewController

@property (nonatomic, weak) id<PhotoMapViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
