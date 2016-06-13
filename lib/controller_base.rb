require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params
  attr_accessor :already_built_response

  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params
    @already_built_response = false
  end

  # builds a semantically-clear helper method for the ivar
  def already_built_response?
    @already_built_response
  end

  # Builds the appropriate response for a redirect.
  # Otherwise, raises an exception
  def redirect_to(url)
    if !already_built_response?
      @res.status = 302
      @res.header['location'] = url
      session.store_session(@res)
      already_built_response = true
    else
      raise
    end
  end

  # Builds the appropriate response for a render.
  # Otherwise, raises an exception
  def render_content(content, content_type)
    unless already_built_response?
      @res.write(content)
      @res['Content-Type'] = content_type
      session.store_session(@res)
      already_built_response = true
    else
      raise
    end
  end

  # Actually renders the template specified in the argument, based on the
  # controller calling the method
  def render(template_name)
    controller_name = self.class.to_s.underscore
    path = "views/#{controller_name}/#{template_name}.html.erb"
    content = ERB.new(File.read(path)).result(binding)
    render_content(content, "text/html")
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    self.send(name)
  end
end
