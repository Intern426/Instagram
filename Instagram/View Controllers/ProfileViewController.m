//
//  ProfileViewController.m
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/7/21.
//

#import "ProfileViewController.h"
#import "PictureCell.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "MBProgressHUD.h"


@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray* posts;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    if (self.user == nil) {
        self.user = [PFUser currentUser];
    }
    
    
    // Do any additional setup after loading the view.
    self.usernameLabel.text = self.user.username;
    
    [self.loadingIndicator startAnimating];
    

    
    NSLog(@"%@", self.user);
    if (self.user[@"image"]) {
        self.profileView.file = self.user[@"image"];
        [self.profileView loadInBackground];
    } else {
        [self.profileView setImage:[UIImage imageNamed:@"image_placeholder"]];
    }
    
    self.profileView.layer.cornerRadius = 30;
    
    if ([self.user.username isEqual:PFUser.currentUser.username]) {
        UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPhoto:)];
        [self.profileView addGestureRecognizer:profileTapGestureRecognizer];
        [self.profileView setUserInteractionEnabled:YES];
    } else {
        [self.navigationItem setRightBarButtonItem:nil];
    }
    [self loadPosts];
    [self setupLayout];
}

-(void) setupLayout{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged]; //Deprecated and only used for older objects
    // So do it on self, call the method, and then update interface as needed
    [self.collectionView insertSubview:self.refreshControl atIndex:0]; // controls where you put it in the view hierarchy
    
    // Setup layout
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 0;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

-(void) loadPosts{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" containsString:self.user.objectId];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    // Needed to grab the author
    [query includeKey:@"author"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = (NSMutableArray*) posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [self.loadingIndicator stopAnimating];
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.posts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PictureCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
    cell.post = self.posts[indexPath.row];
    return cell;
}

- (void) didTapPhoto:(UITapGestureRecognizer *)sender{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Take a Picture or Select Photo"
                                                                       message:@""
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *takePictureAction = [UIAlertAction actionWithTitle:@"Take a Picture"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
            
            
        }];
        UIAlertAction *pickPictureAction = [UIAlertAction actionWithTitle:@"Select a Picture"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
            
        }];
        [alert addAction:takePictureAction];
        [alert addAction:pickPictureAction];
        
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    // Do something with the images (based on your use case)
    self.profileView.image = originalImage;
    self.saveButtonItem.enabled = YES;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)didTapSave:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.user[@"image"] = [Post getPFFileFromImage:self.profileView.image];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (succeeded) {
            // The PFUser has been saved.
            NSLog(@"User's image was successfully saved!");
            self.saveButtonItem.enabled = NO;
        } else {
            // There was a problem, check error.description
            NSLog(@"boo.....%@", error.localizedDescription);
        }
    }];
}

@end
