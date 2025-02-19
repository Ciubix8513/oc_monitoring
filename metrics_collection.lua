local item_list = require("item_list")
local component = require("component")

local function extract_eu(str)
  local num = 1
  for i in str:gmatch("[^%s]+") do
    if num == 4 then
      return i:gsub(",", "")
    end
    num = num + 1
  end
end

local function get_metrics()
  local i_list = item_list.get_items()
  local index = 1
  local metrics = {}

  for _, i in pairs(i_list) do
    local size = 0

    local item = component.me_interface.getItemsInNetwork({ label = i })

    if item[1] ~= nil then
      size = item[1].size
    end

    metrics[index] = {
      type = "item",
      name = i,
      count = size
    }


    if size == 0 then
      print("No item" .. i)
    end

    index = index + 1
  end

  local f_list = item_list.get_fluids()

  for _, i in pairs(f_list) do
    local count = 0

    for _, f in pairs(component.me_interface.getFluidsInNetwork()) do
      if f.label == i then
        count = f.amount
      end
    end


    metrics[index] = {
      type = "fluid",
      name = i,
      count = count
    }

    if count == 0 then
      print("No fluid " .. i)
    end

    index = index + 1
  end

  local res, gt = pcall(component.getPrimary, "gt_machine")
  if res == true then
    local eu           = gt.getEUStored()
    local data         = gt.getSensorInformation()

    -- Avg EU IN: 102,007,470 (last 5 seconds)
    local eui          = extract_eu(data[10])
    -- Avg EU OUT: 102,007,470 (last 5 seconds)
    local euo          = extract_eu(data[11])

    metrics[index]     = {
      type = "energy",
      name = "eu_stored",
      count = eu
    }
    metrics[index + 1] = {
      type = "energy",
      name = "eu_input",
      count = eui
    }
    metrics[index + 2] = {
      type = "energy",
      name = "eu_output",
      count = euo
    }
  end

  return metrics
end

return {
  get_metrics = get_metrics
}
