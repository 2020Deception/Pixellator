//
//  main.m
//  Pixellator
//
//  Created by Brian Sharrief Alim Bowman on 12/28/16.
//  Copyright © 2016 Brian Sharrief Alim Bowman. All rights reserved.
//

@import Foundation;
@import AppKit;
@import CoreImage;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 3) {
            printf("not enough args. Pass the image name and the scale value, in their respective order");
        }
        NSString *filepath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        NSImage *img = [[NSImage alloc] initWithContentsOfFile:filepath];
        NSImageView *view = [NSImageView imageViewWithImage:img];
        NSLog(@"%@", img);
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *ciImage = [[CIImage alloc] initWithData:[NSData dataWithContentsOfFile:filepath]];
        CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
        
        [filter setValue:ciImage forKey:kCIInputImageKey];
        [filter setValue:[CIVector vectorWithCGRect:view.frame] forKey:@"inputCenter"];
        [filter setValue:@(argv[2]) forKey:@"inputScale"];
        
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGRect extent = [result extent];
        
        NSData *imgData = [[NSImage alloc] initWithCGImage:[context createCGImage:result fromRect:extent] size:extent.size].TIFFRepresentation;
        
        BOOL success = [imgData writeToFile:[NSString stringWithFormat:@"pixellated-%@", filepath] atomically:NO];
        
        if (!success) {
            printf("something went wrong trying to create the image");
        }
    }
    return 0;
}
