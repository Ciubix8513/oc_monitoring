local networking = require("networking")
local metrics = require("metrics_collection")

local interval = 10

while true do
  local data = metrics.get_metrics()
  pcall(networking.send_metrics, data, interval)
  print("sent some metrics")

  os.sleep(interval)
end
