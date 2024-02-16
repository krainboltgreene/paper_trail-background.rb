# paper_trail-background

Allows you to enqueue version creation/deletion as a background job to avoid having business logic blocked by changelog writing.


## Using

First you'll need to setup a job for processing versions:

``` ruby
# The class MUST be named this
class VersionJob < ApplicationJob
  queue_as :default

  # This wires up the background job
  include PaperTrail::Background::Job
end
```

## Configuration
In an initializer, you can specify whether you want to opt into this behavior on a per-model basis:

``` ruby
PaperTrail::Background::Config.configure do |config|
  config.opt_in = true
end
```

If opt-in behavior is set to `true`, you can enable async paper trails by specifying `async: true` in a given model's paper trail options:

``` ruby
class SomeModel < ActiveRecord::Base
  has_paper_trail async: true
end
```

## Installing

Run this command in your project:

    $ bundle add paper_trail-background

Or install it yourself with:

    $ gem install paper_trail-background


## Contributing

  1. Read the [Code of Conduct](/CONDUCT)
  2. Fork it
  3. Create your feature branch (`git checkout -b my-new-feature`)
  4. Commit your changes (`git commit -am 'Add some feature'`)
  5. Push to the branch (`git push origin my-new-feature`)
  6. Create new Pull Request


## Todo

  - Support other job types
  - Allow for configuring the job class name
