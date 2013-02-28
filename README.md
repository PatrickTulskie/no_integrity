# NoIntegrity

## What is This?

Simple hash serialization with loose type coercion.  Built for ActiveRecord models, but does not rely specifically on anything from Rails.

## How do I use it?

For starters, throw this in your Gemfile:

    gem "no_integrity"
    
Then, add this to your class:

    class MrArbitrary < ActiveRecord::Base
      include NoIntegrity
  
      attr_accessor :some_random_hash
  
      no_attr_store :some_random_hash
      no_attribute :misc
      no_attribute :hair => 'String'
      no_attribute :age => 'Integer'
      no_attribute :height => 'String', :eyes => 'String', :friendly => 'Boolean'
      no_attribute [:cheese, :ham, :balogne]
    end
    
Finally, you can make calls like this:

    arbs = MrArbitrary.new
    arbs.friendly? # => false
    arbs.friendly = true
    arbs.friendly? # => true
    
You can define as many attributes as you want, and you can specify any of the following coercion types:

1. `String`
2. `Integer`
3. `Boolean`

## Why?

A while back, I needed serialized attributes but it either didn't work for my use case or it wasn't made yet.  So, I wrote this gem.

## Contributing

__Do not modify the gemspec or version unless you absolutely need to!__

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

