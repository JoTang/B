require "kemal"
require "./config"

module B
  get "/" do
    "Hello World!"
  end

  get "/transaction" do |context|
    context.response.content_type = "application/json"
    datas = [] of Hash(String, Int64 | Float64 | String)
    DB.open DATABASE_URL do |db|
      db.query "select id, amount, time, ip, ua, description from transactions order by time desc" do |rs|
        rs.each do
          datas << {
            "id" => rs.read(Int64),
            "amount" => rs.read(Float64),
            "time" => rs.read(Int64),
            "ip" => rs.read(String),
            "ua" => rs.read(String),
            "description" => rs.read(String)
          }
        end
      end
    end
    datas.to_json
  end

  post "/transaction" do |context|
    context.response.content_type = "application/json"
    headers = context.request.headers
    begin
      data = {
        "amount" => context.params.json["amount"].as(Int64 | Float64),
        "description" => context.params.json["description"].as(String),
        "ua" => headers.fetch("User-Agent", "Unknown").as(String),
        "ip" => headers.fetch("X-Real-Ip", headers.fetch("X-Forwarded-For", "127.0.0.1")).as(String),
        "time" => context.params.json.fetch("time", Time.now.epoch_ms).as(Int64)
      }
    rescue
      context.response.status_code = 401
      next {
        "error": "invalid input"
      }.to_json
    end

    args = [] of DB::Any
    args << data["amount"]
    args << data["time"]
    args << data["ip"]
    args << data["ua"]
    args << data["description"]
    DB.open DATABASE_URL do |db|
      rv = db.exec("insert into transactions (amount, time, ip, ua, description) values (?, ?, ?, ?, ?)", args)
      data["id"] = rv.last_insert_id
    end

    context.response.status_code = 201
    # Todo: Return new transaction WITH ID
    data.to_json
  end
end
