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
}

@end
