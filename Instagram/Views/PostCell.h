//
//  PostCell.h
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/6/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (strong, nonatomic) Post* post;
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;



@end

NS_ASSUME_NONNULL_END
