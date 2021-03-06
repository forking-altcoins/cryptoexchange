require 'spec_helper'

RSpec.describe 'Novadax integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:brc_brl_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BTC', target: 'BRL', market: 'novadax') }

  it 'fetch pairs' do
    pairs = client.pairs('novadax')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'novadax'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url 'novadax', base: brc_brl_pair.base, target: brc_brl_pair.target
    expect(trade_page_url).to eq "https://www.novadax.com/product/orderbook?pair=BTC_BRL"
  end

  it 'fetch ticker' do
    ticker = client.ticker(brc_brl_pair)

    expect(ticker.base).to eq 'BTC'
    expect(ticker.target).to eq 'BRL'
    expect(ticker.market).to eq 'novadax'
    expect(ticker.last).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil

    expect(ticker.payload).to_not be nil
  end

  it 'fetch order book' do
    order_book = client.order_book(brc_brl_pair)

    expect(order_book.base).to eq 'BTC'
    expect(order_book.target).to eq 'BRL'
    expect(order_book.market).to eq 'novadax'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.timestamp).to be_nil
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trade' do
    trades = client.trades(brc_brl_pair)
    trade = trades.sample

    expect(trades).to_not be_empty
    expect(trade.trade_id).to be_nil
    expect(trade.base).to eq 'BTC'
    expect(trade.target).to eq 'BRL'
    expect(['buy', 'sell']).to include trade.type
    expect(trade.price).to_not be_nil
    expect(trade.amount).to_not be_nil
    expect(trade.timestamp).to be_a Numeric
    expect(trade.payload).to_not be nil
    expect(trade.market).to eq 'novadax'
  end

end
