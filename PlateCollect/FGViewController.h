//
//  FGViewController.h
//  PlateCollect
//
//  Created by Finn Gaida on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FGStuffCalculator.h"
#import "FGAnnotation.h"
#import "FGDetailViewController.h"
#import "FGStolperstein.h"

@interface FGViewController : UIViewController <MKMapViewDelegate> {
    
    // For the side main menu
    UIButton *profile;
    UIButton *settings;
    UIButton *credits;
    
    // Side menu settings branch
    UILabel *profileSublabel;
    UILabel *settingsSublabel;
    UILabel *creditsSublabel; //has to be renamed
    UIButton *backButton;
    
    
    
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
