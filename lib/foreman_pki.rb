require "foreman_pki/version"
require 'clamp'
require 'openssl'

Dir[File.dirname(__FILE__) + '/foreman_pki/*.rb'].sort.each { |file| require file }
Dir[File.dirname(__FILE__) + '/foreman_pki/command/*.rb'].sort.each { |file| require file }

module ForemanPki
end
