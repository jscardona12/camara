//
//  VideoCamera.m
//  camara
//
//  Created by Santiago Cardona  on 30/10/16.
//  Copyright © 2016 Juan Cardona. All rights reserved.
//

#import "VideoCamera.h"
#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)
@implementation VideoCamera

- (void)updateOrientation;
{
    self->customPreviewLayer.bounds = CGRectMake(0, 0, self.parentView.frame.size.width, self.parentView.frame.size.height);
    [self layoutPreviewLayer];
}



- (void)layoutPreviewLayer;
{
    if (self.parentView != nil)
    {
    }
}
@end

