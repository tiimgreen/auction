require File.expand_path('../place_bid', __FILE__)

class AuctionSocket
  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env

    if socket_request?
      spawn_socket.rack_response
    else
      @app.call(env)
    end
  end

  private

  attr_reader :env

  def socket_request?
    Faye::WebSocket.websocket? env
  end

  def spawn_socket
    socket = Faye::WebSocket.new env

    socket.on :open do
      socket.send 'Hello'
    end

    socket.on :message do |event|
      socket.send event.data

      begin
        tokens = event.data.split(' ')
        operation = tokens.delete_at(0)

        case operation
        when 'bid'
          bid(socket, tokens)
        end
      rescue Exception => e
        p e
        p e.backtrace
      end
    end

    socket
  end

  private

  def bid(socket, tokens)
    service = PlaceBid.new(
      value: tokens[2],
      user_id: tokens[1],
      product_auction_id: tokens[0]
    )

    service.execute

    socket.send 'bidok'
  end
end
