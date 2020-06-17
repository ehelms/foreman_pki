require "foreman_pki/version"
require 'clamp'
require 'openssl'

Dir[File.dirname(__FILE__) + '/foreman_pki/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/foreman_pki/command/*.rb'].each { |file| require file }

module ForemanPki
end
