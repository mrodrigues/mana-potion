# ManaPotion

Do you need to limit some resource's creation rate? It's simple to do it with `ManaPotion`!

The `ManaPotion` gem helps you validate any `ActiveRecord::Base` model so that no user will be able to create it faster than some given limit.
Really useful when you're using an expensive API and don't want some user to bankrupt you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mana-potion'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mana-potion

## Usage

You just need to include the `ManaPotion::Pool` module in your model's class and call the `mana_pool_for` macro. It defaults to limiting the creation by 1 per day.

```ruby
class Post < ActiveRecord::Base
  include ManaPotion::Pool

  mana_pool_for :user
end

user = User.create!
user.posts.create! # No problem here
user.posts.create! # Raises an ActiveRecord::RecordInvalid exception

require 'timecop'
Timecop.travel 1.day.from_now
user.posts.create! # No problem here
```

If you want to configure the limit and/or period, just pass them as parameters to the macro:

```ruby
class Post < ActiveRecord::Base
  include ManaPotion::Pool

  mana_pool_for :user, limit: 10, period: 1.hour
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mana-potion/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
