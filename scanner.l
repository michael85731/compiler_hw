%{
 /* C defineition */
#include <stdlib.h>
void create();
char* lookup(char *target);
void insert(char *input);
void dump();

int lastLength = 0;
char lastInput[1000];
int lineCount = 1;
char symbolTable[1000][1000];
int symbolTableCounter = 0;
%}

/* State definitions*/
%s COMMENT

/* Format token definitions */
letters [A-Za-z]

digits [0-9]+
integer {digits}
plain_real {digits}"."{digits}
expreal {digits}"."{digits}[Ee][+-]?{digits}
real {plain_real}|{expreal}

%%
 /* Space ignore */
" " { /* Do nothing */ }

 /* Comment */
"/*" {
    BEGIN(COMMENT);
}

<COMMENT>{
"*/" { BEGIN(0); }
[^*\n]+
"*"
}

"//".* {

}

 /* Delimiters */

^.*\n {
    lastLength = yyleng;
    strcpy(lastInput, yytext);
    REJECT;
}

\n {
    printf("%d: %s", lineCount, lastInput);
    lineCount++;
}

, { printf("<','>\n"); }
: { printf("<':'>\n"); }
; { printf("<';'>\n"); }
\( { printf("<'('>\n"); }
\) { printf("<')'>\n"); }
\[ { printf("<'['>\n"); }
\] { printf("<']'>\n"); }
\{ { printf("<'{'>\n"); }
\} { printf("<'}'>\n"); }

 /* Keywords */
bool { printf("<BOOL>\n"); }
break { printf("<BREAK>\n"); }
char { printf("<CHAR>\n"); }
continue { printf("<CONTINUE>\n"); }
do { printf("<DO>\n"); }
else { printf("<ELSE>\n"); }
enum { printf("<ENUM>\n"); }
extern { printf("<EXTERN>\n"); }
false { printf("<FALSE>\n"); }
float { printf("<FLOAT>\n"); }
for { printf("<FOR>\n"); }
fn { printf("<FN>\n"); }
if { printf("<IF>\n"); }
in { printf("<IN>\n"); }
int { printf("<INT>\n"); }
let { printf("<LET>\n"); }
loop { printf("<LOOP>\n"); }
match { printf("<MATCH>\n"); }
mut { printf("<MUT>\n"); }
print { printf("<PRINT>\n"); }
println { printf("<PRINTLN>\n"); }
pub { printf("<PUB>\n"); }
return { printf("<RETURN>\n"); }
self { printf("<SELF>\n"); }
static { printf("<STATIC>\n"); }
str { printf("<STR>\n"); }
struct { printf("<STRUCT>\n"); }
true { printf("<TRUE>\n"); }
use { printf("<USE>\n"); }
where { printf("<WHERE>\n"); }
while { printf("<WHILE>\n"); }

 /* Operators */
\+ { printf("<'+'>\n"); }
- { printf("<'-'>\n"); }
\* { printf("<'*'>\n"); }
\/ { printf("<'/'>\n"); }
\+\+ { printf("<'++'>\n"); }
-- { printf("<'--'>\n"); }
% { printf("<'%%'>\n"); }
\< { printf("<'<'>\n"); }
\<= { printf("<'<='>\n"); }
\>= { printf("<'>='>\n"); }
\> { printf("<'>'>\n"); }
== { printf("<'=='>\n"); }
!= { printf("<'!='>\n"); }
&& { printf("<'&&'>\n"); }
\|\| { printf("<'||'>\n"); }
! { printf("<'!'>\n"); }
= { printf("<'='>\n"); }
\+= { printf("<'+='>\n"); }
-= { printf("<'-='>\n"); }
\*= { printf("<'*='>\n"); }
\/= { printf("<'/='>\n"); }

 /* String */
\"{letters}.*\" { printf("<STRING: %s>\n", yytext); }

 /* Numbers */
{integer} { printf("<INTEGER>\n"); }
{plain_real} { printf("<PLAINREAL>\n"); }
{expreal} { printf("<EXPREAL>\n"); }
 /* {real} { printf("<REAL>\n"); } */

 /* Identifiers */
{letters}(({letters}|{digits})*)? { 
    printf("<ID: %s>\n", yytext);
    insert(yytext);
}

%%
char* lookup(char* target){
    int index = -1;
    char *result = " ";

    for(int i=0;i<symbolTableCounter;i++){
        if(strcmp(target, symbolTable[i]) == 0){
            index = i;
            break;
        }
    }

    if(index < 0){
        result = "nil";
    }else{
        char temp[20];
        sprintf(temp, "%d", index);
        result = temp;
    }

    return result;
}

void insert(char* input){
    strcpy(symbolTable[symbolTableCounter], yytext);
    symbolTableCounter++;
}

void dump(){
    for(int i=0;i<symbolTableCounter;i++){
        printf("%s\n", symbolTable[i]);
    }
    for(int j=0;j<1000;j++){
        strcpy(symbolTable[j], "");
    }
    symbolTableCounter = 0;
}
int main(){
    yylex();
    //printf("\nLine Count: %d\n", lineCount);
    printf("\nSymbol Table:\n", lineCount);
    dump();
}