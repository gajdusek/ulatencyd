--! @file 90_hierarchy_labels.lua
--! Implements the HierarchyLabels filter.
--! @ingroup lua_FLAG_FILTERS

--! @class HierarchyLabels
--! @brief Deal processes labelled with `hierarchy:<existing_label>:<new_label>`:
--! A process labelled with `existing_label` will get additionally `new_label`.
--! @implements __FILTER
--! @ingroup lua_FLAG_FILTERS
HierarchyLabels = {
  --! @public @memberof Isolate
  name = "HierarchyLabels",

  --! @return `ulatency.filter_rv(ulatency.FILTER_STOP)`
  --! @public @memberof Isolate
  check = function(self, proc)
    local flags = proc:list_flags()
    local rflags = proc:list_flags(true)
    for _,flag in ipairs(flags) do
      local cond_pieces = flag.name:split(':')
      if #cond_pieces == 3 and cond_pieces[1] == "hierarchy" then  -- is hierarchy label
        local cond_label = cond_pieces[1] -- a label process must be already tagged with
        local new_label = cond_pieces[2] -- to get this label
        for _,f in ipairs(rflags) do
          if f.name == cond_label then
            -- label
            local new_flag, added = ulatency.add_adjust_flag(flags, {name = new_label}, {inherit = cond_flag.inherit})
            if not added then
              proc:add_flag(new_flag)
            end
            break
          end
        end
      end
    end
    return ulatency.filter_rv(ulatency.FILTER_STOP)
  end
}

ulatency.register_filter(HierarchyLabels)