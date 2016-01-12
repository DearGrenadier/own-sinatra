require 'rack'

module Rocky
  class Base
    def initialize
      @routes = {}
    end

    attr_reader :routes, :request

    def call(env)
      @request = Rack::Request.new(env)
      verb = @request.request_method
      request_path = @request.path_info
      handler =  @routes.fetch(verb, {}).fetch(request_path, nil)

      if handler
        result = instance_eval(&handler)
        if result.is_a? String
          [200, {}, [result]]
        else
          result
        end
      else
        [404, {}, ["Not found #{verb} #{request_path}"]]
      end
    end

    def get(path, &handler)
      route("GET", path, &handler)
    end

    def post(path, &handler)
      route("POST", path, &handler)
    end

    def delete(path, &handler)
      route("DELETE", path, &handler)
    end

    def put(path, &handler)
      route("PUT", path, &handler)
    end

    def params
      @request.params
    end

    private

    def route(verb, path, &handler)
      @routes[verb] = {}
      @routes[verb][path] = handler
    end
  end

  Application = Base.new

  module Delegator
    def self.delegate(*methods, to:)
      methods.each do |method_name|
        define_method(method_name) do |*args, &block|
          to.send(method_name, *args, &block)
        end
      end
    end

    delegate :get, :post, :delete, :patch, :put, to: Application
  end
end

include Rocky::Delegator
