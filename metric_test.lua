local internet = require("internet")
local secrets = require("secrets")

local function make_json(name, interval, value, time)
  return string.format(" { \"name\": \"%s\", \"interval\": \"%s\", \"value\": \"%s\", \"time\": \"%s\" }", name,
    interval, value, time)
end


local key = secrets.get_key()
local user_id = secrets.get_user_id()
local config = require("config").get_config()


local header = {
  ["Content-Type"] = "application/json",
  -- ["Authorization"] = string.format("Bearer %s:%s", user_id, key)
}

local body = string.format("[%s, %s]", make_json("test.metric", 10, 69, 1738428786),
  make_json("test.metric", 10, 420, 1738428886));


local handle = internet.request(config.url, body, header, "POST")
local result = ""

for chunk in handle do result = result .. chunk end
print(result)

local mt = getmetatable(handle)

local code, message, headers = mt.__index.response()
print("code = " .. tostring(code))
print("message = " .. tostring(message))
