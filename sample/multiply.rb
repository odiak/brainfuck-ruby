require '../bf'

prog = Brainfuck.build do
  input
  forward
  increment 6
  while_nonzero {
    back
    decrement 8
    forward
    decrement
  }

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
    while_nonzero {
      forward
      increment
      forward
      increment
      back 2
      decrement
    }
    forward
    while_nonzero {
      back
      increment
      forward
      decrement
    }
    back 2
    decrement
  }
  forward 3
  output
end

Brainfuck.execute(prog, debug: true)
