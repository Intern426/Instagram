//
//  PostCell.m
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/6/21.
//

#import "PostCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.profileView.layer.cornerRadius = 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setPost:(Post *)post{
    _post = post;
    self.captionLabel.text = post[@"caption"];
    self.photoView.file = post[@"image"];
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", post[@"likeCount"]];
    [self.photoView loadInBackground];
    self.nameLabel.text = post.author.username;
    
    // Update profile image
    PFUser* user = post.author;
    if (user[@"image"]) {
        self.profileView.file = user[@"image"];
        [self.profileView loadInBackground];
    } else {
        [self.profileView setImage:[UIImage imageNamed:@"image_placeholder"]];
    }
    
    // Update date created
    NSDate *date = post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.dateLabel.text = [formatter stringFromDate:date];
    
   [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateSelected];
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
}
- (IBAction)didTapLike:(id)sender {
    int count = self.post.likeCount.intValue;
    if (self.likeButton.selected) {
        self.likeButton.selected = NO;
        count--;
    } else {
        self.likeButton.selected = YES;
        count++;
    }
    self.post.likeCount = [[NSNumber alloc] initWithInt:count];
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Post was liked/unliked!");
            self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", self.post[@"likeCount"]];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


@end
