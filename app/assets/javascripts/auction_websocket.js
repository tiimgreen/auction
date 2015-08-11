var AuctionSocket = function(user_id, auction_id, form) {
  this.user_id = user_id;
  this.auction_id = auction_id;
  this.form = $(form);

  this.socket = new WebSocket(App.websocket_url + 'auctions/' + this.auction_id);

  this.initBinds();
};

AuctionSocket.prototype.initBinds = function() {
  var _this = this;

  // When the form is submitted, prevent default and send the value to
  // sendBid();
  // {{ step_1 }}
  this.form.submit(function(e) {
    e.preventDefault();
    _this.sendBid($("#bid_value").val());
  });

  // Client receives message and is decoded and designated to its own function
  // {{ step_7 }}
  this.socket.onmessage = function(e) {
    var tokens = e.data.split(' ');
    console.log('tokens: ' + tokens);

    switch(tokens[0]) {
      case 'bidok':
        _this.bid();
        break;
      case 'underbid':
        _this.underbid(tokens[1]);
        break;
      case 'outbid':
        _this.outbid(tokens[1]);
        break;
      case 'won':
        _this.won();
        break;
      case 'lost':
        _this.lost();
        break;
    }

    console.log(e);
  }
};

AuctionSocket.prototype.sendBid = function(value) {
  this.value = value;
  var template = "bid {{product_auction_id}} {{user_id}} {{value}}";

  // Sends data to server
  // {{ step_2 }}
  this.socket.send(Mustache.render(template, {
    user_id: this.user_id,
    product_auction_id: this.auction_id,
    value: value
  }));
};

AuctionSocket.prototype.bid = function() {
  this.form.find('.message strong').html(
    'Current bid: ' + this.value + ' <span class="label label-success">Your BID!</span>'
  );
}

AuctionSocket.prototype.underbid = function(value) {
  this.form.find('.message strong').html(
    'Your bid is under: ' + value
  );
}

AuctionSocket.prototype.outbid = function(value) {
  this.form.find('.message strong').html(
    'Current bid: ' + value + ' <span class="label label-danger">OUTBID!</span>'
  );
}

AuctionSocket.prototype.won = function() {
  this.form.find('.message strong').html(
    'You won! ' + this.value
  );
}

AuctionSocket.prototype.lost = function() {
  this.form.find('.message strong').html(
    'You lost the auction.'
  );
}
