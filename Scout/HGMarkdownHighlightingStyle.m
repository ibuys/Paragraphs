/* PEG Markdown Highlight
 * Copyright 2011-2016 Ali Rantakari -- http://hasseg.org
 * Licensed under the GPL2+ and MIT licenses (see LICENSE for more info).
 *
 * HGMarkdownHighlightingStyle.m
 */

#import "HGMarkdownHighlightingStyle.h"

#define kMinFontSize 4

@implementation HGMarkdownHighlightingStyle

+ (NSColor *) colorFromARGBColor:(pmh_attr_argb_color *)argb_color
{
    return [NSColor colorWithDeviceRed:(argb_color->red / 255.0)
                                 green:(argb_color->green / 255.0)
                                  blue:(argb_color->blue / 255.0)
                                 alpha:(argb_color->alpha / 255.0)];
}

- (instancetype) initWithType:(pmh_element_type)elemType
              attributesToAdd:(NSDictionary *)toAdd
                     toRemove:(NSArray *)toRemove
              fontTraitsToAdd:(NSFontTraitMask)traits
{
    if (!(self = [super init]))
        return nil;
    
    _elementType = elemType;
    _attributesToAdd = toAdd;
    _attributesToRemove = toRemove;
    _fontTraitsToAdd = traits;
    
    return self;
}

- (instancetype) initWithStyleAttributes:(pmh_style_attribute *)attributes
                                baseFont:(NSFont *)baseFont
{
    if (!(self = [super init]))
        return nil;
    
    pmh_style_attribute *cur = attributes;
    self.elementType = cur->lang_element_type;
    self.fontTraitsToAdd = 0;
    
    NSMutableDictionary *toAdd = [NSMutableDictionary dictionary];
    NSString *fontName = nil;
    CGFloat fontSize = 0;
    BOOL fontSizeIsRelative = NO;
    
    while (cur != NULL)
    {
        if (cur->type == pmh_attr_type_foreground_color)
        {
            toAdd[NSForegroundColorAttributeName] = [HGMarkdownHighlightingStyle colorFromARGBColor:cur->value->argb_color];
        }
        else if (cur->type == pmh_attr_type_background_color)
        {
            toAdd[NSBackgroundColorAttributeName] = [HGMarkdownHighlightingStyle colorFromARGBColor:cur->value->argb_color];
        }
        else if (cur->type == pmh_attr_type_strike_color)
        {
            toAdd[NSStrikethroughStyleAttributeName] = @(NSUnderlineStyleSingle);
            toAdd[NSStrikethroughColorAttributeName] = [HGMarkdownHighlightingStyle colorFromARGBColor:cur->value->argb_color];
        }
        else if (cur->type == pmh_attr_type_font_style)
        {
            if (cur->value->font_styles->italic)
                self.fontTraitsToAdd |= NSItalicFontMask;
            if (cur->value->font_styles->bold)
                self.fontTraitsToAdd |= NSBoldFontMask;
            if (cur->value->font_styles->underlined)
                toAdd[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
        }
        else if (cur->type == pmh_attr_type_font_size_pt)
        {
            fontSize = (CGFloat)cur->value->font_size->size_pt;
            fontSizeIsRelative = (cur->value->font_size->is_relative == true);
        }
        else if (cur->type == pmh_attr_type_font_family)
        {
            fontName = @(cur->value->font_family);
        }
        
        cur = cur->next;
    }
    
    if (fontName != nil || fontSize != 0)
    {
        if (fontName == nil)
            fontName = [baseFont familyName];
        
        CGFloat actualFontSize;
        if (fontSize != 0)
        {
            actualFontSize = fontSizeIsRelative ? ([baseFont pointSize] + fontSize) : fontSize;
            if (actualFontSize < kMinFontSize)
                actualFontSize = kMinFontSize;
        }
        else
        {
            actualFontSize = [baseFont pointSize];
        }
        
        NSFont *font = [NSFont fontWithName:fontName size:actualFontSize];
        if (font == nil)
            font = [NSFont fontWithName:baseFont.familyName size:actualFontSize];
        if (font == nil)
            font = [NSFont systemFontOfSize:actualFontSize];
        
        if (font)
            toAdd[NSFontAttributeName] = font;
    }
    
    self.attributesToAdd = toAdd;
    self.attributesToRemove = nil;
    
    return self;
}

@end
