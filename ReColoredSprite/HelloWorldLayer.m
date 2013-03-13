//
//  HelloWorldLayer.m
//  RecoloringSprite
//
//  Created by Flop on 13/03/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

#define RAND_COLOR_COMPONENT (float)(arc4random()%255)/255.0


@interface HelloWorldLayer ()

-(void)applyShaderToSprite:(CCSprite*)sprite;

@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer {

    GLuint color_1;
    GLuint color_2;
    GLuint color_3;
}

+(CCScene *) sceneWithLastObj:(int)lastObj // new
{
    CCScene *scene = [CCScene node];
    HelloWorldLayer *layer = [[[HelloWorldLayer alloc] 
                               initWithLastObj:lastObj] autorelease]; // new
    [scene addChild: layer];	
    return scene;
}



-(void)applyShaderToSprite:(CCSprite*)sprite {

    
    // shader
    NSString*  path = [[NSBundle mainBundle] pathForResource:@"ReColor" ofType:@"fsh"];
    const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] UTF8String];
    sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                      fragmentShaderByteArray:fragmentSource];
    [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [sprite.shaderProgram link];
    [sprite.shaderProgram updateUniforms];
    
    // link shader uniforms
    color_1 = glGetUniformLocation(sprite.shaderProgram->program_, "u_color1");
    color_2 = glGetUniformLocation(sprite.shaderProgram->program_, "u_color2");
    color_3 = glGetUniformLocation(sprite.shaderProgram->program_, "u_color3");
    
    // set values
    glUniform3f(color_1, RAND_COLOR_COMPONENT, RAND_COLOR_COMPONENT, RAND_COLOR_COMPONENT);
    glUniform3f(color_2, RAND_COLOR_COMPONENT, RAND_COLOR_COMPONENT, RAND_COLOR_COMPONENT);
    glUniform3f(color_3, RAND_COLOR_COMPONENT, RAND_COLOR_COMPONENT, RAND_COLOR_COMPONENT);
    
    // use IT
    [sprite.shaderProgram use];

}

// on "init" you need to initialize your instance
-(id) initWithLastObj:(int)lastObj {
	if( (self=[super init])) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        do {
            objNum = arc4random() % 4 + 1;
        } while (objNum == lastObj);
        
        NSString * spriteName = [NSString stringWithFormat:@"obj_%d.png", objNum];
        
        
        CCSprite* sprite = [CCSprite spriteWithFile:spriteName];
        sprite.position = ccp(winSize.width/2 - 50 , winSize.height/2 - 50);
        sprite.scaleX = 0.5;
        sprite.scaleY = 0.5;
        [self addChild:sprite];
        [self applyShaderToSprite:sprite];
        
        //add original
        sprite =  [CCSprite spriteWithFile:spriteName];
        sprite.position = ccp(winSize.width/2 + 80 , winSize.height/2 + 80);
        sprite.scaleX = 0.3;
        sprite.scaleY = 0.3;
        [self addChild:sprite];
        
        
        // perfomance test
        
        int rand = arc4random()%10;
        
        if ( rand >= 3 ) {
        
            // on my iPad2 following test with 500 sprites shows:
            // 40-42 fps when use original colors
            // 30-34 fps when apply shader
            // also i have 4-6 sec lag when applying shaders ( arc4random() lag )
            
            BOOL applyShader = NO;

            //
            if ( rand >= 6 ) {
                applyShader = YES;
            }

            
            
            for (int i = 0 ; i < 500; i++) {
                CCSprite* sprite = [CCSprite spriteWithFile:spriteName];
                sprite.position = ccp( (float) (arc4random()% (int)winSize.width) , (float) (arc4random()% (int)winSize.height));
                sprite.scaleX = 0.05;
                sprite.scaleY = 0.05;
                [self addChild:sprite];
                
                
                if (applyShader) {
                    [self applyShaderToSprite:sprite];
                }
            }
            


            CCLabelTTF *label  = [CCLabelTTF labelWithString:applyShader?@"Use Shader":@"Original Colors"
                                                  dimensions:CGSizeMake(200, 24) hAlignment:UITextAlignmentCenter fontName:@"Helvetica" fontSize:20];;
            label.position = ccp(winSize.width/2 , 50);
            [self addChild:label];
            
        }
        
        self.isTouchEnabled = YES;
	}
	return self;
}

- (void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CCScene *scene = [HelloWorldLayer sceneWithLastObj:objNum];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionZoomFlipAngular transitionWithDuration:1.0 scene:scene]];
    return TRUE;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
