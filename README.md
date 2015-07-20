# Brainfuck

Example:

```ruby
require 'stringio'
require './bf'

src = ',>,>++++++[<-------->-]<<[>+<-]>.'
Brainfuck.run(src, input: StringIO.new('34'))  # 7
```

```ruby
require 'stringio'
require './bf'

program = Brainfuck.build do
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

Brainfuck.reverse_parse(program)  #=> ',>,>++++++[<-------->-]<<[>+<-]>.'

Brainfuck.execute(program, input: StringIO.new('45'))  # 9
```