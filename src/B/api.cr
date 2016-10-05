require "kemal"
require "./config"

module B
  get "/" do
    "Hello World!"
  end

  get "/transaction" do |env|
    env.response.content_type = "application/json"
    datas = [] of Hash(String, Int64 | String)
    DB.open DATABASE_URL do |db|
      db.query "select id, amount, time, ip, ua, description from transactions order by time desc" do |rs|
        rs.each do
          datas << {
            "id" => rs.read(Int64),
            "amount" => rs.read(Int64),
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

  post "/transaction" do |env|
    env.response.content_type = "application/json"
    begin
      data = {
        "amount" => env.params.json["amount"].as(Int64),
        "description" => env.params.json["description"].as(String),
        "time" => env.params.json.fetch("time", Time.now.epoch_ms).as(Int64)
      }
    rescue
      env.response.status_code = 401
      next {
        "error": "invalid input"
      }.to_json
    end

    env.response.status_code = 201
    # Todo: Return new transaction WITH ID
    data.to_json
  end
end
