# 3F7-FTR

## Base n arithmetic coding
This translates to having an _n_-ic interval instead of dyadic intervals.
Algorithm implemented as so:
* Both lo and hi lie in the same interval
The final interval will definitely lie in this interval 
  1. Output the number corresponding to that interval
  2. Shift lo and hi down by interval
  3. Multiply by  256
  4. Recalculate lo/hi by including next unencoded symbol...
* There is more than one interval between lo and hi
In this case, the range is not narrowed down enough to output a number, so have to include the next probability. 
  1. Break the loop without rescaling.
_This is where the difference in efficiency between binary 256-ary will come from? i.e. need more probabilities to narrow your range down to a sufficiently small region that it's worth storing as a multiple of 1/256^k; Shouldn't be an issue with very large n?_

* There is less than one interval between lo and hi BUT they don't lie within the same interval
  1. ???
_This is the equivalent of the straddling problem with binary arithmetic_


