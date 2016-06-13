# Muck

Muck is a small-scale MVC (actually, without the M) framework, inspired by Ruby on Rails, providing all
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

For each of the basic HTTP methods (get, post, put and delete), it adds the appropriate route, based on the name of the model in question. Each is passed additional arguments, specifying the url, the name of the controller in question, and the name of the corresponding method in that controller.

If no route is matched, a 404 error is returned. Otherwise, it runs the route. The Router#match method calls Route#matches?, which determines whether there truly is a matching route. The user can easily build new routes with the model and controller names:

```ruby
def matches?(req)
  pattern.match(req.path) && http_method == req.request_method.downcase.to_sym
end

def run(req, res)
  match_data = pattern.match(req.path)
  params = build_params(match_data)

  controller = controller_class.new(req, res, params)
  controller.invoke_action(@action_name)
end
```

### Features

* Users can create routes by passing in an http method, a path, a controller name and a method name
* Model controllers determine templates to open based on route names
* Setup for controllers is minimal
* Tests included show off flexibility

### To-Do

[ ] Add CSRF authenticity verification
[ ] Add flash
[ ] Enforce strong params to block bad input
[ ] Helpful errors
