# Little

### What is it?

**Little** is a simple programming language that can be used to teach children how to program.

The language is designed to be as international as possible - names of variables & actions allow non-english characters, and keywords can be changed to anything, including phrases in other languages (as long as they don't contain any spaces)

The language itself is cross-platform, as it's programmed in haxe.

### Why does this programming language exist?

Other than teaching, the language has a lot of benefits, some I already mentioned before:

 - cross platform
 - small bundle size
 - fast interpreter
 - Multilingual coding
 - interfaces with external Haxe code (Haxe transpiler only)
 - makes it easy to implement code interfacing in games
 - Understandable errors that actually explain what went wrong and where
 - easy and accurate access to runtime details & definition values

## Syntax

The language is very minimal by design, and only has a couple of reserved words:

**Notice - the language is still in development, syntax may change in the future**

 - **`define`** - used for defining variables.
 - **`action`** - used for defining functions.
 - **`as`** - used for expression typing, for example: `define x as Number`
 - **`return`** used for returning action values.
 - **`nothing`** - the language's `null` value.

The resereved words' translations may change a bit across different languages to make programming more intuitive, and to keep the same code structure.

## Language Features

### Keyword & Standard Library Modification

Want to change up the keywords to ones that are quicker to type?  
Maybe even change everything up to a whole new language?

#### You're Welcome!
**Examples:**

Alternative names:
<table>
    <tr>
        <td>
        define x = 3, x = x + 6<br>action getX() = {<br>&nbsp;&nbsp;&nbsp;&nbsp;return x<br>}<br>print(getX())
        </td>
        <td>
        var x = 3, x = x + 6<br>fun getX() = {<br>&nbsp;&nbsp;&nbsp;&nbsp;ret x<br>}<br>log(getX())
        </td>
    </tr>
</table>

Different languages (English, Hebrew, Arabic):
<table>
    <tr>
        <td>
        define x = 3, x = x + 6<br>action getX() = {<br>&nbsp;&nbsp;&nbsp;&nbsp;return x<br>}<br>print(getX())
        </td>
        <td>
        הגדר ס = 3, ס = ס + 6<br>פעולה קבל_ס() = {<br>&nbsp;&nbsp;&nbsp;&nbsp;החזר ס<br>}<br>הדפס(קבל_ס())
        </td>
        <td>
        السياج ع = 3, ع = ع + 6<br>فعل يحصل_ع() = {<br>&nbsp;&nbsp;&nbsp;&nbsp;استرداد ع<br>}<br>مطبعة(يحصل_ع())
        </td>
    </tr>
</table>

---

### Everything can be a code block

Code blocks, represented by enclosing lines of code/expressions with (by default) curly brackets, can be used for everything! From:
 - expression generation:
```
x = {define y = 0; y += 5; (6^2 * y)} //180
```

---

### Consistency is key!

everything is always consistent!
```
define consistent = 5
define consistent.newPropertyDeclaration = 6

action declaredJustLikeVariables(define parametersAreDefinedTheSame = 6) = {
    print("Function Bodies are also assigned using `=`")
}

for (define i from 0 to 1) {
    print("And for loop variables are also declared like normal variables.");
}
```
---

## Examples

### Define Variables & Functions
```hx
define hey = 3

action getHey(define negative as Boolean) {
    // if negative is false, negative.toNumber() is 0, and the positive is returned (hey - 0).
    return hey - (hey * negative.toNumber() * 2) 
}
```

### While Loops & If statements
```hx
define i = 0
while (i <= 10) {
    print(i) //0, 2, 4, 6, 8, 10
    i = i + 2
}

if (i == 9) {
    print("How?")
}
```

### For Loops
```hx
for (define i from 0 to 4) {
    print(i)
}

for (define j from 0 to 20 jump 5) {
    print(j) //0, 5, 10, 15
}
```

### Whenever & after events
```hx
define i = 2
after (i >= 5) {
    print("i is " + i + "!")
}
whenever (i >= 3) {
    print("woah")
}
i = i + 1 //woah
i = i + 1 //woah
i = i + 1 //woah, i is 5!
i = i + 1 //woah
```