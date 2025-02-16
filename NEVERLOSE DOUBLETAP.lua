local refs = {
	autopeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
    accuracy_boost = ui.reference("RAGE", "Other", "Accuracy boost")
}

client.set_event_callback( "setup_command", function( cmd )

    local autopeek = ui.get(refs.autopeek[1]) and ui.get(refs.autopeek[2])
    
    if not autopeek then
        ui.set(refs.accuracy_boost, "Maximum")
    else
        ui.set(refs.accuracy_boost, "Low")
    end

end)