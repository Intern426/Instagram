//
//  PictureCell.h
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/7/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PictureCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;

@property (strong, nonatomic) Post* post;

@end

NS_ASSUME_NONNULL_END
