require "./spec_helper"
require "sqlite3"

describe B do
  # You can use get,post,put,patch,delete to call the corresponding route.
  it "renders /" do
    get "/"
    response.body.should eq "Hello World!"
  end

  it "response with no transaction data at first" do
    DB.open B::DATABASE_URL do |db|
      db.exec "delete from transactions"
    end
    get "/transaction"
    response.body.should eq "[]"
  end

  it "response with one transaction data" do
    DB.open B::DATABASE_URL do |db|
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
    DB.open B::DATABASE_URL do |db|
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

  it "returns 401 when input is invalid" do
    post "/transaction", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {
      amount: 321
    }.to_json

    response.status_code.should eq 401

    post "/transaction", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {
      description: "Foo"
    }.to_json

    response.status_code.should eq 401

    post "/transaction", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {
      amount: "ww",
      description: "2321"
    }.to_json

    response.status_code.should eq 401
  end

  it "returns 201 when create successful" do
    post "/transaction", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {
      amount: 321,
      description: "2321",
      time: Time.now.epoch_ms
    }.to_json

    response.status_code.should eq 201
  end

  it "returns 201 when emit time" do
    post "/transaction", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {
      amount: 321,
      description: "2321"
    }.to_json

    response.status_code.should eq 201
  end

  it "creates transaction entry in DB" do
    DB.open B::DATABASE_URL do |db|
      db.exec "delete from transactions"
      db.scalar("select count(*) from transactions").should eq(0)
    end

    post "/transaction", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: {
      amount: 321,
      description: "2321"
    }.to_json

    DB.open B::DATABASE_URL do |db|
      db.scalar("select count(*) from transactions").should eq(1)
    end

  end
end
