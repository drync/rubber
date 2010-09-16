$:.unshift(File.dirname(__FILE__))

module Rubber

  @@version  = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION')).chomp

  def self.initialize(project_root, project_env)
    return if defined?(RUBBER_ROOT) && defined?(RUBBER_ENV)

    @@root = project_root
    @@env = project_env
    Object.const_set('RUBBER_ENV', project_env)
    Object.const_set('RUBBER_ROOT', File.expand_path(project_root))

    if defined?(Rails.logger) && Rails.logger
      @@logger = Rails.logger
    else
      @@logger = Logger.new($stdout)
      @@logger.level = Logger::INFO
      @@logger.formatter = lambda {|severity, time, progname, msg| "Rubber[%s]: %s\n" % [severity, msg.to_s.lstrip]}
    end

    # conveniences for backwards compatibility with old names
    Object.const_set('RUBBER_CONFIG', self.config)
    Object.const_set('RUBBER_INSTANCES', self.instances)

  end

  def self.root
    @@root
  end

  def self.env
    @@env
  end

  def self.version
    @@version
  end

  def self.logger
    @@logger
  end

  def self.config
    Rubber::Configuration.rubber_env
  end

  def self.instances
    Rubber::Configuration.rubber_instances
  end
end


require 'rubber/configuration'
require 'rubber/environment'
require 'rubber/generator'
require 'rubber/instance'
require 'rubber/util'
require 'rubber/cloud'
require 'rubber/dns'

if Rubber::Util::is_rails3?
  module Rubber
    require 'rubber/railtie'
  end
end
