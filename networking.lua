local internet = require("internet")
local secrets = require("secrets")
local config = require("config")
local component = require("component")


local function get_time()
  -- Get local time from the time server
  local handle = internet.request("http://localhost/time")
  local result = ""
  for chunk in handle do result = result .. chunk end

  return result
end

local function send_metrics(data, interval)
  --construct the resulting data
  local out = "["
  local time = get_time()

  -- Table of tables
  for _, d in pairs(data) do
    local name = d.name:gsub("%s+", "_"):lower()
    local datum = string.format("{ \"metric\": {\"__name__\":\"%s.%s\"}, \"values\":[%s], \"timestamps\":[%s] }\n",
      d.type, name, interval, d.count, time * 1000)

    out = out .. datum
  end


  local auth_data = component.data.encode64(string.format("%s:%s", secrets.get_username(), secrets.get_password()))

  local header = {
    ["Content-Type"] = "application/json",
    ["Authorization"] = string.format("Basic %s", auth_data)
  }

  local url = config.get_config().url


  local response = internet.request(url, out, header, "POST")
  local result = ""

  for chunk in response do result = result .. chunk end

  print(result)


  local mt = getmetatable(response)

  local code, _, _ = mt.__index.response()

  if code ~= 200 then
    print(code)
  end
end

return {
  get_time = get_time,
  send_metrics = send_metrics
}
