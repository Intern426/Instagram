//
//  DetailsViewController.m
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/7/21.
//

#import "DetailsViewController.h"
#import "ProfileViewController.h"
@import Parse;

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
    
    // Do any additional setup after loading the view.
    PFUser *author = self.post.author;
    [self setupLabels:author];
    if (author[@"image"]) {
        self.profileImageView.file = author[@"image"];
        [self.profileImageView loadInBackground];
    } else {
        [self.profileImageView setImage:[UIImage imageNamed:@"image_placeholder"]];
    }
    
    self.profileImageView.layer.cornerRadius = 30;
}


- (void) setupLabels:(PFUser *) author{
    self.usernameLabel.text = author.username;
    
    self.imageView.file = self.post[@"image"];
    self.captionLabel.text = self.post[@"caption"];
    
    // Configure the input format to parse the date string
    NSDate *date = self.post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.dateLabel.text = [formatter stringFromDate:date];
    
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", self.post[@"likeCount"]];
}


- (void)didTapUserProfile:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self performSegueWithIdentifier:@"profileSegue" sender:(self.post.author)];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"profileSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ProfileViewController *profileViewController = (ProfileViewController*) navigationController.topViewController;
        profileViewController.user = self.post.author;
    }
}


@end
