require 'stringio'
require '../bf'

prog = Brainfuck.build do
  increment # @0 = 1

  while_nonzero { # while @0 != 0
    forward
    input # @1

    # copy @1 -> @2
    while_nonzero {
      decrement
      forward
      increment
      forward
      increment
      back 2
    }
    forward 2
    while_nonzero {
      decrement
      back 2
      increment
      forward 2
    }

    # @2 -= 10
    increment 2 # @3 == 2
    while_nonzero {
      decrement
      back
      decrement 5
      forward
    }

    increment # @3 == 1
    back
    # @2

    # if @2 != 0
    while_nonzero {
      forward
      decrement # @3 == 0
      back 2
      output
      forward
      while_nonzero {
        decrement
      }
    }
    # else
    forward # @3
    while_nonzero {
      back 3
      decrement
      forward 3
      decrement
    }
    back 3
  }
end

_debug = false
Brainfuck.execute(prog, input: StringIO.new("abcd\nefgh"), debug: _debug)
