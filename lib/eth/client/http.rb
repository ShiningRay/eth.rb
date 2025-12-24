# Copyright (c) 2016-2025 The Ruby-Eth Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "uri"
require "httpx"

# Provides the {Eth} module.
module Eth

  # Provides an HTTP/S-RPC client with basic authentication.
  class Client::Http < Client

    # The host of the HTTP endpoint.
    attr_reader :host

    # The port of the HTTP endpoint.
    attr_reader :port

    # The full URI of the HTTP endpoint, including path.
    attr_reader :uri

    # Attribute indicator for SSL.
    attr_reader :ssl

    # Attribute for user.
    attr_reader :user

    # httpx client instance
    attr_reader :http

    # Constructor for the HTTP Client. Should not be used; use
    # {Client.create} instead.
    #
    # @param host [String] an URI pointing to an HTTP RPC-API.
    def initialize(host)
      super
      uri = URI.parse(host)
      raise ArgumentError, "Unable to parse the HTTP-URI!" unless ["http", "https"].include? uri.scheme
      @host = uri.host
      @port = uri.port
      @ssl = uri.scheme == "https"
      @http = HTTPX.with(pool_options: { max_connections: ENV.fetch("HTTP_MAX_CONNECTIONS", 10).to_i, max_connections_per_origin: ENV.fetch("HTTP_MAX_CONNECTIONS_PER_ORIGIN", 5).to_i, pool_timeout: ENV.fetch("HTTP_POOL_TIMEOUT", 10).to_i }).plugin(:persistent)

      if ENV['HTTP_KEEPALIVE_TIMEOUT']
        @http = @http.with(timeout: {keep_alive_timeout: ENV.fetch("HTTP_KEEPALIVE_TIMEOUT", 300).to_i})
      end

      if !(uri.user.nil? && uri.password.nil?)
        @user = uri.user
        @password = uri.password
        @http = @http.plugin(:basic_auth).with(@user, @password )
      end
      
      @http = @http.with(headers: { "Content-Type" => "application/json" })
      @client = HTTPX.plugin(:persistent).with(headers: { "Content-Type" => "application/json" })
    end

    # Sends an RPC request to the connected HTTP client.
    #
    # @param payload [Hash] the RPC request parameters.
    # @return [String] a JSON-encoded response.
    def send_request(payload)
      response = http.post(@uri, body: payload)
      response.raise_for_status
      response.to_s
    end
  end

  private

  # Attribute for password.
  attr_reader :password
end
