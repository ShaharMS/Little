# Minilang

### What is it?

Minilang is a super simple and basic language that can be used to teach children how to program.

The language isn't very feature-rich, but it can be used to create lots of (minimal) things with ease.

Because of the minimal and simple nature of this language, you don't have to write it's source code specifically in English.

### How does it compile then?
After code compilation has started, the language will try to detect if any other language that isn't English is used. If found, the language will translate the code over to english via a different compiler. you can read about that second compiler down below.

Now, when the code is in English, the main compiler gets to do its job, in steps

1. **Desugering**
   - **naming conventions** - to avoid naming conflicts, variables named by a keyword, or TitleCased variables will throw a detailed exception and lowercase the first char, rezpectively.
1. **Condensing**
   - **variable condensing** - variables only used once which never change values will get their value inlined
   - **equation condensing** - simplifies math equations to their shortest form, taking variable values into account

