# Muck

Muck is a small-scale MVC framework, inspired by Ruby on Rails, providing all
the basic functionality of Rails (a router, individual routes, controllers, the session).

A user can define all the server side routes and controller methods needed for requests on the frontend
to happen properly. Like Rails, it is heavily reliant on naming conventions, which must be strict. The reason
for this, is in order to properly construct route names, controller names, etc. For example,
in building out the router, we have something like this:

```ruby
[:get, :post, :put, :delete].each do |http_method|
  define_method(http_method) do |pattern, controller_class, action_name|
    add_route(pattern, http_method, controller_class, action_name)
  end
end
```

For each of the basic HTTP methods, it adds the appropriate route, based on the name of the model in question.
