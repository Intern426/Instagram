//
//  HomeViewController.m
//  Instagram
//
//  Created by Kalkidan Tamirat on 7/6/21.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "PhotoMapViewController.h"
#import "PostCell.h"
#import "DetailsViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, PhotoMapViewControllerDelegate, UIScrollViewDelegate, PostCellDelegate>
@property (strong, nonatomic) NSMutableArray* posts;
@property (strong, nonatomic) NSMutableArray* users;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorView;
@property (assign, nonatomic) BOOL isMoreDataLoading;



@end

@implementation HomeViewController

NSString *HeaderViewIdentifier = @"TableViewHeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.posts = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged]; //Deprecated and only used for older objects
    [self.tableView insertSubview:self.refreshControl atIndex:0]; // controls where you put it in the view hierarchy
    [self.loadingIndicatorView startAnimating];
    
    [self loadPosts];
}


-(void) loadPosts{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //  [query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;
    
    // Needed to grab the author
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = (NSMutableArray*) posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [self.loadingIndicatorView stopAnimating];
    }];
}

-(void) loadMorePosts{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //  [query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;
    
    // Needed to grab the author
    [query includeKey:@"author"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = (NSMutableArray*) posts;
            self.isMoreDataLoading = false;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [self.loadingIndicatorView stopAnimating];
    }];
}


- (IBAction)tapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil]; // Access Main.storyboard
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]; // Call forth the login view controller
            
            sceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"postSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        PhotoMapViewController *photoController = (PhotoMapViewController*) navigationController.topViewController;
        photoController.delegate = self;
    } else if ([segue.identifier isEqual:@"detailsSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post* post = self.posts[indexPath.row];
        NSLog(@"%@", post[@"caption"]);
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *detailsViewController = (DetailsViewController*) navigationController.topViewController;
        detailsViewController.post = post;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.delegate = self;
    cell.post = self.posts[indexPath.row];
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        self.isMoreDataLoading = true;
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadPosts];
        }
    }
}


- (void)didShare {
    [self loadPosts];
}


- (void)postCell:(nonnull PostCell *)postCell didTapPhoto:(nonnull PFUser *)user {
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

@end
