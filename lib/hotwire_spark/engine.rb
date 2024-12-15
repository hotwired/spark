require "action_cable/server/base"

module HotwireSpark
  class Engine < ::Rails::Engine
    isolate_namespace HotwireSpark
  end
end
