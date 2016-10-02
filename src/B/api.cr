require "kemal"
require "./config"

module B
  get "/" do
    "Hello World!"
  end

  get "/transaction" do |env|
    env.response.content_type = "application/json"
    datas = [] of Hash(String, Int32 | String)
    DB.open DATA_URL do |db|
      db.query "select id, amount, time, ip, ua, description from transactions order by time desc" do |rs|
        rs.each do
          datas << {
            "id" => rs.read(Int32),
            "amount" => rs.read(Int32),
            "time" => rs.read(Int32),
            "ip" => rs.read(String),
            "ua" => rs.read(String),
            "description" => rs.read(String)
          }
        end
      end
    end
    datas.to_json
  end
end
