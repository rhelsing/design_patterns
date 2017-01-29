def run_it
  puts("Before the yield")
  yield("DUDE")
  puts("After the yield")
end

run_it do |x|
  puts("Hello #{x}")
  puts('Coming to you from inside the block')
end
