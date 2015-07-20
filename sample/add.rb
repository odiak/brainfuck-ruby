require 'stringio'
require '../bf'

prog = Brainfuck.build do
  input
  forward
  input
  forward

  increment 6
  while_nonzero {
    back
    decrement 8
    forward
    decrement
  }

  back 2
  while_nonzero {
    forward
    increment
    back
    decrement
  }
  forward
  output
end
Brainfuck.execute(prog, input: StringIO.new('36'))
