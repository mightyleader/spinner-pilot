//
//  NSString+entityStripping.m
//
//  Created by Rob Stearn on 15/01/2015.
//  Copyright (c) 2015. All rights reserved.
//

#import "NSString+entityStripping.h"

@implementation NSString (entityStripping)

+ (NSString *)stringByStrippingMarkupEntitiesFromString:(NSString *)string {
  NSString *regexPatternForMarkupEntities = @"(&{1})(#?)([a-zA-Z0-9]*)(;{1})";
  NSMutableString *holdingString = [NSMutableString new];
  NSInteger index = 0;
  NSError *error = NULL;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPatternForMarkupEntities
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:&error];
  NSArray *matchArray = [regex matchesInString:string options:NSMatchingReportCompletion range:[string rangeOfString:string]];

  //Throw out with the original string of there's no matches. Generally don't like multiple return points but this saves cycles.
  if (!matchArray || matchArray.count == 0) {
    return string;
  }

  //Iterate through matches
  for (NSTextCheckingResult *match in matchArray) {
    NSRange rangeOfMatch = match.range;
    NSString *stringMatch = [string substringWithRange:rangeOfMatch];
    NSString *replacementString = @"";
    [holdingString appendString:[string substringWithRange:NSMakeRange(index, rangeOfMatch.location - index)]];

    if ([[stringMatch substringToIndex:2] isEqualToString:@"&#"]) {
      //it's a numerical reference
      NSString *numberAsString = [stringMatch substringWithRange:NSMakeRange(2, stringMatch.length - 2)];
      NSInteger number = [numberAsString integerValue];
      replacementString = [NSString characterFromDecimal:number];
    }
    else {
      //it's a character reference
      NSString *entityString = [stringMatch substringWithRange:NSMakeRange(1, stringMatch.length - 2)];
      replacementString = [NSString characterFromEntity:entityString];
    }
    if (replacementString) {
      [holdingString appendString:replacementString];
    }

    //setup the index for the next chunk
    index = rangeOfMatch.location + rangeOfMatch.length;
  }

  return holdingString;
}

+ (NSString *)characterFromDecimal:(NSInteger)unicodeRef {
  return [NSString stringWithFormat:@"%C", (unichar)unicodeRef];
}

+ (NSString *)characterFromEntity:(NSString *)entity {
  NSDictionary *entityMap = [NSString nameToCharacterMap];
  return entityMap[entity];
}

+ (NSDictionary *)nameToCharacterMap {
  // referenced from: https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
  return [NSDictionary dictionaryWithObjectsAndKeys:
          @"\"",
          @"quot",
          @"&",
          @"amp",
          @"",
          @"apos",
          @"<",
          @"lt",
          @">",
          @"gt",
          @" ",
          @"nbsp",
          @"¡",
          @"iexcl",
          @"¢",
          @"cent",
          @"£",
          @"pound",
          @"¤",
          @"curren",
          @"¥",
          @"yen",
          @"¦",
          @"brvbar",
          @"§",
          @"sect",
          @"¨",
          @"uml",
          @"©",
          @"copy",
          @"ª",
          @"ordf",
          @"«",
          @"laquo",
          @"¬",
          @"not",
          @" ",
          @"shy",
          @"®",
          @"reg",
          @"¯",
          @"macr",
          @"°",
          @"deg",
          @"±",
          @"plusmn",
          @"²",
          @"sup2",
          @"³",
          @"sup3",
          @"´",
          @"acute",
          @"µ",
          @"micro",
          @"¶",
          @"para",
          @"·",
          @"middot",
          @"¸",
          @"cedil",
          @"¹",
          @"sup1",
          @"º",
          @"ordm",
          @"»",
          @"raquo",
          @"¼",
          @"frac14",
          @"½",
          @"frac12",
          @"¾",
          @"frac34",
          @"¿",
          @"iquest",
          @"À",
          @"Agrave",
          @"Á",
          @"Aacute",
          @"Â",
          @"Acirc",
          @"Ã",
          @"Atilde",
          @"Ä",
          @"Auml",
          @"Å",
          @"Aring",
          @"Æ",
          @"AElig",
          @"Ç",
          @"Ccedil",
          @"È",
          @"Egrave",
          @"É",
          @"Eacute",
          @"Ê",
          @"Ecirc",
          @"Ë",
          @"Euml",
          @"Ì",
          @"Igrave",
          @"Í",
          @"Iacute",
          @"Î",
          @"Icirc",
          @"Ï",
          @"Iuml",
          @"Ð",
          @"ETH",
          @"Ñ",
          @"Ntilde",
          @"Ò",
          @"Ograve",
          @"Ó",
          @"Oacute",
          @"Ô",
          @"Ocirc",
          @"Õ",
          @"Otilde",
          @"Ö",
          @"Ouml",
          @"×",
          @"times",
          @"Ø",
          @"Oslash",
          @"Ù",
          @"Ugrave",
          @"Ú",
          @"Uacute",
          @"Û",
          @"Ucirc",
          @"Ü",
          @"Uuml",
          @"Ý",
          @"Yacute",
          @"Þ",
          @"THORN",
          @"ß",
          @"szlig",
          @"à",
          @"agrave",
          @"á",
          @"aacute",
          @"â",
          @"acirc",
          @"ã",
          @"atilde",
          @"ä",
          @"auml",
          @"å",
          @"aring",
          @"æ",
          @"aelig",
          @"ç",
          @"ccedil",
          @"è",
          @"egrave",
          @"é",
          @"eacute",
          @"ê",
          @"ecirc",
          @"ë",
          @"euml",
          @"ì",
          @"igrave",
          @"í",
          @"iacute",
          @"î",
          @"icirc",
          @"ï",
          @"iuml",
          @"ð",
          @"eth",
          @"ñ",
          @"ntilde",
          @"ò",
          @"ograve",
          @"ó",
          @"oacute",
          @"ô",
          @"ocirc",
          @"õ",
          @"otilde",
          @"ö",
          @"ouml",
          @"÷",
          @"divide",
          @"ø",
          @"oslash",
          @"ù",
          @"ugrave",
          @"ú",
          @"uacute",
          @"û",
          @"ucirc",
          @"ü",
          @"uuml",
          @"ý",
          @"yacute",
          @"þ",
          @"thorn",
          @"ÿ",
          @"yuml",
          @"Œ",
          @"OElig",
          @"œ",
          @"oelig",
          @"Š",
          @"Scaron",
          @"š",
          @"scaron",
          @"Ÿ",
          @"Yuml",
          @"ƒ",
          @"fnof",
          @"ˆ",
          @"circ",
          @"˜",
          @"tilde",
          @"Α",
          @"Alpha",
          @"Β",
          @"Beta",
          @"Γ",
          @"Gamma",
          @"Δ",
          @"Delta",
          @"Ε",
          @"Epsilon",
          @"Ζ",
          @"Zeta",
          @"Η",
          @"Eta",
          @"Θ",
          @"Theta",
          @"Ι",
          @"Iota",
          @"Κ",
          @"Kappa",
          @"Λ",
          @"Lambda",
          @"Μ",
          @"Mu",
          @"Ν",
          @"Nu",
          @"Ξ",
          @"Xi",
          @"Ο",
          @"Omicron",
          @"Π",
          @"Pi",
          @"Ρ",
          @"Rho",
          @"Σ",
          @"Sigma",
          @"Τ",
          @"Tau",
          @"Υ",
          @"Upsilon",
          @"Φ",
          @"Phi",
          @"Χ",
          @"Chi",
          @"Ψ",
          @"Psi",
          @"Ω",
          @"Omega",
          @"α",
          @"alpha",
          @"β",
          @"beta",
          @"γ",
          @"gamma",
          @"δ",
          @"delta",
          @"ε",
          @"epsilon",
          @"ζ",
          @"zeta",
          @"η",
          @"eta",
          @"θ",
          @"theta",
          @"ι",
          @"iota",
          @"κ",
          @"kappa",
          @"λ",
          @"lambda",
          @"μ",
          @"mu",
          @"ν",
          @"nu",
          @"ξ",
          @"xi",
          @"ο",
          @"omicron",
          @"π",
          @"pi",
          @"ρ",
          @"rho",
          @"ς",
          @"sigmaf",
          @"σ",
          @"sigma",
          @"τ",
          @"tau",
          @"υ",
          @"upsilon",
          @"φ",
          @"phi",
          @"χ",
          @"chi",
          @"ψ",
          @"psi",
          @"ω",
          @"omega",
          @"ϑ",
          @"thetasym",
          @"ϒ",
          @"upsih",
          @"ϖ",
          @"piv",
          @" ",
          @"ensp",
          @" ",
          @"emsp",
          @"  ",
          @"thinsp",
          @" ",
          @"zwnj",
          @" ",
          @"zwj",
          @" ",
          @"lrm",
          @" ",
          @"rlm",
          @"–",
          @"ndash",
          @"—",
          @"mdash",
          @"‘",
          @"lsquo",
          @"’",
          @"rsquo",
          @"",
          @"sbquo",
          @"“",
          @"ldquo",
          @"”",
          @"rdquo",
          @"„",
          @"bdquo",
          @"†",
          @"dagger",
          @"‡",
          @"Dagger",
          @"•",
          @"bull",
          @"…",
          @"hellip",
          @"‰",
          @"permil",
          @"′",
          @"prime",
          @"″",
          @"Prime",
          @"‹",
          @"lsaquo",
          @"›",
          @"rsaquo",
          @"‾",
          @"oline",
          @"⁄",
          @"frasl",
          @"€",
          @"euro",
          @"ℑ",
          @"image",
          @"℘",
          @"weierp",
          @"ℜ",
          @"real",
          @"™",
          @"trade",
          @"ℵ",
          @"alefsym",
          @"←",
          @"larr",
          @"↑",
          @"uarr",
          @"→",
          @"rarr",
          @"↓",
          @"darr",
          @"↔",
          @"harr",
          @"↵",
          @"crarr",
          @"⇐",
          @"lArr",
          @"⇑",
          @"uArr",
          @"⇒",
          @"rArr",
          @"⇓",
          @"dArr",
          @"⇔",
          @"hArr",
          @"∀",
          @"forall",
          @"∂",
          @"part",
          @"∃",
          @"exist",
          @"∅",
          @"empty",
          @"∇",
          @"nabla",
          @"∈",
          @"isin",
          @"∉",
          @"notin",
          @"∋",
          @"ni",
          @"∏",
          @"prod",
          @"∑",
          @"sum",
          @"−",
          @"minus",
          @"∗",
          @"lowast",
          @"√",
          @"radic",
          @"∝",
          @"prop",
          @"∞",
          @"infin",
          @"∠",
          @"ang",
          @"∧",
          @"and",
          @"∨",
          @"or",
          @"∩",
          @"cap",
          @"∪",
          @"cup",
          @"∫",
          @"int",
          @"∴",
          @"there4",
          @"∼",
          @"sim",
          @"≅",
          @"cong",
          @"≈",
          @"asymp",
          @"≠",
          @"ne",
          @"≡",
          @"equiv",
          @"≤",
          @"le",
          @"≥",
          @"ge",
          @"⊂",
          @"sub",
          @"⊃",
          @"sup",
          @"⊄",
          @"nsub",
          @"⊆",
          @"sube",
          @"⊇",
          @"supe",
          @"⊕",
          @"oplus",
          @"⊗",
          @"otimes",
          @"⊥",
          @"perp",
          @"⋅",
          @"sdot",
          @"⋮",
          @"vellip",
          @"⌈",
          @"lceil",
          @"⌉",
          @"rceil",
          @"⌊",
          @"lfloor",
          @"⌋",
          @"rfloor",
          @"〈",
          @"lang",
          @"〉",
          @"rang",
          @"◊",
          @"loz",
          @"♠",
          @"spades",
          @"♣",
          @"clubs",
          @"♥",
          @"hearts",
          @"♦",
          @"diams",nil];
}

@end
