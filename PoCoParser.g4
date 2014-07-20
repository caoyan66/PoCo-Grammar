/*
 * PoCo Grammar
 */


parser grammar PoCoParser;
options { tokenVocab=PoCoLexer; }

ppol:       id LPAREN paramlist RPAREN COLON vardecls macrodecls execution trans|
            id LPAREN paramlist RPAREN COLON vardecls macrodecls execution |
            id LPAREN paramlist RPAREN COLON macrodecls execution |
            id LPAREN paramlist RPAREN COLON vardecls execution |
            id LPAREN paramlist RPAREN COLON macrodecls execution trans|
            id LPAREN paramlist RPAREN COLON vardecls execution trans|
            id LPAREN paramlist RPAREN COLON execution trans |
            id LPAREN paramlist RPAREN COLON execution ;
            // TODO: Add support in ppol for Main() syntax.


trans:      DOT MAIN DOT ;
            // TODO: Flesh out trans rule so it is not a placeholder.

macrodecls: macrodecl |
            macrodecls macrodecl ;

macrodecl:  AT id LPAREN idlist RPAREN LBRACKET sre RBRACKET COLON SRETYPE |
            AT id LPAREN idlist RPAREN LBRACKET srecase RBRACKET COLON SRETYPE |
            AT id LBRACKET srecase RBRACKET COLON SRETYPE |
            AT id LBRACKET sre RBRACKET COLON SRETYPE |
            AT id LPAREN idlist RPAREN LBRACKET LTICK re APOSTROPHE RBRACKET COLON RETYPE |
            AT id LPAREN idlist RPAREN LBRACKET BOOLUOP LTICK re APOSTROPHE RBRACKET COLON RETYPE |
            AT id LBRACKET LTICK re APOSTROPHE RBRACKET COLON RETYPE |
            AT id LBRACKET BOOLUOP LTICK re APOSTROPHE RBRACKET COLON RETYPE ;

vardecls:   vardecl |
            vardecls vardecl ;

vardecl:    VAR id COLON RETYPE |
            VAR id COLON SRETYPE ;

srecase:    matchs ARROW sre |
            srecase BAR matchs ARROW sre |
            AT id LBRACKET LTICK re APOSTROPHE RBRACKET ;

idlist:     id |
            idlist COMMA id ;

paramlist:  qid id |
            paramlist COMMA qid id |
            paramlist COMMA qid DOT DOT DOT id |
            ;

execution:  exch |
            execution execution |
            LPAREN execution RPAREN |
            execution BAR execution |
            execution ASTERISK |
            execution PLUS |
            map ;

map:        MAP LPAREN srebop COMMA sre COMMA execution RPAREN |
            MAP LPAREN DOLLAR id COMMA sre COMMA execution RPAREN ;

exch:       OPEN matchs ARROW sre CLOSE |
            OPEN INPUTWILD ARROW sre CLOSE |
            DOLLAR id |
            pinst ;

pinst:      id LPAREN RPAREN |
            id LPAREN args RPAREN ;

args:       object |
            args COMMA object ;

object:     POUND qid LBRACE re RBRACE |
            NULL |
            DOLLAR id |
            POUND qid LBRACE fieldlist RBRACE ;

fieldlist:  SYM COLON re |
            fieldlist COMMA SYM COLON re  ;


// match had to be split up to eliminate left-recursion

matchs:     BOOLUOP matchs |
            matchs BOOLBOP matchs |
            LPAREN matchs RPAREN  |
            match ;

match:      ire |
            AT id LBRACKET LTICK re APOSTROPHE RBRACKET |
            SUBSET LPAREN sre COMMA sre RPAREN |
            INFINITE LPAREN sre RPAREN |
            EQUALS LPAREN sre COMMA sre RPAREN ;


ire:        ACTION LPAREN LTICK re APOSTROPHE RPAREN |
            RESULT LPAREN LTICK re APOSTROPHE COMMA LTICK re APOSTROPHE RPAREN ;

sre:        (PLUS | MINUS) LTICK re APOSTROPHE |
            NEUTRAL |
            LPAREN sre RPAREN |
            DOLLAR qid LPAREN RPAREN |
            DOLLAR qid |
            srebop LPAREN sre COMMA sre RPAREN |
            sreuop LPAREN sre RPAREN           |
            FOLD LPAREN DOLLAR ID COMMA DOLLAR ID COMMA sre RPAREN;

sreunion:   SREUNION ;

sreconj:    SRECONJ ;

sredisj:    SREDISJ ;

sreequals:  SREEQUALS ;

srepunion:  SREPUNION ;

srebop:     sreunion |
            sreconj |
            sredisj |
            sreequals |
            srepunion ;

srecomp:    SRECOMP ;

sreactions: SREACTIONS ;

sreresults: SRERESULTS ;

srepos:     SREPOS ;

sreneg:     SRENEG ;

sreuop:     srecomp |
            sreactions |
            sreresults |
            srepos |
            sreneg ;

id:         ID ;

qid:        id |
            qid DOT id ;


opparamlist:    re  |
                sre |
                opparamlist COMMA re  |
                opparamlist COMMA sre ;



re:         rewild |
            DOLLAR qid LPAREN opparamlist RPAREN |
            DOLLAR qid |
            function |
            object |
            LPAREN re RPAREN |
            LPAREN RPAREN |
            AT id LBRACKET re RBRACKET |
            INIT |
            SYM+ |
            re reuop |
            re rebop re ;

function:   fxnname INIT LPAREN arglist RPAREN |
            fxnname LPAREN arglist RPAREN ;

fxnname:    SYM+ |
            object |
            object SYM+ ;

arglist:    re |
            arglist COMMA re |
            ;

rebop:      BAR |
            ;

reuop:      ASTERISK |
            PLUS |
            QUESTION ;

rewild:     REWILD ;
