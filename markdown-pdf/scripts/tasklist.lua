function BulletList(list)
  local changed = false
  for i, item in ipairs(list.content) do
    if item and item.attr and item.attr.classes then
      local has_task = false
      for _, cls in ipairs(item.attr.classes) do
        if cls == "task-list-item" then
          has_task = true
          break
        end
      end
      if has_task and item.content and #item.content > 0 then
        local first = item.content[1]
        local checked = false
        if first and first.t == "Plain" and first.content and #first.content > 0 then
          local inline = first.content[1]
          if inline and inline.t == "Str" then
            if inline.text == "☒" or inline.text == "☑" or inline.text == "[x]" or inline.text == "[X]" then
              checked = true
            end
          end
        end
        local marker = checked and "☑ " or "☐ "
        if first and (first.t == "Plain" or first.t == "Para") then
          table.insert(first.content, 1, pandoc.Str(marker))
          if #first.content > 1 then
            local second = first.content[2]
            if second and second.t == "Space" then
              table.remove(first.content, 2)
            end
          end
          if #first.content > 1 then
            local maybe_checkbox = first.content[2]
            if maybe_checkbox and maybe_checkbox.t == "Str" and (maybe_checkbox.text == "☒" or maybe_checkbox.text == "☑" or maybe_checkbox.text == "☐" or maybe_checkbox.text == "[x]" or maybe_checkbox.text == "[X]" or maybe_checkbox.text == "[ ]") then
              table.remove(first.content, 2)
              if #first.content > 1 and first.content[2] and first.content[2].t == "Space" then
                table.remove(first.content, 2)
              end
            end
          end
          item.attr.classes = {}
          changed = true
        end
      end
    end
  end
  if changed then
    list.attr = pandoc.Attr("", {}, {})
    return list
  end
end
