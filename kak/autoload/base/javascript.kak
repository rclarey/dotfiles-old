# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](js) %{
    set buffer filetype javascript
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter -group / regions -default code javascript \
    double_string '"'  (?<!\\)(\\\\)*"         '' \
    single_string "'"  (?<!\\)(\\\\)*'         '' \
    literal       "`"  (?<!\\)(\\\\)*`         '' \
    comment       //   '$'                     '' \
    comment       /\*  \*/                     '' \
    regex         /    (?<!\\)(\\\\)*/[gimuy]* '' \
    tag           <[a-zA-Z].*?(((?<!\\)(\\\\)*['"}]|\s)>|(?=\/>))  <\/[a-zA-Z][\w.$]*?>|\/>  <[a-zA-Z].*?(((?<!\\)(\\\\)*['"}]|\s)>|(?=\/>)) \
    division '[\w\)\]](/|(\h+/\h+))' '\w' '' # Help Kakoune to better detect /…/ literals

# Regular expression flags are: g → global match, i → ignore case, m → multi-lines, u → unicode, y → sticky
# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp


add-highlighter -group /javascript/double_string fill string
add-highlighter -group /javascript/single_string fill string
add-highlighter -group /javascript/regex         fill meta
add-highlighter -group /javascript/comment       fill comment
add-highlighter -group /javascript/literal       fill string
add-highlighter -group /javascript/literal       regex \${.*?} 0:variable
add-highlighter -group /javascript/tag           regex (((?<=<\/)|(?<=<))[A-Za-z][\w.$]*?(?=\s|>))|((?<=\s)[A-Za-z][\w$]*?(?==))|((?<==)["'{](.|\n)*?(?<!\\)(\\\\)*["'}]) 1:attribute 3:function 4:string   

add-highlighter -group /javascript/code regex \b(document|false|null|parent|self|this|true|undefined|window|Infinity|NaN)\b 0:value
add-highlighter -group /javascript/code regex "-?[0-9]*\.?[0-9]+" 0:value
add-highlighter -group /javascript/code regex \b(Array|Boolean|arguments|module|Date|Function|Number|Object|RegExp|String|Error|EvalError|InternalError|RangeError|ReferenceError|SyntaxError|TypeError|URIError|Math|Int8Array|Uint8Array|Uint8ClampedArray|Int16Array|Uint16Array|Float32Array|Float64Array|Map|Set|WeakMap|WeakSet|ArrayBuffer|DataView|JSON|Promise|Generator|GeneratorFunction|Reflect|Proxy|Intl|WebAssembly)\b 0:type
add-highlighter -group /javascript/code regex (?<=\.)(prototype|constructor|BYTES_PER_ELEMENT|buffer|byteLength|byteOffset|caller|columnNumber|compare|displayName|E|EPSILON|fileName|flags|format|get|global|hasInstance|ignoreCase|input|isConcatSpreadable|iterator|LN10|LN2|LOG10E|LOG2E|lastIndex|lastMatch|lastParen|leftContext|length|lineNumber|MAX_SAFE_INTEGER|MAX_VALUE|MIN_SAFE_INTEGER|MIN_VALUE|match|message|multiline|NEGATIVE_INFINITY|NaN|name|PI|POSITIVE_INFINITY|prototype|replace|rightContext|SQRT1_2|SQRT2|search|size|source|species|split|stack|sticky|toPrimitive|toStringTag|unicode|unscopables)\b 0:value
add-highlighter -group /javascript/code regex (?<=\s)[$A-Z_][$A-Z0-9_]*[A-Z][$A-Z0-9_]* 0:value
add-highlighter -group /javascript/code regex (?<=\s)[$A-Za-z_][$\w]* 0:variable
add-highlighter -group /javascript/code regex \$*\b[$\w]+(?=\() 0:function

# Keywords are collected at
# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Keywords
add-highlighter -group /javascript/code regex \b(break|case|catch|class|const|continue|debugger|default|delete|do|else|export|extends|finally|for|function|if|import|in|instanceof|let|new|of|return|super|switch|throw|try|typeof|var|void|while|with|yield|from|as)\b 0:keyword
add-highlighter -group /javascript/code regex \+|=|\||&|!|%|\^|\*|:|\?|<|>|-|\.\.\. 0:operator

# Commands
# ‾‾‾‾‾‾‾‾

def -hidden javascript-filter-around-selections %{
    # remove trailing white spaces
    try %{ exec -draft -itersel <a-x> s \h+$ <ret> d }
}

def -hidden javascript-indent-on-char %<
    eval -draft -itersel %<
        # align closer token to its opener when alone on a line
        try %/ exec -draft <a-h> <a-k> ^\h+[]}]$ <ret> m s \`|.\' <ret> 1<a-&> /
    >
>

def -hidden javascript-indent-on-new-line %<
    eval -draft -itersel %<
        # copy // comments prefix and following white spaces
        try %{ exec -draft k <a-x> s ^\h*\K#\h* <ret> y gh j P }
        # preserve previous line indent
        try %{ exec -draft \; K <a-&> }
        # filter previous line
        try %{ exec -draft k : javascript-filter-around-selections <ret> }
        # indent after lines beginning / ending with opener token
        try %_ exec -draft k <a-x> <a-k> ^\h*[[{]|[[{]$ <ret> j <a-gt> _
    >
>

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook -group javascript-highlight global WinSetOption filetype=javascript %{ add-highlighter ref javascript }

hook global WinSetOption filetype=javascript %{
    hook window InsertEnd  .* -group javascript-hooks  javascript-filter-around-selections
    hook window InsertChar .* -group javascript-indent javascript-indent-on-char
    hook window InsertChar \n -group javascript-indent javascript-indent-on-new-line
}

hook -group javascript-highlight global WinSetOption filetype=(?!javascript).* %{ remove-highlighter javascript }

hook global WinSetOption filetype=(?!javascript).* %{
    remove-hooks window javascript-indent
    remove-hooks window javascript-hooks
}
