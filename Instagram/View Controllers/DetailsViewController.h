//
//  DetailsViewController.h
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/7/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN


@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Post* post;

@end

NS_ASSUME_NONNULL_END
