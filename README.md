# maskable_attributes

maskable attributes provides a simple way to mask the output of a
method.  maskable attributes works really well with the decorator /
presenter pattern.  We are using maskable attributes to hide job
posting information from users who are not signed in.

## Usage

    require 'delegate'
    require 'maskable_attributes'

    class Person < Struct.new(:name, :email, :phone)
    end

    class MaskedPerson < DelegateClass(Person)

      include MaskableAttributes

      masked_attributes :email, :phone

    end

    person = Person.new('Michael', '513-347-1111', 'foo@bar.com')
    masked = MaskedPerson.new(person)

    masked.name  # => "Michael"
    masked.phone # => "************"
    masked.email # => "************"

## Custom strategies

You can provide a string, lambda, or a symbol (representing a
predefined strategy) in order to further customize the masking.

### String

If you provide a string, that string will always be used to mask the
attributes.

    masked_attributes :email, :phone, :with => "HIDDEN"

    masked.phone # => "HIDDEN"
    masked.email # => "HIDDEN"

### lambda / Proc

If you provide a lambda it will be called with the original value
passed to it.  This allows the masking to be different based on the
attribute value.  You can see here we output the same number of stars
as the length of the attribute

    masked_attributes :email, :phone, :with => lambda { |v| "*" * v.size }

    masked.phone # => "************"
    masked.email # => "***********"

### symbols

Currently masked_attributes only provides 1 predefined strategy named
:stars, which provides the same functionality from the lambda example above.

    masked_attributes :email, :phone, :with => :stars

    masked.phone # => "************"
    masked.email # => "***********"

You can easily add more strategies yourself.

    MaskableAttributes.strategies[:dashes] = lambda { |v| "-" * v.size }

    masked_attributes :email, :phone, :with => :dashes

    masked.phone # => "------------"
    masked.email # => "-----------"

## Default string masking

The default masking strategy is a string with 12 *'s.  You can
override the default string masking if you choose to.

    MaskableAttributes.default_masking = "HIDDEN"


## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Michael Guterl. See LICENSE for details.
