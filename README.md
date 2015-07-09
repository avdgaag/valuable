# Valuable

Sometimes, your objects are only data and no behaviour. These are value objects,
and they are defined by their _contents_. These objects are immutable, so it is
safe to let them propagate throughout the system.

Being immutable, value objects cannot be modified; their contents are set once
on initialisation. Also, being identified by their contents, two entities with
the same contents are considered equal.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'valuable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install valuable

## Usage

```ruby
class Article
  include Valuable::Entity
  attributes :title, :author, :created_at

  def human_created_at
    super.strftime '%c'
  end
end

article = Article.new(title: 'On Values', author: 'J. Example', created_at: Time.now)
article.title
# => 'On Values'

article = Article.new(title: 'On Values')
# => ArgumentError: missing attributes: author, created_at

article = Article.new(title: 'On Values', author: 'J. Example', created_at: Time.now, tags: ['news'])
# => ArgumentError: unexpected attributes: tags

article1 = Article.new(title: 'On Values', author: 'J. Example', created_at: Time.now)
article2 = Article.new(title: 'On Values', author: 'J. Example', created_at: Time.now)
article1 == article2
# => true

article3 = Article.new(title: 'On Values', author: 'J. Example', created_at: Time.now)
article4 = Article.new(title: 'More Values', author: 'R. Demo', created_at: Time.now)
article3 == article4
# => false
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/avdgaag/valuable. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
