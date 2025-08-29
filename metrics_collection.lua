local item_list = require("item_list")
local component = require("component")

local function extract_eu(str, ind)
  local num = 1
  for i in str:gmatch("[^%s]+") do
    if num == ind then
      return i:gsub(",", ""):gsub("§c", "")
    end
    num = num + 1
  end
end

local function get_metrics()
  local i_list = item_list.get_items()
  local index = 1
  local metrics = {}

  local me_items = component.me_interface.getItemsInNetwork()

  for _, i in pairs(i_list) do
    local size = 0
    for _, me_item in pairs(me_items) do
      if me_item.label == i then
        -- This is the correct item
        size = me_item.size
        break
      end
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
  local me_fluids = component.me_interface.getFluidsInNetwork()

  for _, i in pairs(f_list) do
    local count = 0

    for _, f in pairs(me_fluids) do
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
    local data         = gt.getSensorInformation()

    local eu           = extract_eu(data[2], 3)
    -- Avg EU IN: 102,007,470 (last 5 seconds)
    local eui          = extract_eu(data[10], 4)
    -- Avg EU OUT: 102,007,470 (last 5 seconds)
    local euo          = extract_eu(data[11], 4)
    local w_eu         = extract_eu(data[23], 4)

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
    metrics[index + 3] = {
      type = "energy",
      name = "wireless_eu",
      count = w_eu,
    }
  end

  return metrics
end

return {
  get_metrics = get_metrics
}
