# ActiverecordUml

ActiverecordUml draws class diagrams of ActiveRecord models.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_uml'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install activerecord_uml

## Usage

In your Ruby on Rails directory:

```
activerecord_uml User
```

Execute the activerecord_uml command with name of model classes.
Then the activerecord_uml outputs HTML text includes class diagrams of specified model classes. 

For MacOs, I recommend to use the activerecord_uml with [browser](https://gist.github.com/defunkt/318247) command.
Like this:

```
$ brew install browser
```

then

```
activerecord_uml User | browser
```

Open the class diagrams with the browser immediately.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake ` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ledsun/activerecord_uml.
