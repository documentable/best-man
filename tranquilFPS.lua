local ui = ui
local client = client
local entity = entity


local fps_modes = {
    "off",
    "performance",
    "balanced",
    "low end"
}


local fps_setting = ui.new_combobox("MISC", "Settings", "fpsbooster", unpack(fps_modes))


local function apply_fps_settings()
    local mode = ui.get(fps_setting)

    if mode == "Off" then
        client.exec("cl_forcepreload 0")
        client.exec("mat_queue_mode -1")
        client.exec("r_eyegloss 1")
        client.exec("r_eyemove 1")
        client.exec("r_shadows 1")
        client.exec("cl_csm_enabled 1")
        client.exec("cl_showfps 0")
        client.color_log(255, 255, 255, "disabled optimizations.")
        return
    end

    client.exec("cl_forcepreload 1") 
    client.exec("mat_queue_mode 2")
    client.exec("r_eyegloss 0") 
    client.exec("r_eyemove 0") 
    client.exec("r_shadows 0")
    client.exec("cl_csm_enabled 0") 
    client.exec("cl_showfps 1")
    client.exec("mat_disable_bloom 1") 
    client.exec("r_dynamic 0") 
    client.exec("violence_hblood 0")  

    if mode == "performance" then
        client.exec("fps_max 0")  
        client.exec("r_drawtracers_firstperson 0")  
        client.exec("mat_postprocess_enable 0") 
        client.exec("cl_autohelp 0")  
        client.exec("r_drawrain 0") 
        client.exec("r_drawparticles 0") 
        client.exec("r_lod 3") 
        client.exec("r_cheapwaterstart 1")  
        client.exec("r_cheapwaterend 1")
        client.exec("cl_jiggle_bone_framerate_cutoff 0")  
        client.exec("r_decal_cullsize 2048") 
        client.exec("cl_ejectbrass 0") 
        client.exec("mat_bloomscale 0") 
        client.exec("cl_ragdoll_physics_enable 0") 
        client.exec("r_cleardecals") 
        client.color_log(0, 255, 0, "[FPS Booster] Max FPS mode applied! All possible optimizations applied.")

    elseif mode == "Balanced" then
        client.exec("fps_max 200")
        client.exec("r_drawtracers_firstperson 1") 
        client.exec("mat_postprocess_enable 1")
        client.exec("r_drawrain 1")  
        client.exec("r_lod 1") 
        client.exec("cl_jiggle_bone_framerate_cutoff 15") 
        client.color_log(255, 165, 0, "[FPS Booster] Balanced mode applied!")

  
    elseif mode == "Low-End PC" then
        client.exec("fps_max 60")
        client.exec("r_drawtracers_firstperson 0")
        client.exec("mat_postprocess_enable 0")
        client.exec("r_lod 3")  
        client.exec("r_cheapwaterstart 1")
        client.exec("r_cheapwaterend 1")
        client.exec("violence_hblood 0")
        client.exec("r_decal_cullsize 2048") 
        client.exec("cl_ejectbrass 0") 
        client.exec("mat_bloomscale 0") 
        client.exec("cl_ragdoll_physics_enable 0")
        client.exec("r_cleardecals") 
        client.color_log(255, 0, 0, "[FPS Booster] Low-End PC mode applied!")
    end
end

ui.set_callback(fps_setting, apply_fps_settings)

apply_fps_settings()
