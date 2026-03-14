There are four key elements to defensive database programming that, when applied, will allow you to eliminate bugs and make your code less vulnerable to be being subsequently broken by cases of unintended use.

1. Define and understand your assumptions.
2. Test as many use cases as possible.
3. Lay out your code in short, fully testable, and fully tested modules.
4. Reuse your code whenever feasible, although we must be very careful when we reuse T-SQL code, as described in Chapter 5.

As noted in the introduction to this book, while I will occasionally discuss the sort of checks and tests that ought to be included in your unit tests (Steps 2 and 3), this book
is focused on defensive programming, and so, on the rigorous application of the first
two principles.