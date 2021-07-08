//
//  PictureCell.m
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/7/21.
//

#import "PictureCell.h"

@implementation PictureCell

-(void) setPost:(Post *)post{
    _post = post;
    self.photoImageView.file = post[@"image"];
    [self.photoImageView loadInBackground];
}

@end
