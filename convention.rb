#Convention over config stands in contrast to all design patterns, warning us to find a middle ground and not over engineer with design patterns as our only guide.

# If you have no use for it, flexibility becomes a danger. All those names and associations become just another way to screw up.

#Good UX:

# 1. Anticipate Needs

# If the user wants to do it (whatever it is) a lot, it is the default.
# A more considerate interface would make the more common case easy, while requiring somewhat more work for the less common case.

# Let Them Say It Once

# Provide a Template

class MessageGateway
  def initialize
    load_adapters
  end
  def process_message(message)
    adapter = adapter_for(message)
    adapter.send_message(message)
  end
  def adapter_for(message)
    protocol = message.to.scheme
    adapter_class = protocol.capitalize + 'Adapter'
    adapter_class = self.class.const_get(adapter_class)
    adapter_class.new
  end
  def load_adapters
   lib_dir = File.dirname(__FILE__)
   full_pattern = File.join(lib_dir, 'adapter', '*.rb')
   Dir.glob(full_pattern).each {|file| require file }
 end
end

# the convention focuses squarely on making it easy to add adapters.
# We did not try to make the whole message gateway easily extensible in every dimension;
# we just tried to make it easy to add new adapters. Why? Because we anticipate that adding
# new adapters is what our users (i.e., the future adapter-writing engineers) will need to do.

#additionally, create a scaffold generator!

#making extensibility easy and assuming defaults
