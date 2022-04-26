# Minilang

### What is it?

Minilang is a super simple and basic language that can be used to teach children how to program.

The language isn't very feature-rich, but it can be used to create lots of (minimal) things with ease.

Because of the minimal and simple nature of this language, you don't have to write it's source code specifically in English.

## Syntax

The language is very minimal by design, and only has a couple of reserved words:

 - **define** used for defining variables.
 - **action** used for defining functions.
 - **new** used for instances.
 - **return** used for returning action values.
 - **nothing** the language is always type safe by default, but this can be used to explicitly make a defenition throw an error when accessed.
 - **hide** disables access for instance fields

Examples:

```
define x = 5
define y = new ImprovedNumber(5)
y.increment(4)
print(y)

action increment(x:Number) = {
    return x + 1
}
```

Instances:

File name - ImprovedNumber
```
define baseNumber

action new(number:Number) = {
    baseNumber = number
}

//write comments with a double /!
// + types for actions are automatically inferred
action increment(x:Number) = {
    return baseNumber += x
}

hide action renew(number:Number) = {
    return new ImprovedNumber(number)
}
```
