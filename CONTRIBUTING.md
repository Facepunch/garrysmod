Contributing to the Garry's Mod repository
=============
Here's what you need to know if you wish to submit Pull Requests to this repository.

Code Formatting
=============
* Your code formatting must be consistent with the rest of the code base
  * Always put brackets around if-statements 
    * ```if ( ( expression1 or expression2 ) and expression3 ) then end```
  * Spaces around operators and inside brackets
    * ```if ( expression1 == expression2 ) then myVariable = ( 1 + 2 ) / 4 end```
  * Use `Tab` characters to indent your code, not spaces. Indent size is 1 Tab = 4 spaces
  * Preferred casing is UpperCamelCase for function names, and lowerCamelCase for variable and argument names
    * ```local myResult = MyObject:MyMethod( myArgument )```
    * Do not include type in the variable name
  * An empty line both at the start and at the end of a file, as well as the first and last lines of a function
* Do not add unnecessary changes to your code - do not "fix" white space or remove comments
  * Keep your diffs as simple as possible for highest chance of your proposal being accepted

Trouble In Terrorist Town
=============
Any TTT changes in Pull Requests should be separate. Do not combine TTT changes and other base lua changes in the same PR.
