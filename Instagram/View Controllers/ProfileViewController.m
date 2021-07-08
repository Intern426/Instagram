//
//  ProfileViewController.m
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/7/21.
//

#import "ProfileViewController.h"
#import "PictureCell.h"
#import "Parse/Parse.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray* posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // Do any additional setup after loading the view.
    PFUser *user = PFUser.currentUser;
    self.usernameLabel.text = user.username;
    
    NSLog(@"%@", user);
    if (user[@"image"]) {
        
    } else {
        [self.profileView setImage:[UIImage imageNamed:@"image_placeholder"]];
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
    // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author.username == %s", PFUser.currentUser.username];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"author" containsString:PFUser.currentUser.objectId];
    // [query whereKey:@"username" containsString:PFUser.currentUser.username];
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



@end
