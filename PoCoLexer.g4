lexer grammar PoCoLexer;

// LEXER RULES

WS:         [ \t\r\n]+ -> skip ;
BOOLBOP:    ('&&'|'||') ;
BOOLUOP:    ('!') ;
NULL:       'null' ;
ASTERISK:   '*' ;
QUESTION:   '?' ;
COLON:      ':' ;
OPEN:       '<' ;
CLOSE:      '>' ;
ARROW:      '=>' ;
BAR:        '|' ;
INPUTWILD:  '_' ;
PLUS:       '+' ;
MINUS:      '-' ;
POUND:      '#' ;
NEUTRAL:    'Neutral' ;
MAIN:       'Main' ;
VAR:        'var' ;
DOT:        '.' ;
LPAREN:     '(' ;
RPAREN:     ')' ;
LBRACE:     '{' ;
RBRACE:     '}' ;
MAP:        'map' ;
COMMA:      ',' ;
AT:         '@' ;
RBRACKET:   ']' ;
LBRACKET:   '[' ;
DOLLAR:     '$' ;
LTICK:      '`' -> pushMode(INSIDERE) ;

SRETYPE:    'SRE' ;
RETYPE:     'RE' ;

// SRE Binary Operators:
SREUNION:   'Union' ;
SRECONJ:    'Conjunction' ;
SREDISJ:    'Disjunction' ;
SREEQUALS:  'Equals' ;
SREPUNION:  'Punion' ;

// SRE Unary Operators:
SRECOMP:    'Complement' ;
SREACTIONS: 'Actions' ;
SRERESULTS: 'Results' ;
SREPOS:     'Positive' ;
SRENEG:     'Negative' ;

SUBSET:     'Subset' ;
INFINITE:   'Infinite' ;
EQUAL:     'Equal' ;
ACTION:     'Action' ;
RESULT:     'Result' ;

ID:         [a-zA-Z][a-zA-Z0-9_\-]* ;


mode INSIDERE;


INIT:       '<init>' ;
SYM:        ('\\' [`\[\]\?@%$\\\*\+:,\(\){}<>#\'\|] |  ~[`\[\]\?@%$\\\*\+:,\(\){}<>#\'\|])+ ;
RELPAREN:   '(' -> type(LPAREN) ;
RERPAREN:   ')' -> type(RPAREN) ;
RELBRACE:   '{' -> type(LBRACE) ;
RERBRACE:   '}' -> type(RBRACE) ;
REDOLLAR:   '$' -> type(DOLLAR), pushMode(REVAR) ;
REAT:       '@' -> type(AT), pushMode(REBIND) ;
APOSTROPHE: '\'' -> popMode ;
VARCLOSE:   ']' -> type(RBRACKET) ;
REASTERISK: '*' -> type(ASTERISK) ;
REPLUS:     '+' -> type(PLUS) ;
REQUESTION: '?' -> type(QUESTION) ;
REBOP:      '|' -> type(BAR);
REPOUND:    '#' -> type(POUND), pushMode(OBJECT) ;
RECOLON:    ':' -> type(COLON) ;
RECOMMA:    ',' -> type(COMMA) ;
REWILD:     '%' ;
NEST:       '`' -> type(LTICK), pushMode(INSIDERE) ;


mode REBIND;

ID2:        [a-zA-Z][a-zA-Z0-9_\-]* -> type(ID) ;
LEAVEVAR:   '[' -> type(LBRACKET), popMode ;


/* Lex $QID or $QID(OPPARAMLIST) structures. The ugly duplication of all
 * INSIDERE's tokens is required in case this does not appear at the end of an
 * RE.
 */
mode REVAR;

ID3:        [a-zA-Z][a-zA-Z0-9_\-]* -> type(ID) ;
DOT2:       '.' -> type(DOT) ;
REVARAPOSTR:'\'' -> type(APOSTROPHE), popMode, popMode ;
WS2:        [ \t\r\n] -> type(SYM), popMode ;
EXITVAR1:   '(' -> type(LPAREN), popMode ;
EXITVAR2:   ')' -> type(RPAREN), popMode ;
EXITVAR3:   '{' -> type(LBRACE), popMode ;
EXITVAR4:   '}' -> type(RBRACE), popMode ;
EXITVAR5:   ']' -> type(RBRACKET), popMode ;
EXITVAR6:   '*' -> type(ASTERISK), popMode ;
EXITVAR7:   '+' -> type(PLUS), popMode ;
EXITVAR8:   '?' -> type(QUESTION), popMode ;
EXITVAR9:   '|' -> type(BAR), popMode ;
EXITVAR10:  ':' -> type(COLON), popMode ;
EXITVAR11:  ',' -> type(COMMA), popMode ;
ESCAPED:    ('\\' [`\[\]\?@%$\\\*\+:,\(\){}<>#\'\|]) -> type(SYM), popMode ;

mode OBJECT;

ID4:        [a-zA-Z][a-zA-Z0-9_\-]* -> type(ID) ;
DOT3:       '.' -> type(DOT) ;
OBJLBRACE:  '{' -> type(LBRACE), popMode ;
