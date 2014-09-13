Title: Dynamic Programming at ease
Date: 2014-09-13 16:08

Once upon a time I was a student in bioinformatics and was learning about Dynamic Programming. Back in the day, this was a complicated and error-prone task. 
In brief, [Dynamic Programming](http://en.wikipedia.org/wiki/Dynamic_programming) is a style of programming that enables us to solve optimization problems that are computationally complex. If you dont know about Dynamic Programming yet, don't worry too much, we are learning about it along the way, and the way in which we talk about it will be new for everybody.
Also, don't get confused by the term "Dynamic" in the name of the method, it is just there for historical reasons.

In order to speed up a computation, in Dynamic Programming we save intermediate results in a table to be able to reuse them in the computation. That often leads to very complicated code, containing both the algorithm and the table access code via index access or subscripts when written down as a formula. Due to the combinatorial nature of the problem, these formulas are recursive, and are called recurrences.
Every day I had to face new complex recurrences full of subscripts for table access, and trying to implement them and get the indices for table access right was a matter of experience, talent and luck!

One day, a group from Bielefeld found out that all the intertwined aspects of dynamic programming can be modularized to make it easier to reason about such problems.
All the aspects of solving a combinatorial optimization problem include modular steps, such as the reading of the input for the problem, building of the search space, evaluating the candidates in the search space, and selecting the desired optimal solution. Deciding which parts of the formulas we should tabulate, and also filling and accesssing the tables are a completely separate problem as well.

A dynamic programming problem works, *because* we do all the above steps at the same time.
That means *while* we are constructing the search space, we are at the same time evaluating and possibly throwing out search space candidates, if their score is not optimal.
So we see there is a lot going on in classical Dynamic Programming, and this can for sure be overwhelming!

Lets modularize it and talk about all the separate parts!

# Part 1
### The Signature: Candidates are trees

How does the construction of the search space actually work when we develop a dynamic programming algorithm?
Let's imagine we are reading in strings as input.
Let's also pretend we don't know anything about dynamic programming at all.
But we have the magic ability to see the candidate construction at each step.
In this way we can reverse engineer a dynamic programming algorithm from the format of the candidates, and -boom- we developed an algorithm.

Let's reverse engineer an alignment of two strings.

# Part 2
### The Algebra: Questions are algebras

# Part 3
### The Grammar: Programs are grammars
