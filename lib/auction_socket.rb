require File.expand_path('../place_bid', __FILE__)

class AuctionSocket
  def initialize(app)
    @app = app
  end

  # This function is automatically called by Rails as it is middleware
  # {{ step_3 }}
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

  # Decode message and act on it, including making a bid
  # {{ step_5 }}
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

  # Make a bid and sends the response back to the client
  # {{ step_6 }}
  def bid(socket, tokens)
    service = PlaceBid.new(
      value: tokens[2],
      user_id: tokens[1],
      product_auction_id: tokens[0]
    )

    socket.send(service.execute ? 'bidok' : "underbid #{service.auction.current_bid}")
  end
end
