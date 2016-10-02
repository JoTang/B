require "./spec_helper"
require "sqlite3"

describe B do
  start

  # You can use get,post,put,patch,delete to call the corresponding route.
  it "renders /" do
    get "/"
    response.body.should eq "Hello World!"
  end

  it "response with no transaction data at first" do
    get "/transaction"
    response.body.should eq "[]"
  end

  it "response with one transaction data" do
    DB.open B::DATA_URL do |db|
      db.exec "insert into transactions values (321, -23, 65535, '10.10.10.2', 'user-agent', 'desc')"
    end
    get "/transaction"
    response.body.should eq [{
      "id" => 321,
      "amount" => -23,
      "time" => 65535,
      "ip" => "10.10.10.2",
      "ua" => "user-agent",
      "description" => "desc"
    }].to_json
  end

  it "order transactions with time desc" do
    DB.open B::DATA_URL do |db|
      db.exec "insert into transactions values (322, -23, 65537, '10.10.10.4', 'user-agent', 'desc')"
      db.exec "insert into transactions values (323, -23, 65533, '10.10.10.9', 'user-agent', 'desc')"
    end
    get "/transaction"
    response.body.should eq [
      {
        "id" => 322,
        "amount" => -23,
        "time" => 65537,
        "ip" => "10.10.10.4",
        "ua" => "user-agent",
        "description" => "desc"
      }, {
        "id" => 321,
        "amount" => -23,
        "time" => 65535,
        "ip" => "10.10.10.2",
        "ua" => "user-agent",
        "description" => "desc"
      }, {
        "id" => 323,
        "amount" => -23,
        "time" => 65533,
        "ip" => "10.10.10.9",
        "ua" => "user-agent",
        "description" => "desc"
      }
    ].to_json
  end

  stop
end
