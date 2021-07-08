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


@protocol PostCellDelegate;

@interface PostCell : UITableViewCell

@property (strong, nonatomic) Post* post;
@property (weak, nonatomic) IBOutlet PFImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) id<PostCellDelegate> delegate;

@end

@protocol PostCellDelegate <NSObject>

- (void)postCell:(PostCell *) postCell didTapPhoto: (PFUser *)user;


@end

NS_ASSUME_NONNULL_END
