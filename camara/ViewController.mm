//
//  ViewController.m
//  camara
//
//  Created by Santiago Cardona  on 30/10/16.
//  Copyright © 2016 Juan Cardona. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize videoCamera;
cv::Mat average;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    average = NULL;
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView: imageView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.videoCamera start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(Mat)grayScaleAndGaussianBlur:(Mat)mat{
    Mat grayScaledMat = Mat();
    cv::cvtColor(mat, grayScaledMat, CV_RGBA2GRAY);
    cv::GaussianBlur(grayScaledMat, grayScaledMat, cv::Size(21,21), 0);
    return grayScaledMat;
}

-(Mat) convertToInt:(Mat) mat{
    Mat converted =  Mat();
    mat.convertTo(converted,CV_8UC4);
    return converted;
}

-(Mat) convertToFloat:(Mat) mat{
    Mat converted = Mat();
    mat.convertTo(converted,CV_32FC1);
    return converted;
}

-(Mat) compare:(Mat) current{
    Mat init = Mat(cv::Size(0,0), 0);
    
    Mat currentGrayScaled = [self grayScaleAndGaussianBlur:current];
    Mat floatingMat = [self convertToFloat:currentGrayScaled];
    if(average.total() == NULL){
        printf("Average null");
        average = floatingMat;
        return current;
    }
    cv::accumulateWeighted(floatingMat, average, 0.5);
    
    Mat scaleAbs = Mat();
    cv::convertScaleAbs(average,scaleAbs);
    
    //Framedelta has CvType.CV_U8C1 since currentGrayScaled & scaleAbs have that type.
    Mat frameDelta = Mat();
    cv::absdiff(currentGrayScaled, scaleAbs, frameDelta);
    
    Mat thresh = Mat();
    cv::threshold(frameDelta,thresh, 5, 255,cv::THRESH_BINARY);
    cv::dilate(thresh, thresh, cv::Mat(), cv::Point(), 2);
    
    _OutputArray contours = _OutputArray();
    findContours(thresh, contours, Mat(), RETR_EXTERNAL,CHAIN_APPROX_SIMPLE);
    cv::Size size = contours.size();
    int lenght = size.width;
    for(int i = 0; i < lenght ; i++){
        if(cv::contourArea(contours.getMatRef(i)) < 5000){
            continue;
        }
        // Find things that moved and drawing a red rect around them.
        cv::Rect rect = cv::boundingRect(contours.getMatRef(i));
        cv::rectangle(current, rect.tl(), rect.br(), cv::Scalar(0,255,0), 2);
    }
    
    //TODO: Evaluate if MIN_NUMBER_OF_FRAMES with consecutive motion is necessary.
    
    return current;
}
#pragma mark - Protocol CvVideoCameraDelegate



#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    [self compare:image];
    
    
}
#endif




@end
