//
//  HelloWorldLayer.h
//  RecoloringSprite
//
//  Created by Flop on 13/03/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    int objNum;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *) sceneWithLastObj:(int)lastObj;
- (id)initWithLastObj:(int)lastObj;

@end
