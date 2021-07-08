//
//  PostCell.m
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/6/21.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPhoto:)];
    [self.photoView addGestureRecognizer:profileTapGestureRecognizer];
    [self.photoView setUserInteractionEnabled:YES];
}

- (void) didTapPhoto:(UITapGestureRecognizer *)sender{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setPost:(Post *)post{
    _post = post;
    self.captionLabel.text = post[@"caption"];
    self.photoView.file = post[@"image"];
    [self.photoView loadInBackground];
    
    self.nameLabel.text = post.author.username;
    
    NSDate *date = post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.dateLabel.text = [formatter stringFromDate:date];
}


@end
