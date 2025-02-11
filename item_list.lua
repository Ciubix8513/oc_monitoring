local function get_items()
  return {
    "Carbon Dust",
    "Copper Ingot",
    "Enriched Naquadah Dust",
    "Infinity Catalyst Dust",
    "Iridium Dust",
    "Iron Ingot",
    "Lapotron Dust",
    "Naquadahine Dust",
    "Naquadria Dust",
    "Neutronium Ingot",
    "Osmium Dust",
    "Samarium Ingot",
    "Thorium Dust",
    "Titanium Dust",
    "Tungsten Dust",
  }
end

local function get_fluids()
  return {
    "Hydrogen Gas",
    "Oxygen Gas",
    "Hydrochloric Acid",
    "Hydrofluoric Acid",
    "Phosphoric Acid",
    "Phthalic Acid",
    "Sulfuric Acid",
    "Raw Growth Catalyst Medium",
    "Molten Epoxid",
    "Molten Polybenzimidazole",
    "Molten Polyethylene",
    "Molten Polytetrafluoroethylene",
    "Molten Polyvinyl Chloride",
    "Molten Silicone Rubber",
  }
end

return {
  get_items = get_items,
  get_fluids = get_fluids
}
