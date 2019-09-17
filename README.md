# Ruby on Rails Tutorial Liquid Application

This is the sample app for
[*Ruby on Rails Tutorial: Learn Web Development with Rails*](http://www.railstutorial.org) by [Michael Hartl](http://www.michaelhartl.com).

## License

All source code in the [Ruby on Rails Tutorial](http://www.railstutorial.org/) is available jointly
under MIT License and the Beerare License. See [LICENSE.md](LICENSE.md) for details.

## Getting started

To get started with the app, clone the repo and then install the needed gems:


```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in local server:

```
$ rails server
```

For more information, see the
[*Ruby on Rails Tutorial* book](http:://www.railstutorial.org/book).
