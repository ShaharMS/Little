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
 - interfaces with external H⁹axe code (Haxe transpiler only)
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

### Everything can be a code block

Code blocks, represented by enclosing lines of code/expressions with (by default) curly brackets, can be used for everything! From:
 - expression generation:
```
x = {define y = 0; y += 5; (6^2 * y)} //180
```
