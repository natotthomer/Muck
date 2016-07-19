require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'

class User
  def self.all
    [
      { id: 1, name: "Brian" },
      { id: 2, name: "Andrew" }
    ]
  end
end

class Post
  def self.all
    [
      { id: 1, user_id: 1, text: "Brian loves string!" },
      { id: 2, user_id: 2, text: "Hi, this is a post!!" },
      { id: 3, user_id: 1, text: "Oh boy, really heating up in here!!" }
    ]
  end
end

class PostsController < ControllerBase
  @posts = Post.all
  def index
    posts = Post.all.select do |post|
      post[:user_id] == Integer(params['user_id'])
    end

    render :index
  end
end

class UsersController < ControllerBase
  @users = User.all
  def index
    render :index @users
  end

  def create
    user = { id: @users.length, name: params["user"]["name"] }
    @users.push(user)
    redirect_to "/users"
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/users$"), UsersController, :index
  get Regexp.new("^/users/(?<user_id>\\d+)/posts$"), PostsController, :index
end

class MyController < ControllerBase
  def go
    session["count"] ||= 0
    session["count"] += 1
    render :counting_show
  end
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
