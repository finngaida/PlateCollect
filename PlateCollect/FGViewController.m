//
//  FGViewController.m
//  PlateCollect
//
//  Created by Finn Gaida on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGViewController.h"

@implementation FGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSettingsDrag];
    [self setUpSideMenu];
    
    // Button to zoom to current region
    UIButton *zoomToLocal = [[UIButton alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width-35, [UIScreen mainScreen].bounds.size.height-35, 30, 30)];
    zoomToLocal.backgroundColor = [UIColor whiteColor];
    zoomToLocal.layer.masksToBounds = YES;
    zoomToLocal.layer.cornerRadius = 5;
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loc"]];
    iv.frame = CGRectMake(5, 5, 20, 20);
    [zoomToLocal addSubview:iv];
    [zoomToLocal setImage:[UIImage imageNamed:@"pin"] forState:UIControlStateHighlighted];
    [zoomToLocal addTarget:self action:@selector(zoomHome) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:zoomToLocal];
    
    // Set up map
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    FGStuffCalculator *c = [FGStuffCalculator new];
    [c fetchCurrentLocationWithHandler:^(CLLocation *location, NSError *error) {
        
        NSLog(@"Zoomed to latitude: %f", location.coordinate.latitude);
        [self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.2, .2)) animated:YES];
        
        // Fetch the 30 nearest placemarks from the location parameter and create FGStolperstein 's for it
        
        // loop through them and add the annotations
        /*for (FGStolperstein *s in stolpersteine) {
            FGAnnotation *a = [[FGAnnotation alloc] initWithTitle:s.name andCoordinate:s.coord];
            [self.mapView addAnnotation:];
        }*/
        
    }];
    
    FGAnnotation *a = [[FGAnnotation alloc] initWithTitle:@"Stolperstein" andCoordinate:CLLocationCoordinate2DMake(52.51944444, 13.4066666)];
    [self.mapView addAnnotation:a];
}

- (void)zoomHome {
    
    // Fetch the current location and zoom to it
    FGStuffCalculator *c = [FGStuffCalculator new];
    [c fetchCurrentLocationWithHandler:^(CLLocation *location, NSError *error) {
        NSLog(@"Zoomed to latitude: %f", location.coordinate.latitude);
        [self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.2, .2)) animated:YES];
    }];
}

- (void)setUpSettingsDrag {
    
    // Create the gesture recognizer and put it on a new view, represnting the drag-start area.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 600)]; v.backgroundColor = [UIColor clearColor];
    v.tag = 99;
    [self.containerView addSubview:v];
    [v addGestureRecognizer:pan];
    
    
}

- (void)setUpSideMenu {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 280, [UIScreen mainScreen].bounds.size.height)];
    scrollView.contentSize = CGSizeMake(280, scrollView.frame.size.height+1);
    [self.view insertSubview:scrollView atIndex:0];
    
    profile = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 260, 50)];
    profile.backgroundColor = [UIColor clearColor];
    profile.tag = 1;
    [profile addTarget:self action:@selector(pushMenuItem:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *profileTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 50)];
    profileTitle.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    profileTitle.backgroundColor = [UIColor clearColor];
    profileTitle.textColor = [UIColor whiteColor];
    profileTitle.font = [UIFont fontWithName:@"Futura" size:25];
    profileTitle.textAlignment = NSTextAlignmentCenter;
    profileTitle.text = @"Profile";                                     // Later on the username set up at startup
    [profile addSubview:profileTitle];
    [scrollView addSubview:profile];
    
    settings = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 260, 50)];
    settings.backgroundColor = [UIColor clearColor];
    settings.tag = 2;
    [settings addTarget:self action:@selector(pushMenuItem:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *settingsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 50)];
    settingsTitle.backgroundColor = [UIColor clearColor];
    settingsTitle.textColor = [UIColor whiteColor];
    settingsTitle.font = [UIFont fontWithName:@"Futura" size:25];
    settingsTitle.textAlignment = NSTextAlignmentCenter;
    settingsTitle.text = @"Settings";                                     // Must be translated
    [settings addSubview:settingsTitle];
    [scrollView addSubview:settings];
    
    credits = [[UIButton alloc] initWithFrame:CGRectMake(10, 140, 260, 50)];
    credits.backgroundColor = [UIColor clearColor];
    credits.tag = 3;
    [credits addTarget:self action:@selector(pushMenuItem:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *creditsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 50)];
    creditsTitle.backgroundColor = [UIColor clearColor];
    creditsTitle.textColor = [UIColor whiteColor];
    creditsTitle.font = [UIFont fontWithName:@"Futura" size:25];
    creditsTitle.textAlignment = NSTextAlignmentCenter;
    creditsTitle.text = @"Credits";                                     // Must be translated
    [credits addSubview:creditsTitle];
    [scrollView addSubview:credits];
    
}

- (void)pushMenuItem:(UIButton *)sender {
    
    float v = 0.2; // velocity of the animation
    
    switch (sender.tag) {
        case 1: {
            
            // profile button was tapped
            
            // animate the main items out
            [UIView animateWithDuration:v delay:v-v options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                profile.center = CGPointMake(480, profile.center.y);
            } completion:nil];
            [UIView animateWithDuration:v delay:v/2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                settings.center = CGPointMake(480, settings.center.y);
            } completion:nil];
            [UIView animateWithDuration:v delay:v options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                credits.center = CGPointMake(480, credits.center.y);
            } completion:nil];
            
            // animate the subitem in
            [UIView animateWithDuration:v delay:v/2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                //profile.center = CGPointMake(480, profile.center.y);
            } completion:nil];
            [UIView animateWithDuration:v delay:v options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                //profile.center = CGPointMake(480, profile.center.y);
            } completion:nil];
            [UIView animateWithDuration:v delay:v+v/2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                //profile.center = CGPointMake(480, profile.center.y);
            } completion:nil];
            
        } break;
        case 2: {
            
            // settings button was tapped
            
            // animate the main items out
            [UIView animateWithDuration:v delay:v/2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                profile.center = CGPointMake(480, profile.center.y);
            } completion:nil];
            [UIView animateWithDuration:v delay:v-v options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                settings.center = CGPointMake(480, settings.center.y);
            } completion:nil];
            [UIView animateWithDuration:v delay:v options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                credits.center = CGPointMake(480, credits.center.y);
            } completion:nil];
            
            
            // animate the subitem in
            [UIView animateWithDuration:v delay:v/2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                //profile.center = CGPointMake(480, profile.center.y);
            } completion:nil];
            [UIView animateWithDuration:v delay:v options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                //profile.center = CGPointMake(480, profile.center.y);
            } completion:nil];
            [UIView animateWithDuration:v delay:v+v/2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                //profile.center = CGPointMake(480, profile.center.y);
            } completion:nil];
            
            
        } break;
        case 3: {
            
            // credits button was tapped
            
            // animate the main items out
            [UIView animateWithDuration:v delay:v/2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                profile.center = CGPointMake(480, profile.center.y);
            } completion:nil];
            [UIView animateWithDuration:v delay:v options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                settings.center = CGPointMake(480, settings.center.y);
            } completion:nil];
            [UIView animateWithDuration:v delay:v-v options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                credits.center = CGPointMake(480, credits.center.y);
            } completion:nil];
            
        } break;
        default:break;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan locationInView:self.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            
        } break;
        case UIGestureRecognizerStateChanged: {
            self.containerView.center = CGPointMake(160+p.x, self.containerView.center.y);
            
            profile.frame = CGRectMake(10*((p.x/280)*.7), 20*((p.x/280)*.7), 260*((p.x/280)*.7), 50*((p.x/280)*.7));
        } break;
        case UIGestureRecognizerStateEnded: {
            if (p.x>=160) {
                [UIView animateWithDuration:.2 animations:^{
                    self.containerView.center = CGPointMake(450, self.containerView.center.y);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.2 animations:^{
                        self.containerView.center = CGPointMake(445, self.containerView.center.y);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.2 animations:^{
                            self.containerView.center = CGPointMake(440, self.containerView.center.y);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
                
                // set the dragview to be wider
                for (UIView *v in self.containerView.subviews) {
                    if (v.tag == 99) {
                        v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y, 40, v.frame.size.height);
                    }
                }
                
            } else {
                [UIView animateWithDuration:.2 animations:^{
                    self.containerView.center = CGPointMake(150, self.containerView.center.y);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.2 animations:^{
                        self.containerView.center = CGPointMake(165, self.containerView.center.y);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.2 animations:^{
                            self.containerView.center = CGPointMake(160, self.containerView.center.y);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
                
                // set the dragview to be wider
                for (UIView *v in self.containerView.subviews) {
                    if (v.tag == 99) {
                        v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y, 10, v.frame.size.height);
                    }
                }
            }
        } break;
        default:break;
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
    
    // Check if the wanted annotation is the users location
    if ([annotation isKindOfClass:[MKUserLocation class]]) {return nil;}
    
    MKPinAnnotationView *a = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
    a.image = [UIImage imageNamed:@"pin"];
    a.canShowCallout = YES;
    a.draggable = NO;
    a.calloutOffset = CGPointMake(0, 1);
    a.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
    UIButton *detail = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [detail addTarget:self action:@selector(mapView:annotationView:calloutAccessoryControlTapped:) forControlEvents:UIControlEventTouchUpInside];
    a.rightCalloutAccessoryView = detail;
    
    return a;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    //[self performSegueWithIdentifier:@"showDetailView" sender:self];

    FGDetailViewController *detailVC = [[FGDetailViewController alloc] init];
    detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    detailVC.stone = [[FGStolperstein alloc] initWithFirst:@"Peter" last:@"Pan" born:nil birthday:nil address:@"Nimmerland" quarter:@"Auschwitz" deportations:nil  locationOfDeath:@"Auschwitz" dayOfDeath:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
