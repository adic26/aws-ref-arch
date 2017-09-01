# Canary

## Tests

Requirements: 
```
brew install rbenv
rbenv install 2.4.1
rbenv local 2.4.1
gem update --system --no-ri --no-rdoc
gem install bundler --no-ri --no-rdoc
```

To run them:

```
cd spec
bundle install
bundle exec rake spec
```

We use [awspec](https://github.com/k1LoW/awspec) to query AWS.