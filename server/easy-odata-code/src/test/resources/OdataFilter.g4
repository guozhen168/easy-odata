grammar OdataFilter;

options {
    language=Java;
}
@header {
package com.tang.easyodata.code.parser.ast;
}

odataFilter: criteriaExpression;

// O 为意大利语的“或”
criteriaExpression: (criteriaIterm) (('OR'|'or'|'O'|'o') criteriaIterm)*
;
// E 为意大利语的“和”
criteriaIterm: (criteriaFactor) (('AND'|'and'|'E'|'e') criteriaFactor)*
;

criteriaFactor: simpleCriteria
            | '(' criteriaExpression ')'
;
simpleCriteria: criteriaLike
            | criteriaEndswith
            | criteriaStartswith
            | criteriaNotLike
            | criteriaOther
;

criteriaLike: ('substringof('|'contains(') STRING ',' field ')'
;

criteriaEndswith: 'endswith(' STRING ',' field ')'
;

criteriaStartswith: 'startswith(' STRING ',' field ')'
;

criteriaNotLike: 'indexof(' field ',' STRING ') eq -1'
;

criteriaOther: field operate value
;

field: WORD;

operate: 'eq'|'ne'|'gt'|'ge'|'lt'|'le'|'ni'|'in'
;

value: STRING
    | NUMBER
    | DATATIME
    | 'true' | 'false'
    | 'null'
;

WORD: ([a-zA-Z0-9_./+])+ ;

DATATIME: ('datetime\'' (~ '\'')+ '\'') ;

STRING: ('\'' (~ '\'')* '\'') ;

NUMBER
   : '-'? INT ('.' [0-9] +)? EXP?
   ;

fragment INT
   : '0' | [1-9] [0-9]*
   ;

// no leading zeros

fragment EXP
   : [Ee] [+\-]? INT
   ;

// \- since - means "range" inside [...]
WS
  : [ \t\n\r,] + -> skip
  ;

