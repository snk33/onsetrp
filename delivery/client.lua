local Dialog = ImportPackage("dialogui")
local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local deliveryNPC
local deliveryNpcMenu
local deliveryMenu

AddRemoteEvent("SetupDelivery", function(deliverynpc) 
    deliveryNPC = deliverynpc
end)

AddEvent("OnTranslationReady", function()
    deliveryNpcMenu = Dialog.create(_("delivery_menu"), nil, _("start_stop_delivery") ,_("cancel"))
    deliveryMenu = Dialog.create(_("delivery_menu"), nil, _("next_delivery"), _("finish_delivery"), _("cancel"))
end)

AddEvent("OnKeyPress", function( key )
    if key == "E" then
        local x, y, z = GetPlayerLocation()
        local streamedNPC = GetStreamedNPC()

        for k,v in pairs(streamedNPC) do
            if v == deliveryNPC then
                local x2, y2, z2 = GetNPCLocation(deliveryNPC)
                local dist = GetDistance3D(x, y, z, x2, y2, z2)

                if dist < 150.0 then
                    Dialog.show(deliveryNpcMenu)
                end
            end
        end
        
    end
    if key == "F3" then
        CallRemoteEvent("OpenDeliveryMenu")
    end
end)


AddEvent("OnDialogSubmit", function(dialog, button, ...)
	if dialog == deliveryNpcMenu then
		if button == 1 then
            CallRemoteEvent("StartStopDelivery")
        end
    end
    if dialog == deliveryMenu then
        if button == 1 then
            CallRemoteEvent("NextDelivery")
        end
        if button == 2 then
            CallRemoteEvent("FinishDelivery")
        end
    end
end)

AddRemoteEvent("DeliveryMenu", function()
    Dialog.show(deliveryMenu)
end)