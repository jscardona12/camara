//
//  ViewController.h
//  camara
//
//  Created by Santiago Cardona  on 30/10/16.
//  Copyright © 2016 Juan Cardona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/videoio/cap_ios.h>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
using namespace cv;

@interface ViewController : UIViewController<CvVideoCameraDelegate>
{
    IBOutlet UIImageView* imageView;
    CvVideoCamera* videoCamera;
}
@property(nonatomic, retain)CvVideoCamera* videoCamera;

@end

