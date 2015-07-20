module Brainfuck
  FORWARD    = '>'.freeze
  BACK       = '<'.freeze
  INCREMENT  = '+'.freeze
  DECREMENT  = '-'.freeze
  OUTPUT     = '.'.freeze
  INPUT      = ','.freeze
  BEGIN_LOOP = '['.freeze
  END_LOOP   = ']'.freeze

  BUFFER_MAX = 255
  BUFFER_MIN = 0

  class << self
    def parse(code)
      i = 0
      prog = []
      loop_stack = []
      code.each_char do |c|
        case c
        when FORWARD
          prog.push({type: :forward})
        when BACK
          prog.push({type: :back})
        when INCREMENT
          prog.push({type: :increment})
        when DECREMENT
          prog.push({type: :decrement})
        when OUTPUT
          prog.push({type: :output})
        when INPUT
          prog.push({type: :input})
        when BEGIN_LOOP
          prog.push({type: :begin_loop, end: nil})
          loop_stack.push(i)
        when END_LOOP
          beg = loop_stack.pop
          fail "unexpected '#{END_LOOP}'" unless beg
          prog.push({type: :end_loop, begin: beg})
          prog[beg][:end] = i
        else
          next
        end
        i += 1
      end

      fail "expected ']'" unless loop_stack.empty?

      prog
    end

    def execute(prog, input: STDIN, output: STDOUT, debug: false)
      p = 0
      i = 0
      buf = []
      while i < prog.length
        inst = prog[i]

        if debug
          puts "# pos: #{p}, val: #{buf[p] || 0}, type: #{inst[:type]}"
          puts "# buf: #{buf}"
          puts
        end

        buf[p] ||= 0

        case inst[:type]
        when :forward
          p += 1
        when :back
          p -= 1
        when :increment
          buf[p] += 1
        when :decrement
          buf[p] -= 1
        when :output
          c = buf[p].chr
          if debug
            output.puts(c)
          else
            output.print(c)
          end
        when :input
          buf[p] = input.eof? ? 0 : input.readbyte
        when :begin_loop
          i = inst[:end] if buf[p] == 0
        when :end_loop
          i = inst[:begin] if buf[p] != 0
        end

        buf[p] ||= 0
        if buf[p] < BUFFER_MIN || buf[p] > BUFFER_MAX
          buf[p] = ((buf[p] - BUFFER_MIN) % (BUFFER_MAX - BUFFER_MIN + 1)) +
            BUFFER_MIN
        end

        # sleep 0.01

        i += 1
      end
    end

    def run(code, **opts)
      execute(parse(code), **opts)
    end

    def reverse_parse(prog)
      code = ''
      prog.each do |inst|
        c =
          case inst[:type]
          when :forward    then FORWARD
          when :back       then BACK
          when :increment  then INCREMENT
          when :decrement  then DECREMENT
          when :output     then OUTPUT
          when :input      then INPUT
          when :begin_loop then BEGIN_LOOP
          when :end_loop   then END_LOOP
          end
        code << c if c
      end
      code
    end

    def build(&block)
      builder = Builder.new
      builder.instance_eval(&block)
      builder.program
    end

    def build_and_execute(**opts, &block)
      execute(build(&block), **opts)
    end
  end

  class Builder
    attr_reader :program

    def initialize
      @program = []
      @i = 0
    end

    def push(inst)
      @program.push(inst)
      @i += 1
    end

    def forward(n = 1)
      n.times { push({type: :forward}) }
    end

    def back(n = 1)
      n.times { push({type: :back}) }
    end

    def increment(n = 1)
      n.times { push({type: :increment}) }
    end

    def decrement(n = 1)
      n.times { push({type: :decrement}) }
    end

    def output(n = 1)
      n.times { push({type: :output}) }
    end

    def input(n = 1)
      n.times { push({type: :input}) }
    end

    def while_nonzero
      i = @i
      push(inst = {type: :begin_loop, end: nil})
      yield
      inst[:end] = @i
      push({type: :end_loop, begin: i})
    end
  end
end