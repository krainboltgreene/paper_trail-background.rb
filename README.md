# paper_trail-background

  - [![Build](http://img.shields.io/travis-ci/krainboltgreene/paper_trail-background.svg?style=flat-square)](https://travis-ci.org/krainboltgreene/paper_trail-background)
  - [![Downloads](http://img.shields.io/gem/dtv/paper_trail-background.svg?style=flat-square)](https://rubygems.org/gems/paper_trail-background)
  - [![Version](http://img.shields.io/gem/v/paper_trail-background.svg?style=flat-square)](https://rubygems.org/gems/paper_trail-background)


Allows you to enqueue version creation/deletion as a background job to avoid having business logic blocked by changelog writing.


## Using

First you'll need to setup a job for processing versions:

``` ruby
# The class MUST be named this
class VersionJob < ApplicationJob

  # These are settings you'll probably want, I suggest sidekiq-unique-jobs
  sidekiq_options(
    :queue => "versions",
    :unique_across_queues => true,
    :lock => :until_executed,
    :log_duplicate_payload => true
  )

  # This wires up the background job
  include PaperTrail::Background::Sidekiq
end
```


## Installing

Run this command in your project:

    $ bundle add paper_trail-background

Or install it yourself with:

    $ gem install paper_trail-background


## Contributing

  1. Read the [Code of Conduct](/CONDUCT.md)
  2. Fork it
  3. Create your feature branch (`git checkout -b my-new-feature`)
  4. Commit your changes (`git commit -am 'Add some feature'`)
  5. Push to the branch (`git push origin my-new-feature`)
  6. Create new Pull Request


## Todo

  - Support other job types
  - Allow for configuring the job class name
