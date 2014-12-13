/* description: Parses a post declaration. */

/* lexical grammar */
%lex
%%

\s+                                               /* skip whitespace */
\n|\r                                             /* skip whitespace */
'"'("\\"["]|[^"])*'"'                             return 'STRING'
"'"('\\'[']|[^'])*"'"                             return 'STRING'
\[(["]("\\"["]|[^"])*["](\,\s)?)+\]               return 'TAGS'
([0-9]{4}\-[0-9]{2}\-[0-9]{2}T[0-9]{2}\:[0-9]{2}) return 'DATETIME'
(true)|(false)                                    return 'BOOL'
JADE[\s\S]+?JADE\;                                return 'JADE'
':'                                               return ':'
\<\!\-\-\s[a-z]+\s\-\-\>                          return 'HTMLIDENT'
[a-zA-Z]+                                         return 'WORD'
<<EOF>>                                           return 'EOF'
.                                                 return 'INVALID'

/lex

%start start

/* declarations */

%{

    function pair(key, value) {
        obj = {};
        obj[key] = value;
        return obj;
    }

    function merge(a, b) {
        for(var key in b) {
            a[key] = b[key];
        }

        return a;
    }

    function strip($s) {
        return $s.replace(/(^[\"\']|[\"\']$)/g, '');
    }

    function parseDate($d) {
        var date = new Date($d);
        if (date.toString() === 'Invalid Date') {
            throw date.toString();
        }
        return date;
    }

    function parseBool($b) {
        if ($b === 'false') {
            return false;
        } else if ($b === 'true') {
            return true;
        }
    }

    function stripHtmlIdent($s) {
        $s = $s.match(/<!--(.*)-->/);
        $s = $s[1].trim();
        return $s;
    }

    function cleanJADE($s) {
        return $s.replace(/(^JADE\n|\nJADE\;$)/g, '');
    }

%}

%% /* language grammar */

start  : declaration EOF {return $1;};

declaration : declaration keyval
                {$$ = merge($1, $2);}
            | keyval
            ;

keyval : key ':' val {$$ = pair($1, $3);}
       | key val {$$ = pair($1, $2);}
       ;

key : HTMLIDENT {$$ = stripHtmlIdent($1);}
    | WORD
    ;

val : STRING {$$ = strip($1);}
    | DATETIME {$$ = parseDate($1);}
    | BOOL {$$ = parseBool($1);}
    | TAGS {$$ = JSON.parse($1);}
    | JADE {$$ = cleanJADE($1);}
    ;
