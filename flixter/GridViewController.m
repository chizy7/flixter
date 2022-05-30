//
//  GridViewController.m
//  flixter
//
//  Created by Chizaram Chibueze on 5/15/22.
//

#import "GridViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "MovieGridCell.h"

@interface GridViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *movieArray;
@property (strong, nonatomic) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self fetchMovies];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionFlowLayout.minimumLineSpacing = 10;
    self.collectionFlowLayout.minimumInteritemSpacing = 0;
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}



- (void) fetchMovies{
    self.filteredData = self.movieArray;
    
    UIAlertController *networkAlert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchMovies];
        }];
    
    [networkAlert addAction:tryAgainAction];
    

    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=bac6c1730fe2aa06affb9b3aead2320f"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               //Alert UI
               [self presentViewController:networkAlert animated:YES completion:^{
                   // optional code for what happens after the alert controller has finished presenting
               }];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary); // remove after | for logging

               self.movieArray =dataDictionary[@"results"];
               self.filteredData = dataDictionary[@"results"];
               
               [self.collectionView reloadData];
               
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               
               }
               
    }];
    [task resume];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieGridCell" forIndexPath:indexPath];

    
    NSDictionary *movie = self.filteredData[indexPath.row];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *fullPosterUrl = [baseURLString stringByAppendingString:movie[@"poster_path"]];
    
    NSURL *posterUrl = [NSURL URLWithString:fullPosterUrl];
    
    [cell.posterImage setImageWithURL:posterUrl];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    int totalwidth = self.collectionView.bounds.size.width;
    int numberOfCellsPerRow = 3;
    int widthDimensions = (CGFloat)(totalwidth / numberOfCellsPerRow);
    int heightDimensions = widthDimensions * 1.2;
    return CGSizeMake(widthDimensions, heightDimensions);
}


/*
#pragma mark - Navigation
In a storyboard-based application, you will often want to do a little preparation before navigation
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     //Get the new view controller using [segue destinationViewController].
    UICollectionViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.collectionView indexPathForCell:cell];
    //Pass the selected object to the new view controller.
    NSDictionary *dataToPass = self.filteredData[myIndexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}


@end


//
//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}
//

