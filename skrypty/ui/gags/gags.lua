scripts.gags = scripts.gags or {
    own_spec_prefix = ""
}

local combat_types = {
    "combat.avatar",
    "combat.team",
    "combat.others",
    "room.combat"
}

function scripts.gags:is_combat()
    return gmcp and gmcp.gmcp_msgs and table.index_of(combat_types, gmcp.gmcp_msgs.type)
end

function scripts.gags:is_type(type)
    return gmcp and gmcp.gmcp_msgs and gmcp.gmcp_msgs.type == type
end

function scripts.gags:gag(power, total_power, kind)
    self:gag_prefix(string.format("%d/%d", power, total_power), kind)
end

function scripts.gags:gag_spec(prefix, power, total_power, kind)
    local own_prefix = prefix == "" and "" or prefix .. " "
    self:gag_prefix(string.format("%s%d/%d", own_prefix, power, total_power), kind)
end

function scripts.gags:gag_own_spec(power, total_power)
    if total_power then
        self:gag_spec(self.own_spec_prefix, power, total_power, "moje_spece")
    else
        local own_prefix = self.own_spec_prefix == "" and "" or self.own_spec_prefix .. " "
        self:gag_prefix(string.format("%s%s", own_prefix, power), "moje_spece")
    end
end

function scripts.gags:gag_prefix(gag_prefix, kind)
    if self:delete_line(kind) then
        return
    end
    selectCurrentLine()
    local str_replace = string.format("[%s] ", gag_prefix)
    prefix(str_replace)
    if selectString(str_replace, 1) > -1 then
        fg(scripts.gag_colors[kind])
    end
    resetFormat()
end

function scripts.gags:delete_line(kind)
    if scripts.gag_settings[kind] == 1 then
        deleteLine()
        return true
    end
end

function scripts.gags:who_hits()
    local who
    if self:is_type("combat.avatar") then
        who = rex.match(line, "\\b(?:ciebie|cie|ci)\\b") and "innych_ciosy_we_mnie" or "moje_ciosy"
    else
        who = "innych_ciosy"
    end
    return who
end
