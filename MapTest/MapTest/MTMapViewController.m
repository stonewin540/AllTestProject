//
//  MTMapViewController.m
//  MapTest
//
//  Created by stone win on 7/7/14.
//  Copyright (c) 2014 stone win. All rights reserved.
//

#import "MTMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MapKit/MapKit.h>

@interface MTMapViewController () <MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation MTMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)searchPlaceByKey
{
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = @"俏江南";
    poiRequest.city = @[@"beijing"];
    poiRequest.requireExtension = YES;
    [self.search AMapPlaceSearch: poiRequest];
}

- (void)takeMapSnapshotWithCompletion:(void (^)(UIImage *image))completion
{
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = MKCoordinateRegionMake(self.mapView.region.center, MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta, self.mapView.region.span.longitudeDelta));
    options.scale = [UIScreen mainScreen].scale;
    options.size = self.mapView.frame.size;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        if (!error)
        {
            completion(snapshot.image);
        }
        else
        {
            NSLog(@"%s take map snap error:\n\t%@", __func__, error);
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    [self searchPlaceByKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
            annotationView.animatesDrop = YES;       //设置标注动画显示，默认为NO
            annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
            annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];  //设置气泡右侧按钮
        }
        annotationView.pinColor = [self.annotations indexOfObject:annotation] % 3;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    void (^block)(UIImage *image) = ^(UIImage *image) {
        
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AMap" ofType:@"bundle"]];
        NSString *path = [bundle pathForResource:@"images" ofType:nil];
        path = [path stringByAppendingPathComponent:@"greenPin_lift@2x.png"];
        UIImage *pinImage = [UIImage imageWithContentsOfFile:path];
        
        UIImage *screenshot = nil;
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context)
        {
            [image drawAtPoint:CGPointZero];
            for (MAPinAnnotationView *pin in views)
            {
                CGPoint point = [mapView convertCoordinate:[pin.annotation coordinate] toPointToView:self.view];
                [pinImage drawAtPoint:point];
            }
            screenshot = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
        
        CGRect imageFrame = CGRectZero;
        imageFrame.size.width = CGRectGetWidth(self.view.bounds);
        imageFrame.size.height = 100;
        imageFrame.origin.x = CGRectGetWidth(self.view.bounds);
        imageFrame.origin.y = CGRectGetHeight(self.view.bounds) - imageFrame.size.height;
        UIView *shadowView = [[UIView alloc] initWithFrame:imageFrame];
        shadowView.backgroundColor = [UIColor whiteColor];
        shadowView.layer.shadowOffset = CGSizeMake(1, -2);
        shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
        shadowView.layer.shadowOpacity = 1;
        [self.view addSubview:shadowView];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:shadowView.bounds];
        imageView.image = screenshot;
        imageView.backgroundColor = [UIColor greenColor];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.clipsToBounds = YES;
        [shadowView addSubview:imageView];
        
        // move in
        [UIView animateWithDuration:.25f animations:^{
            shadowView.center = CGPointMake(self.view.center.x, shadowView.center.y);
        } completion:^(BOOL finished) {
            if (finished)
            {
                // move out
                [UIView animateWithDuration:.25f delay:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    shadowView.center = CGPointMake(self.view.center.x + CGRectGetWidth(self.view.bounds), shadowView.center.y);
                } completion:^(BOOL finished) {
                    if (finished)
                    {
                        [shadowView removeFromSuperview];
                    }
                }];
            }
        }];
    };
    
    [self performSelector:@selector(takeMapSnapshotWithCompletion:) withObject:block afterDelay:2];
    
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
//    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
//    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
//    NSString *strPoi = @"";
//    for (AMapPOI *p in response.pois) {
//        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
//    }
//    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
//    NSLog(@"Place: %@", result);
    self.annotations = [NSMutableArray array];
    for (AMapPOI *poi in response.pois)
    {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        annotation.title = poi.name;
        annotation.subtitle = poi.type;
        [self.annotations addObject:annotation];
    }
    
    [self.mapView addAnnotations:self.annotations];
}

@end
